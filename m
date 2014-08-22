Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbaHVP3O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 11:29:14 -0400
Message-ID: <53F761C9.5050300@redhat.com>
Date: Fri, 22 Aug 2014 10:29:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: marvin24@gmx.de
Subject: Re: [PATCH] btrfs-progs: init uninitialized output buf for btrfs-restore
References: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/20/14, 10:35 PM, Gui Hecheng wrote:
> A memory problem reported by valgrind as follows:
> 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
> When running:
> 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
> 
> Because the output buf size is alloced with malloc, but the length of
> output data is shorter than the sizeof(buf), so valgrind report
> uninitialised byte(s).
> We could use calloc to repalce malloc and clear this WARNING away.
> 
> Reported-by: Marc Dietrich <marvin24@gmx.de>
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>

Sorry for the noise in reply to this, I think the patch itself
is fine.  It would have clarified things to the reviewer, though,
if you had added more detail to the commit log, such as:

> If a btrfs-restore process encounters corruption and fails
> to properly decompress all data, some parts of the output
> buffer may not be initialized.  This was reported by valgrind as
> follows:
> 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
> When running:
> 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
> 
> Because the output buf size is alloced with malloc, but the length of
> output data is shorter than the sizeof(buf), so valgrind reports
> uninitialised byte(s).
>
> We could use calloc to replace malloc to ensure that all written
> bytes are initialized.

Anyway:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>  cmds-restore.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-restore.c b/cmds-restore.c
> index cbda6bb..bb72311 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -251,7 +251,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
>  	}
>  
>  	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
> -	outbuf = malloc(ram_size);
> +	outbuf = calloc(1, ram_size);
>  	if (!outbuf) {
>  		fprintf(stderr, "No memory\n");
>  		return -ENOMEM;
> @@ -320,7 +320,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
>  	}
>  
>  	if (compress != BTRFS_COMPRESS_NONE) {
> -		outbuf = malloc(ram_size);
> +		outbuf = calloc(1, ram_size);
>  		if (!outbuf) {
>  			fprintf(stderr, "No memory\n");
>  			free(inbuf);
> 

