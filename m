Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab3IQNDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 09:03:53 -0400
Date: Tue, 17 Sep 2013 15:03:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs-progs: Add recursive defrag using -r option
Message-ID: <20130917130335.GX6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <073ec67162396b2ebda9c4ef51c6851993132b68.1379383433.git.fholton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <073ec67162396b2ebda9c4ef51c6851993132b68.1379383433.git.fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 10:21:24PM -0400, Frank Holton wrote:
> I'm working on a patch to add the recursive option to the 
> btrfs filesystem defrag command.

Great!

> I'd like some feedback on how the patch looks as written. I've added
> two helper functions, which might need to be renamed, one to call the
> ioctl and one to actually handle the recursion into the directory. 

Please use the 'ftw' function from glibc
http://man7.org/linux/man-pages/man3/ftw.3.html

(it's used in mkfs.c for example)

> @@ -333,6 +336,7 @@ static const char * const cmd_defrag_usage[] = {
>  	"Defragment a file or a directory",
>  	"",
>  	"-v             be verbose",
> +	"-r             defragment directories and files recursively",

Directories do not get defragmented. Giving any directory to defragment
will actually deframgent the subvolume fs_tree and then the shared
extent tree.  This is hidden in implementation and has confused people.

For now, I suggest to recursively defrag only files, that's IMHO the
most frequent usecase.

Deframgenting the subvol root or the extent tree are special cases and
should be enabled only when requested, by a commandline option. This
needs updating kernel. I can go into details later if needed.

(I'ts possible to implement a per-directory defrag by extending
btrfs_defrag_leaves with start/end key ranges that represent the
directory items.)

A few comments on the code follow, I hope you convert it to the 'ftw'
callback, this will remove half of the code from this patch, so I'd
rather see the result first. Basically, the contents of the ftw callback
is done inside this loop:

> +	while ((dent = readdir(dir)) != NULL) {
> +		int fd = 0;
> +		if (!strcmp(dent->d_name,".") || !strcmp(dent->d_name, ".."))
> +			continue;
> +			
> +		fn[len] = 0;
> +		strncat(fn+len, dent->d_name, FILENAME_MAX - len);
> +		
> +		if (lstat(fn, &st) == -1) {
> +			fprintf(stderr,"ERROR: cannot stat %s\n", fn);
> +			error++;
> +			continue;
> +		}
> +		
> +		/* ignore symlinks ??*/
> +		if (S_ISLNK(st.st_mode))
> +			continue;
> +			
> +		if(verbose)
> +			printf("%s\n", fn);
> +		
> +		/* directory entry */
> +		if (S_ISDIR(st.st_mode)) {
> +			ret = walk_dir(fn, verbose, fancy_ioctl, range);
> +			errors += ret;
> +		}
> +		else {
> +			fd = open(fn,O_RDWR);
> +			e = errno;
> +			if (fd < 0) {
> +				fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
> +					fn, strerror(e));
> +				error++;
> +				continue;
> +			}
> +			
> +			ret = do_defrag(fd, fancy_ioctl, range);
> +			e = errno;
> +			
> +			if (ret) {
> +				errors++;
> +				fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
> +					fn, strerror(e));
> +				error++;
> +			}
> +			close(fd);
> +		}	  
> +	}
> +
> +	close(dir_fd);
> +	closedir(dir);
> +
> +	return(errors);
> +}

The command line argument handling is ok.

Please get familiar with the coding style
https://www.kernel.org/doc/Documentation/CodingStyle
eg. spacing and { } placement. It's not pointless to keep the style
consistent, people who have to read the code appreciate if it looks the
same all over the place.

thanks,
david
