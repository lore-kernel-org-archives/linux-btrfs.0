Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaHUSm1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 14:42:27 -0400
Message-ID: <53F63D8F.2080400@redhat.com>
Date: Thu, 21 Aug 2014 13:42:23 -0500
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

It clears the valgrind error away, but does it hide a real bug?

The code does this:

        ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
        outbuf = malloc(ram_size);
        if (!outbuf) {
                fprintf(stderr, "No memory\n");
                return -ENOMEM;
        }

        ret = decompress(buf, outbuf, len, &ram_size, compress);
        if (ret) {
                free(outbuf);
                return ret;
        }

        done = pwrite(fd, outbuf, ram_size, pos);

Now, I don't know the details of the decompression routines, but
it sure *looks* to me like we have found out that "ram size" is the
size of the decompressed data, and so we allocate that much.

If valgrind detects that when we write ram_size bytes, some of
them are uninitialized, doesn't that mean that something has
gone wrong in decompression?

using calloc shuts up the warning, sure, but ...

Marc, are you using zlib or lzo?

If zlib, maybe this in decompress_zlib is a problem:

        (void)inflateEnd(&strm);
        return 0;
}

"inflateEnd returns Z_OK if success, Z_STREAM_ERROR if the stream state was inconsistent."

Josef, any idea why return value is cast away there?

Thanks,
-Eric

> Reported-by: Marc Dietrich <marvin24@gmx.de>
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
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

