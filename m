From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH v2] btrfs-progs: btrfs: implement 'start-sync' and 'wait-sync' commands
Date: Tue, 2 Nov 2010 19:58:27 +0100
Message-ID: <201011021958.27578.kreijack@libero.it>
References: <1288629262-5405-1-git-send-email-sage@newdream.net> <1288629262-5405-2-git-send-email-sage@newdream.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org, Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288629262-5405-2-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 01 November, 2010, Sage Weil wrote:
> The 'start-sync' command initiates a sync, but does not wait for it to
> complete.  A transaction is printed that can be fed to 'wait-sync', which
> will wait for it to commit.
> 
> 'wait-sync' can also be used in combination with 'async-snapshot' to wait
> for an async snapshot creation to commit.
> 
> Updates the man page too.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  btrfs.c        |    9 +++++++++
>  btrfs_cmds.c   |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  btrfs_cmds.h   |    2 ++
>  man/btrfs.8.in |   14 ++++++++++++++
>  4 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/btrfs.c b/btrfs.c
> index 46314cf..c871f4a 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -77,6 +77,15 @@ static struct Command commands[] = {
>  	  "filesystem sync", "<path>\n"
>  		"Force a sync on the filesystem <path>."
>  	},
> +	{ do_start_sync, 1,
> +	  "filesystem start-sync", "<path>\n"
> +	        "Start a sync on the filesystem <path>, and print the 
resulting\n"
> +	        "transaction id."
> +	},

Like the command "btrfs subvol snapshot", I think that it is better to add a 
modifier instead of a new command.

 btrfs filesystem sync [--async]

Sorry if I noticed this too late. But I don't see a valid reason to add 
another command. From a UI point of view the meaning of the command is the 
same, change only slight the behavior.

Even tough I have to admint that "sync --async" sound strange. May be flush is 
better ?
> +	{ do_wait_sync, 2,
> +	  "filesystem wait-sync", "<path> <transid>\n"
> +	        "Wait for the transaction <transid> on the filesystem at 
<path> to commit."
> +	},

If I understood correctly this command may be used to wait the execution of 
several commands: snapshot, subvolume removal, sync...
I can suggest a more general name like:

# btrfs filesystem wait-transaction <path> <transid>.

(which may be shortened as "btrfs filesystem wait ..."). 

Another suggestion: instead of checking if the <transid> is 0, leave the 
<transid> optional. If <transid> is omitted, then the function waits all the 
running transaction.

Finally I suggest to put a little note about the command behvior when a 
transaction is started after the command execution: is there a risk of DOS ?

Anyway great work.

Goffredo


>  	{ do_resize, 2,
>  	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
>  		"Resize the file system. If 'max' is passed, the filesystem\n"
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..736437d 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -526,6 +526,55 @@ int do_fssync(int argc, char **argv)
>  	return 0;
>  }
>  
> +int do_start_sync(int argc, char **argv)
> +{
> +	int fd, res;
> +	char	*path = argv[1];
> +	__u64 transid;
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return 12;
> +	}
> +
> +	printf("StartSync '%s'\n", path);
> +	res = ioctl(fd, BTRFS_IOC_START_SYNC, &transid);
> +	close(fd);
> +	if( res < 0 ){
> +		fprintf(stderr, "ERROR: unable to fs-syncing '%s'\n", path);
> +		return 16;
> +	} else {
> +		printf("transid %llu\n", (unsigned long long)transid);
> +	}
> +
> +	return 0;
> +}
> +
> +int do_wait_sync(int argc, char **argv)
> +{
> +	int fd, res;
> +	char	*path = argv[1];
> +	__u64 transid = atoll(argv[2]);
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return 12;
> +	}
> +
> +	printf("WaitSync '%s' transid %llu\n", path, (unsigned long 
long)transid);
> +	res = ioctl(fd, BTRFS_IOC_WAIT_SYNC, &transid);
> +	close(fd);
> +	if( res < 0 ){
> +		fprintf(stderr, "ERROR: unable to wait-sync on '%s' transid 
%llu: %s\n", path,
> +			(unsigned long long)transid, strerror(errno));
> +		return 16;
> +	}
> +
> +	return 0;
> +}
> +
>  int do_scan(int argc, char **argv)
>  {
>  	int	i, fd;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index 7bde191..84c489f 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -19,6 +19,8 @@ int do_clone(int nargs, char **argv);
>  int do_delete_subvolume(int nargs, char **argv);
>  int do_create_subvol(int nargs, char **argv);
>  int do_fssync(int nargs, char **argv);
> +int do_start_sync(int nargs, char **argv);
> +int do_wait_sync(int nargs, char **argv);
>  int do_defrag(int argc, char **argv);
>  int do_show_filesystem(int nargs, char **argv);
>  int do_add_volume(int nargs, char **args);
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 26ef982..e87b5fe 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -19,6 +19,10 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
>  .PP
> +\fBbtrfs\fP \fBfilesystem start-sync\fP\fI <path> \fP
> +.PP
> +\fBbtrfs\fP \fBfilesystem wait-sync\fP\fI <path> <transid>\fP
> +.PP
>  \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max 
<filesystem>\fP
>  .PP
>  \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
> @@ -115,6 +119,16 @@ all the block devices.
>  Force a sync for the filesystem identified by \fI<path>\fR.
>  .TP
>  
> +\fBfilesystem start-sync\fR\fI <path> \fR
> +Start a sync operation for the filesystem identified by \fI<path>\fR.  A 
transaction id
> +is printed that can be waited on using the \fBfilesystem wait-sync\fR 
command.
> +.TP
> +
> +\fBfilesystem wait-sync\fR\fI <path> <transid>\fR
> +Wait for a the transaction \fI<transid>\fR to commit to disk.  If 
\fI<transid>\fR is zero,
> +wait for any currently committing transaction to commit.
> +.TP
> +
>  .\"
>  .\" Some wording are extracted by the resize2fs man page
>  .\"
> -- 
> 1.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
