Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54869 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755279AbdJRDg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 23:36:59 -0400
Date: Wed, 18 Oct 2017 11:36:21 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: qgroup: show subvol path when qgroup show
Message-ID: <20171018033621.GD495@fnst.localdomain>
References: <20171010083709.30690-1-lufq.fnst@cn.fujitsu.com>
 <20171016185511.GW3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20171016185511.GW3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 08:55:11PM +0200, David Sterba wrote:
>On Tue, Oct 10, 2017 at 04:37:09PM +0800, Lu Fengqi wrote:
>> Show the absolute subvol path for the associated level-0 qgroup.
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  Documentation/btrfs-qgroup.asciidoc |   2 +
>>  cmds-qgroup.c                       |   7 +-
>>  qgroup.c                            | 130 +++++++++++++++++++++++++++++++++---
>>  qgroup.h                            |   1 +
>>  4 files changed, 129 insertions(+), 11 deletions(-)
>> 
>> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
>> index 3053f2e6..fb48a917 100644
>> --- a/Documentation/btrfs-qgroup.asciidoc
>> +++ b/Documentation/btrfs-qgroup.asciidoc
>> @@ -93,6 +93,8 @@ Show all qgroups in the btrfs filesystem identified by <path>.
>>  print parent qgroup id.
>>  -c::::
>>  print child qgroup id.
>> +-P::::
>> +print subvol path.
>>  -r::::
>>  print limit of referenced size of qgroup.
>>  -e::::
>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>> index 38382ea9..9dce84ae 100644
>> --- a/cmds-qgroup.c
>> +++ b/cmds-qgroup.c
>> @@ -277,6 +277,7 @@ static const char * const cmd_qgroup_show_usage[] = {
>>  	"Show subvolume quota groups.",
>>  	"-p             print parent qgroup id",
>>  	"-c             print child qgroup id",
>> +	"-P             print subvol path",
>
>I think the path should be printed by default. A more intelligent way of
>specifying the columns is on the way, so I'd leave the path without an
>option. It's printed as a last item so hopefully will not break tools
>that parse the qgrou show output.

OK, I will update the patch so that print the path by default.

>
>>  	"-r             print limit of referenced size of qgroup",
>>  	"-e             print limit of exclusive size of qgroup",
>>  	"-F             list all qgroups which impact the given path",
>> @@ -322,7 +323,7 @@ static int cmd_qgroup_show(int argc, char **argv)
>>  			{ NULL, 0, NULL, 0 }
>>  		};
>>  
>> -		c = getopt_long(argc, argv, "pcreFf", long_options, NULL);
>> +		c = getopt_long(argc, argv, "pcPreFf", long_options, NULL);
>>  		if (c < 0)
>>  			break;
>>  		switch (c) {
>> @@ -334,6 +335,10 @@ static int cmd_qgroup_show(int argc, char **argv)
>>  			btrfs_qgroup_setup_print_column(
>>  				BTRFS_QGROUP_CHILD);
>>  			break;
>> +		case 'P':
>> +			btrfs_qgroup_setup_print_column(
>> +				BTRFS_QGROUP_PATH);
>> +			break;
>>  		case 'r':
>>  			btrfs_qgroup_setup_print_column(
>>  				BTRFS_QGROUP_MAX_RFER);
>> diff --git a/qgroup.c b/qgroup.c
>> index fffdbb12..d618107e 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -62,6 +62,9 @@ struct btrfs_qgroup {
>>  	struct list_head qgroups;
>>  	/*qgroups that are members of this group*/
>>  	struct list_head members;
>> +
>> +	/* level-0 qgroup's subvolume path */
>> +	char *path;
>>  };
>>  
>>  /*
>> @@ -133,6 +136,13 @@ static struct {
>>  		.unit_mode	= 0,
>>  		.max_len	= 5,
>>  	},
>> +	{
>> +		.name		= "path",
>> +		.column_name	= "Path",
>> +		.need_print	= 0,
>> +		.unit_mode	= 0,
>> +		.max_len	= 4,
>> +	},
>>  	{
>>  		.name		= NULL,
>>  		.column_name	= NULL,
>> @@ -253,6 +263,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>>  		len = print_child_column(qgroup);
>>  		print_qgroup_column_add_blank(BTRFS_QGROUP_CHILD, len);
>>  		break;
>> +	case BTRFS_QGROUP_PATH:
>> +		len = printf("%s", qgroup->path ? qgroup->path : "---");
>> +		print_qgroup_column_add_blank(BTRFS_QGROUP_PATH, len);
>>  	default:
>>  		break;
>>  	}
>> @@ -267,7 +280,7 @@ static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
>>  			continue;
>>  		print_qgroup_column(qgroup, i);
>>  
>> -		if (i != BTRFS_QGROUP_CHILD)
>> +		if (i != BTRFS_QGROUP_ALL - 1)
>>  			printf(" ");
>>  	}
>>  	printf("\n");
>> @@ -284,7 +297,7 @@ static void print_table_head(void)
>>  		if (!btrfs_qgroup_columns[i].need_print)
>>  			continue;
>>  		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
>> -			(i == BTRFS_QGROUP_CHILD))
>> +			(i == BTRFS_QGROUP_CHILD) | (i == BTRFS_QGROUP_PATH))
>>  			printf("%-*s", max_len, btrfs_qgroup_columns[i].name);
>>  		else
>>  			printf("%*s", max_len, btrfs_qgroup_columns[i].name);
>> @@ -296,7 +309,7 @@ static void print_table_head(void)
>>  		if (!btrfs_qgroup_columns[i].need_print)
>>  			continue;
>>  		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
>> -			(i == BTRFS_QGROUP_CHILD)) {
>> +			(i == BTRFS_QGROUP_CHILD) | (i == BTRFS_QGROUP_PATH)) {
>>  			len = strlen(btrfs_qgroup_columns[i].name);
>>  			while (len--)
>>  				printf("-");
>> @@ -627,7 +640,7 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
>>  		      u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
>>  		      u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
>>  		      u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *parent,
>> -		      struct btrfs_qgroup *child)
>> +		      struct btrfs_qgroup *child, char *path)
>>  {
>>  	struct btrfs_qgroup *bq;
>>  	struct btrfs_qgroup_list *list;
>> @@ -678,6 +691,8 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
>>  		list_add_tail(&list->next_qgroup, &child->qgroups);
>>  		list_add_tail(&list->next_member, &parent->members);
>>  	}
>> +	bq->path = path;
>> +
>>  	ret = qgroup_tree_insert(qgroup_lookup, bq);
>>  	if (ret) {
>>  		error("failed to insert %llu into tree: %s",
>> @@ -687,6 +702,88 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Construct subvolume path for level-0 qgroup according to qgroupid.
>> + *
>> + * Return a potiner to the path string on success.
>> + * Return NULL on error or qgroup level > 0.
>> + */
>> +static char *qgroups_path_lookup(int fd, struct qgroup_lookup *qgroup_lookup,
>> +				 u64 qgroupid)
>> +{
>> +	struct btrfs_ioctl_search_args args;
>> +	struct btrfs_ioctl_search_key *sk = &args.key;
>> +	struct btrfs_root_ref *ref;
>> +	struct btrfs_ioctl_search_header sh;
>> +	struct btrfs_qgroup *bq;
>> +	char *name, *path;
>> +	u64 subvol_id;
>> +	int name_len;
>> +	int ret;
>> +
>> +	/* construct the path only if need print path */
>> +	if (!btrfs_qgroup_columns[BTRFS_QGROUP_PATH].need_print)
>> +		return NULL;
>> +
>> +	/* only level-0 qgroup has the corresponding subvolume*/
>> +	if (btrfs_qgroup_level(qgroupid))
>> +		return NULL;
>> +
>> +	subvol_id = btrfs_qgroup_subvid(qgroupid);
>> +	if (subvol_id < BTRFS_FIRST_FREE_OBJECTID ||
>> +			subvol_id > BTRFS_LAST_FREE_OBJECTID)
>> +		return NULL;
>> +
>> +	memset(&args, 0, sizeof(args));
>> +
>> +	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
>> +	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
>> +	sk->min_type = BTRFS_ROOT_BACKREF_KEY;
>> +	sk->max_objectid = subvol_id;
>> +	sk->min_objectid = subvol_id;
>> +	sk->max_offset = (u64)-1;
>> +	sk->max_transid = (u64)-1;
>> +
>> +	sk->nr_items = 4096;
>> +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>> +	if (ret < 0)
>> +		return NULL;
>> +	if (!sk->nr_items)
>> +		return NULL;
>> +
>> +	/* resolve the ROOT_BACKREF to get the subvolume name*/
>> +	memcpy(&sh, args.buf, sizeof(sh));
>> +	ref = (struct btrfs_root_ref *)(args.buf + sizeof(sh));
>> +	name_len = btrfs_stack_root_ref_name_len(ref);
>> +	name = (char *)(ref + 1);
>> +
>> +	/*
>> +	 * directly return subvolume name if top level is the initial subvolume
>> +	 */
>> +	if (sh.offset == BTRFS_FS_TREE_OBJECTID)
>> +		return strndup(name, name_len);
>> +
>> +	/*
>> +	 * construct path based on the upper subvolume path and the subvolume
>> +	 * name
>> +	 */
>> +	bq = qgroup_tree_search(qgroup_lookup, sh.offset);
>> +	if (!bq || bq->qgroupid != sh.offset)
>> +		return NULL;
>> +
>> +	/*
>> +	 * 2 means the path delimiter '/' and the terminating null byte ('\0')
>> +	 */
>> +	path = malloc(strlen(name) + strlen(bq->path) + 2);
>> +	if (!path) {
>> +		perror("malloc failed");
>> +		exit(1);
>> +	}
>> +	sprintf(path, "%s/%s", bq->path, name);
>> +
>> +	return path;
>> +}
>> +
>>  static void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
>>  {
>>  	struct btrfs_qgroup_list *list;
>> @@ -706,6 +803,8 @@ static void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
>>  		list_del(&list->next_member);
>>  		free(list);
>>  	}
>> +	if (bq->path)
>> +		free(bq->path);
>>  	free(bq);
>>  }
>>  
>> @@ -979,6 +1078,11 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
>>  		if (btrfs_qgroup_columns[column].max_len < len)
>>  			btrfs_qgroup_columns[column].max_len = len;
>>  		break;
>> +	case BTRFS_QGROUP_PATH:
>> +		len = bq->path ? strlen(bq->path) : 0;
>> +		if (btrfs_qgroup_columns[column].max_len < len)
>> +			btrfs_qgroup_columns[column].max_len = len;
>> +		break;
>>  	default:
>>  		break;
>>  	}
>> @@ -1092,8 +1196,12 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
>>  				print_status_flag_warning(flags);
>>  			} else if (btrfs_search_header_type(sh)
>>  				   == BTRFS_QGROUP_INFO_KEY) {
>> +				u64 qgroupid;
>> +				char *path;
>> +
>>  				info = (struct btrfs_qgroup_info_item *)
>>  				       (args.buf + off);
>> +				qgroupid = btrfs_search_header_offset(sh);
>>  				a1 = btrfs_stack_qgroup_info_generation(info);
>>  				a2 = btrfs_stack_qgroup_info_referenced(info);
>>  				a3 =
>> @@ -1103,10 +1211,11 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
>>  				a5 =
>>  				  btrfs_stack_qgroup_info_exclusive_compressed
>>  				  (info);
>> -				add_qgroup(qgroup_lookup,
>> -					btrfs_search_header_offset(sh), a1,
>> -					a2, a3, a4, a5, 0, 0, 0, 0, 0, NULL,
>> -					NULL);
>> +				path = qgroups_path_lookup(fd, qgroup_lookup,
>> +							   qgroupid);
>> +				add_qgroup(qgroup_lookup, qgroupid, a1, a2, a3,
>> +					   a4, a5, 0, 0, 0, 0, 0, NULL, NULL,
>> +					   path);
>>  			} else if (btrfs_search_header_type(sh)
>>  				   == BTRFS_QGROUP_LIMIT_KEY) {
>>  				limit = (struct btrfs_qgroup_limit_item *)
>> @@ -1124,7 +1233,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
>>  				add_qgroup(qgroup_lookup,
>>  					   btrfs_search_header_offset(sh), 0,
>>  					   0, 0, 0, 0, a1, a2, a3, a4, a5,
>> -					   NULL, NULL);
>> +					   NULL, NULL, NULL);
>>  			} else if (btrfs_search_header_type(sh)
>>  				   == BTRFS_QGROUP_RELATION_KEY) {
>>  				if (btrfs_search_header_offset(sh)
>> @@ -1140,7 +1249,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
>>  					goto skip;
>>  				add_qgroup(qgroup_lookup,
>>  					   btrfs_search_header_offset(sh), 0,
>> -					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
>> +					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1,
>> +					   NULL);
>
>Oh no, yet another argument, so it's 15 in total.

So many arguments are really hard to accept, I will rework this.

-- 
Thanks,
Lu

>
>>  			} else
>>  				goto done;
>>  skip:
>> diff --git a/qgroup.h b/qgroup.h
>> index 875fbdf3..2003f834 100644
>> --- a/qgroup.h
>> +++ b/qgroup.h
>> @@ -59,6 +59,7 @@ enum btrfs_qgroup_column_enum {
>>  	BTRFS_QGROUP_MAX_EXCL,
>>  	BTRFS_QGROUP_PARENT,
>>  	BTRFS_QGROUP_CHILD,
>> +	BTRFS_QGROUP_PATH,
>>  	BTRFS_QGROUP_ALL,
>>  };
>>  
>> -- 
>> 2.14.2
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


