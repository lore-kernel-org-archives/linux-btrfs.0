From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC] Improve btrfs subvolume find-new command
Date: Mon, 13 Dec 2010 09:56:52 +0800
Message-ID: <4D057D64.7080304@cn.fujitsu.com>
References: <201012112347.10004.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012112347.10004.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2010 06:47 AM, Goffredo Baroncelli wrote:
> Hi all,
> 
> enclose a patch to improve the "btrfs subvolume find-new" command. This is a 
> RFC because it is not finished, but it is an usable state and may be 
> discussed. The aim of this patch is:
> - take in account not only an update of the extent but also an update of the 
> inode and xattr (which includes the acl)
> - extract the generation reference number directly from a snapshot
> 
> The new syntax is:
> 
>   btrfs subvolume find-new [-v|--verbose][-s|--subvol]<path> <last_gen>
>        List the recently modified files in a filesystem.
> 
> the switch -v increase the verbosity of the output (see example below); if the 
> switch '-s' is passed <last_gen> is not a number, but a snapshot path from 
> which the command extract the generation number.
> 
> Examples
> 
> # btrfs subvolume find-new rootfs/ -s snap-20101207
> tmp
> var/log/exim4/mainlog
> var/log/kdm.log
> var/log/daemon.log
> var/log/kern.log
> var/log/syslog
> var/log/messages
> var/log/wtmp
> var/log/auth.log
> var/tmp/kdecache-ghigo/icon-cache.kcache
> var/tmp/kdecache-ghigo/plasma_theme_default.kcache
> var/run/utmp
> var/log/Xorg.0.log
> var/run/freepops.pid
> [...]
> 
> 
> # btrfs subvolume find-new -v snap-20101207 10639
> inode 485761 name tmp/paperopoli
>    INODE: mode 0x000041ed gen 12326 nbyte 0 nlink 1 uid 0 gid 0 flags 0x0000
> inode 485762 name tmp/paperopoli/topolinea
>    XATTR: namelen 10 datalen 10 name user.pippo
> inode 485764 name tmp/paperopoli/metropolis
>    INODE: mode 0x000081ac gen 12347 nbyte 7 nlink 1 uid 0 gid 0 flags 0x0000
>    XATTR: namelen 23 datalen 52 name system.posix_acl_access
>    XATTR: namelen 11 datalen 13 name user.pluto3
>    XATTR: namelen 10 datalen 13 name user.pluto
>    EXTENT: file offset 0 len 7 disk start 0 offset 0 gen 12326 flags INLINE
> 
> 
> The output above means:
> - file "tmp/paperopoli", inode 485761, the inode is updated
> - file "tmp/paperopoli/topolinea", inode 485762, the extended attribute 
> "user.pippo" is updated
> - file "tmp/paperopoli/metropolis", inode 485764, the inode, an extent and 
> some xtended attribute and the acl (system.posix_acl_access) are updated
> 
> Open point:
> 
> - are really useful so too much information ?(I think that we can short the 
> inode line without loosing anything) . Another option is to make less verbose 
> the message shortening "file offset" in "fo:" and so...
> 
> - take in account that a filename may contains a "new line".. (may be that I 
> am paranoid ? :-) )
> 
> - I am thinking about intermediated mode between the verbose mode and the 
> "standard" mode. Something like:
> 	XEI tmp/foo/bar
>  where
> 	X,E,I are flags which track if there are changes in a Inode, eXtended
>         attribute or in the Extent
> I thick that from a "bash scriptiong" POV would be more usefoul.
> 
> - it is impossible to track the "deleted" items (files,dirs, eXtended 
> attributes). I can develop a command which compare two subvolumes an extract 
> all of this kind of information. But this command would return correct 
> information *only if* 
>    A) a subvolume is a snapshot of the other one
>    B.1) the reference snapshot is not touched OR
>    B.2) I have the lastgen "when" the snapshot is taken
> I have to highlight that these conditions cannot be guarantee (nor check) by a 
> tool like the "btrfs" command. However may be evaluated that for every 
> snapshot is track the root uuid from which the snapshot is taken and the 
> lastgen when the snapshot happened... It may be another item in the tree 
> called "btrfs_snapshot_info_item" or handled in userspace.
> 
> - what I wrote in the last sentence would lead to remove the "-s" switch...
> 
> TODO:
> - improve the cache of the filename and the dir (now only the last entry is 
> cached)
> - improve the function ino_resolve to return all the path associated to an 
> inode (a file with multiple hardlinks has more paths)
> -  improve the man page
> 
> The patch is based on the great work of "Sean Reifschneider" who developed the 
> "last-gen" command, winch unfortunately is not yet in the repo .
> 
> 
> Comments are welcome.
> 
> G.Baroncelli
> 
>  btrfs-list.c   |  245 ++++++++++++++++++++++++++++++++++++++++---------------
>  btrfs.c        |    5 -
>  btrfs_cmds.c   |   84 ++++++++++++++++++-
>  btrfs_cmds.h   |    4 
>  man/btrfs.8.in |   19 ++++
>  5 files changed, 277 insertions(+), 80 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 93766a8..3905436 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -310,7 +310,7 @@ static int lookup_ino_path(int fd, struct root_info *ri)
>   * Then we use the tree search ioctl to scan all the root items for a
>   * given root id and spit out the latest generation we can find
>   */
> -static u64 find_root_gen(int fd)
> +u64 find_root_gen(int fd)
>  {
>  	struct btrfs_ioctl_ino_lookup_args ino_args;
>  	int ret;
> @@ -657,11 +657,43 @@ int list_subvols(int fd)
>  	return ret;
>  }
>  
> -static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
> +static u64 cache_get_full_path_dirid = 0;
> +static u64 cache_get_full_path_ino = 0;
> +static char *cache_get_full_path_dir_name = NULL;
> +static char *cache_get_full_path_full_name = NULL;
> +
> +static void init_cache_get_full_path(void)
> +{
> +	cache_get_full_path_dirid = 0;
> +	cache_get_full_path_ino = 0;
> +	cache_get_full_path_dir_name = NULL;
> +	cache_get_full_path_full_name = NULL;
> +}
> +	
> +static char *get_full_path(int fd, struct btrfs_ioctl_search_header *sh)
> +{
> +	char *name = NULL;
> +
> +	if (sh->objectid == cache_get_full_path_ino) {
> +		name = cache_get_full_path_full_name;
> +	} else if (cache_get_full_path_full_name) {
> +		free(cache_get_full_path_full_name);
> +		cache_get_full_path_full_name = NULL;
> +	}
> +	if (!name) {
> +		name = ino_resolve(fd, sh->objectid, 
> +				   &cache_get_full_path_dirid,
> +				   &cache_get_full_path_dir_name);
> +		cache_get_full_path_full_name = name;
> +		cache_get_full_path_ino = sh->objectid;
> +	}
> +
> +	return name;
> +}
> +
> +static int print_one_extent(struct btrfs_ioctl_search_header *sh,
>  			    struct btrfs_file_extent_item *item,
> -			    u64 found_gen, u64 *cache_dirid,
> -			    char **cache_dir_name, u64 *cache_ino,
> -			    char **cache_full_name)
> +			    u64 found_gen)
>  {
>  	u64 len = 0;
>  	u64 disk_start = 0;
> @@ -669,22 +701,6 @@ static int print_one_extent(int fd, struct 
> btrfs_ioctl_search_header *sh,
>  	u8 type;
>  	int compressed = 0;
>  	int flags = 0;
> -	char *name = NULL;
> -
> -	if (sh->objectid == *cache_ino) {
> -		name = *cache_full_name;
> -	} else if (*cache_full_name) {
> -		free(*cache_full_name);
> -		*cache_full_name = NULL;
> -	}
> -	if (!name) {
> -		name = ino_resolve(fd, sh->objectid, cache_dirid,
> -				   cache_dir_name);
> -		*cache_full_name = name;
> -		*cache_ino = sh->objectid;
> -	}
> -	if (!name)
> -		return -EIO;
>  
>  	type = btrfs_stack_file_extent_type(item);
>  	compressed = btrfs_stack_file_extent_compression(item);
> @@ -708,9 +724,8 @@ static int print_one_extent(int fd, struct 
> btrfs_ioctl_search_header *sh,
>  
>  		return -EIO;
>  	}
> -	printf("inode %llu file offset %llu len %llu disk start %llu "
> +	printf("\tEXTENT: file offset %llu len %llu disk start %llu "
>  	       "offset %llu gen %llu flags ",
> -	       (unsigned long long)sh->objectid,
>  	       (unsigned long long)sh->offset,
>  	       (unsigned long long)len,
>  	       (unsigned long long)disk_start,
> @@ -732,29 +747,151 @@ static int print_one_extent(int fd, struct 
> btrfs_ioctl_search_header *sh,
>  	if (!flags)
>  		printf("NONE");
>  
> -	printf(" %s\n", name);
> +	printf("\n");
>  	return 0;
>  }
>  
> -int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
> +BTRFS_SETGET_STACK_FUNCS(stack_inode_nbyte,
> +                         struct btrfs_inode_item, nbytes, 32);

ctree.h has define this...

> +int print_one_inode(struct btrfs_inode_item *item,
> +			    u64 found_gen)
>  {
> -	int ret;
> -	struct btrfs_ioctl_search_args args;
> -	struct btrfs_ioctl_search_key *sk = &args.key;
> +	u32 mode;
> +
> +	mode = btrfs_stack_inode_mode(item);
> +	printf("\tINODE: mode 0x%08x gen %llu nbyte %llu nlink %llu uid %llu"
> +		" gid %llu flags 0x%016llx\n",
> +	       		mode, found_gen, 
> +			(unsigned long long)btrfs_stack_inode_nbyte(item),
> +			(unsigned long long)btrfs_stack_inode_nlink(item),
> +			(unsigned long long)btrfs_stack_inode_uid(item),
> +			(unsigned long long)btrfs_stack_inode_gid(item),
> +			(unsigned long long)btrfs_stack_inode_flags(item)
> +	);
> +
> +	return 0;
> +}
> +
> +
> +BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len,
> +                         struct btrfs_dir_item, name_len, 16);
> +BTRFS_SETGET_STACK_FUNCS(stack_dir_data_len,
> +                         struct btrfs_dir_item, data_len, 16);

Ditto.

> +static int print_one_xattr( struct btrfs_dir_item *item )
> +
> +{
> +	u32 name_len;
> +	u32 data_len;
> +
> +	name_len = btrfs_stack_dir_name_len(item);
> +	data_len = btrfs_stack_dir_data_len(item);
> +
> +	printf("\tXATTR: namelen %llu datalen %llu name %.*s\n",
> +			(unsigned long long)name_len, 
> +			(unsigned long long)data_len, 
> +			name_len, (char *)(item + 1));
> +	return 0;
> +}
> +
> +
> +static inline void print_filename_one_time( int fd,
> +	struct btrfs_ioctl_search_header *sh, u64 *old_objectid,
> +	int verbose)
> +{	
> +	if ( sh->objectid != *old_objectid ){
> +		if(verbose >=50 )
> +			printf("inode %llu name ",
> +			       (unsigned long long)sh->objectid);
> +		printf("%s\n", get_full_path(fd, sh));
> +		*old_objectid = sh->objectid;
> +	}
> +}	
> +
> +
> +BTRFS_SETGET_STACK_FUNCS(stack_inode_transid,
> +                         struct btrfs_inode_item, transid, 64);

Would be better to add this to ctree.h?

> +static void _find_updated_files_2(int fd, 
> +			struct btrfs_ioctl_search_args *args,
> +			u64 *old_objectid,
> +			u64 oldest_gen,
> +			int verbose )
> +{	
> +	struct btrfs_ioctl_search_key *sk = &args->key;
>  	struct btrfs_ioctl_search_header *sh;
>  	struct btrfs_file_extent_item *item;
>  	unsigned long off = 0;
>  	u64 found_gen;
> -	u64 max_found = 0;
>  	int i;
> -	u64 cache_dirid = 0;
> -	u64 cache_ino = 0;
> -	char *cache_dir_name = NULL;
> -	char *cache_full_name = NULL;
>  	struct btrfs_file_extent_item backup;
>  
>  	memset(&backup, 0, sizeof(backup));
> +
> +	/*
> +	 * for each item, pull the key out of the header and then
> +	 * read the root_ref item it contains
> +	 */
> +	for (off = 0, i = 0; i < sk->nr_items; i++) {
> +		sh = (struct btrfs_ioctl_search_header *)(args->buf +
> +							  off);
> +		off += sizeof(*sh);
> +
> +		/*
> +		 * just in case the item was too big, pass something other
> +		 * than garbage
> +		 */
> +		if (sh->len == 0)
> +			item = &backup;
> +		else
> +			item = (struct btrfs_file_extent_item *)(args->buf +
> +							 off);
> +		found_gen = btrfs_stack_file_extent_generation(item);
> +
> +		if (sh->type == BTRFS_EXTENT_DATA_KEY &&
> +		    found_gen >= oldest_gen) {
> +			print_filename_one_time(fd, sh, old_objectid, 
> verbose);
> +			if(verbose>=100)
> +				print_one_extent(sh,item, found_gen);
> +		} else if (sh->type == BTRFS_INODE_ITEM_KEY ){
> +			struct btrfs_inode_item *i =
> +				(struct btrfs_inode_item*)(args->buf+off);
> +			found_gen = btrfs_stack_inode_transid(i);
> +			if( found_gen >= oldest_gen) {
> +				print_filename_one_time(fd, sh, old_objectid,
> +							verbose);
> +				if(verbose>=100)
> +					print_one_inode(i,found_gen);
> +
> +			}
> +		} else if (sh->type == BTRFS_XATTR_ITEM_KEY ){
> +			struct btrfs_dir_item *i =
> +			    	(struct btrfs_dir_item*)(args->buf+off);
> +			print_filename_one_time(fd, sh, old_objectid, 
> verbose);
> +			if(verbose>=100)
> +					print_one_xattr(i);
> +		}
> +
> +		off += sh->len;
> +
> +		/*
> +		 * record the mins in sk so we can make sure the
> +		 * next search doesn't repeat this root
> +		 */
> +		sk->min_objectid = sh->objectid;
> +		sk->min_offset = sh->offset;
> +		sk->min_type = sh->type;
> +	}
> +
> +}
> +
> +int find_updated_files(int fd, u64 root_id, u64 oldest_gen, int verbose)
> +{
> +	int ret;
> +	struct btrfs_ioctl_search_args args;
> +	struct btrfs_ioctl_search_key *sk = &args.key;
> +	u64 old_objectid = -1;
> +	
>  	memset(&args, 0, sizeof(args));
> +	init_cache_get_full_path();
>  
>  	sk->tree_id = root_id;
>  
> @@ -770,7 +907,6 @@ int find_updated_files(int fd, u64 root_id, u64 
> oldest_gen)
>  	/* just a big number, doesn't matter much */
>  	sk->nr_items = 4096;
>  
> -	max_found = find_root_gen(fd);
>  	while(1) {
>  		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>  		if (ret < 0) {
> @@ -781,43 +917,9 @@ int find_updated_files(int fd, u64 root_id, u64 
> oldest_gen)
>  		if (sk->nr_items == 0)
>  			break;
>  
> -		off = 0;
> -
> -		/*
> -		 * for each item, pull the key out of the header and then
> -		 * read the root_ref item it contains
> -		 */
> -		for (i = 0; i < sk->nr_items; i++) {
> -			sh = (struct btrfs_ioctl_search_header *)(args.buf +
> -								  off);
> -			off += sizeof(*sh);
> -
> -			/*
> -			 * just in case the item was too big, pass something 
> other
> -			 * than garbage
> -			 */
> -			if (sh->len == 0)
> -				item = &backup;
> -			else
> -				item = (struct btrfs_file_extent_item *)
> (args.buf +
> -								 off);
> -			found_gen = btrfs_stack_file_extent_generation(item);
> -			if (sh->type == BTRFS_EXTENT_DATA_KEY &&
> -			    found_gen >= oldest_gen) {
> -				print_one_extent(fd, sh, item, found_gen,
> -						 &cache_dirid, 
> &cache_dir_name,
> -						 &cache_ino, 
> &cache_full_name);
> -			}
> -			off += sh->len;
> +		_find_updated_files_2( fd, &args, &old_objectid, oldest_gen,
> +					verbose );
>  
> -			/*
> -			 * record the mins in sk so we can make sure the
> -			 * next search doesn't repeat this root
> -			 */
> -			sk->min_objectid = sh->objectid;
> -			sk->min_offset = sh->offset;
> -			sk->min_type = sh->type;
> -		}
>  		sk->nr_items = 4096;
>  		if (sk->min_offset < (u64)-1)
>  			sk->min_offset++;
> @@ -828,8 +930,5 @@ int find_updated_files(int fd, u64 root_id, u64 
> oldest_gen)
>  		} else
>  			break;
>  	}
> -	free(cache_dir_name);
> -	free(cache_full_name);
> -	printf("transid marker was %llu\n", (unsigned long long)max_found);
>  	return ret;
>  }
> diff --git a/btrfs.c b/btrfs.c
> index 46314cf..1b5fe9f 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -61,9 +61,12 @@ static struct Command commands[] = {
>  	{ do_subvol_list, 1, "subvolume list", "<path>\n"
>  		"List the snapshot/subvolume of a filesystem."
>  	},
> -	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
> +	{ do_find_newer, -2, "subvolume find-new", "[-v|--verbose][-s|--
> subvol]<path> <last_gen>\n"
>  		"List the recently modified files in a filesystem."
>  	},
> +	{ do_get_latest_gen, 1, "subvolume last-gen", "<path>\n"
> +		"Return the latest generation of a filesystem."
> +	},
>  	{ do_defrag, -1,
>  	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size] 
> <file>|<dir> [<file>|<dir>...]\n"
>  		"Defragment a file or a directory."
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..9bcc280 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -247,16 +247,90 @@ int do_defrag(int ac, char **av)
>  	return errors + 20;
>  }
>  
> +static int _get_latest_gen(char *subvol, u64 *max_found)
> +{
> +	int fd;
> +	int ret;
> +
> +	ret = test_issubvolume(subvol);
> +	if (ret < 0) {
> +		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
> +		return 12;
> +	}
> +	if (!ret) {
> +		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
> +		return 13;
> +	}
> +
> +	fd = open_file_or_dir(subvol);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
> +		return 12;
> +	}
> +	*max_found = find_root_gen(fd);
> +	return 0;
> +}
> +
> +
> +int do_get_latest_gen(int argc, char **argv)
> +{
> +	int ret;
> +	u64 max_found = 0;
> +
> +	ret = _get_latest_gen(argv[1], &max_found);
> +	if(ret)
> +		return ret;
> +	printf("%llu\n", (unsigned long long)max_found);
> +	return 0;
> +}
> +
>  int do_find_newer(int argc, char **argv)
>  {
>  	int fd;
>  	int ret;
> -	char *subvol;
> -	u64 last_gen;
> +	char *subvol=0, *gen=0;
> +	u64 last_gen = (u64)-1;
> +	int i = 1;
> +	int verbose=0;	/* 0 print only file/dir name; 100 is verbose */
> +	int last_gen_as_subvol=0;
>  
> -	subvol = argv[1];
> -	last_gen = atoll(argv[2]);
>  
> +	for(i=1;i<argc;i++){
> +		if(!strcmp(argv[i],"-v")||!strcmp(argv[i],"--verbose")){
> +			verbose = 100;
> +			continue;
> +		}
> +		if(!strcmp(argv[i],"-s")||!strcmp(argv[i],"--subvol")){
> +			last_gen_as_subvol = 1;
> +			continue;
> +		}
> +		if( !subvol ){
> +			subvol = argv[i];
> +			continue;
> +		}
> +		if( !gen ){
> +			gen = argv[i];
> +			continue;
> +		}
> +
> +		fprintf(stderr, "ERROR: too much number of parameters\n");
> +		return 12;
> +
> +	}
> +
> +	if( !subvol){
> +		fprintf(stderr, "ERROR: not ebough number of parameters\n");

a typo error? "enough"?

thanks,
Liu Bo

> +       	        return 12;
> +        }
> +
> +	if(last_gen_as_subvol){
> +		ret = _get_latest_gen(gen, &last_gen);
> +		if(ret)
> +			return ret;
> +	} else
> +		last_gen = atoll(gen);
> +	
> +printf("last_gen=%llu; gen=%s\n",last_gen,gen);
>  	ret = test_issubvolume(subvol);
>  	if (ret < 0) {
>  		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
> @@ -272,7 +346,7 @@ int do_find_newer(int argc, char **argv)
>  		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
>  		return 12;
>  	}
> -	ret = find_updated_files(fd, 0, last_gen);
> +	ret = find_updated_files(fd, 0, last_gen, verbose);
>  	if (ret)
>  		return 19;
>  	return 0;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index 7bde191..41372e7 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -20,6 +20,7 @@ int do_delete_subvolume(int nargs, char **argv);
>  int do_create_subvol(int nargs, char **argv);
>  int do_fssync(int nargs, char **argv);
>  int do_defrag(int argc, char **argv);
> +int do_get_latest_gen(int argc, char **argv);
>  int do_show_filesystem(int nargs, char **argv);
>  int do_add_volume(int nargs, char **args);
>  int do_balance(int nargs, char **argv);
> @@ -30,5 +31,6 @@ int do_subvol_list(int nargs, char **argv);
>  int do_set_default_subvol(int nargs, char **argv);
>  int list_subvols(int fd);
>  int do_df_filesystem(int nargs, char **argv);
> -int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
> +int find_updated_files(int fd, u64 root_id, u64 oldest_gen, int verbose);
>  int do_find_newer(int argc, char **argv);
> +u64 find_root_gen(int fd);
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 26ef982..23ba7d2 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -15,6 +15,10 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
>  .PP
> +\fBbtrfs\fP \fBsubvolume last-gen\fP\fI <path>\fP
> +.PP
> +\fBbtrfs\fP \fBsubvolume find-new\fP\fI <path> <last_gen>\fP
> +.PP
>  \fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
>  .PP
>  \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
> @@ -96,6 +100,21 @@ These <ID> may be used by the \fBsubvolume set-default\fR 
> command, or at
>  mount time via the \fIsubvol=\fR option.
>  .TP
>  
> +\fBsubvolume last-gen\fR\fI <path>\fR
> +Return the most current generation id of \fI<path>\fR.  This number is
> +suitable for use with the \fBsubvolume find-new\fR command, for example.
> +A single number is sent to stdout, representing the most recent generation
> +within a subvolume/snapshot.
> +
> +\fBsubvolume find-new\fR\fI <path> <last_gen>\fR
> +Display changes to the subvolume \fI<path>\fR since the generation id
> +\fI<last_gen>\fR.  The resulting information includes filenames, offset
> +within the file, length, and more.  The last line output displays the most
> +recent generation id represented by the output.  For example, one could
> +feed this id back in to get an ongoing report of changes to the
> +subvolume.
> +.TP
> +
>  \fBsubvolume set-default\fR\fI <id> <path>\fR
>  Set the subvolume of the filesystem \fI<path>\fR which is mounted as 
>  \fIdefault\fR. The subvolume is identified by \fB<id>\fR, which 
> 

