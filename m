Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbaF0O4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 10:56:12 -0400
Message-ID: <53AD860A.8090804@redhat.com>
Date: Fri, 27 Jun 2014 09:56:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
References: <53AC84C9.2080106@redhat.com> <20140627134257.GE1553@twin.jikos.cz>
In-Reply-To: <20140627134257.GE1553@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/27/14, 8:42 AM, David Sterba wrote:
> On Thu, Jun 26, 2014 at 03:38:33PM -0500, Eric Sandeen wrote:
>> +FILE ATTRIBUTES
>> +---------------
>> +The btrfs filesystem supports setting the following file
>> +attributes the `chattr`(1) utility
>> +append only (a), no atime updates (A), compressed (c), no copy on write (C),
>> +no dump (d), synchronous directory updates (d), immutable (i),
>> +synchronous updates (S), and no compression (X).
> 
> The formatting is not eye-pleasing.
> 
> I've spotted a few mistakes:
> 
> * 'd' is listed twice, for sync directory updates it's 'D'

Crud, sorry about that.

> * and 'X' does not mean "no compression" and never has, although I'd
>   like to see a chattr bit for that because we have the corresponding
>   inode bit

Ok, then I'm not sure what it does mean.  Supposedly these flags are supported;
via check_flags(), called by setflags(), which I was basing these on:

        if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
                      FS_NOATIME_FL | FS_NODUMP_FL | \
                      FS_SYNC_FL | FS_DIRSYNC_FL | \
                      FS_NOCOMP_FL | FS_COMPR_FL |
                      FS_NOCOW_FL))

and the kernel header says that's:

#define FS_NOCOMP_FL                    0x00000400 /* Don't compress */

chattr(1) says: "compression raw access (X)," and also "The ’X’ attribute
is used by the experimental compression patches to indicate that a raw
contents of a compressed file  can  be  accessed  directly.  It currently 
may not be set or reset using chattr(1), although it can be displayed by lsattr(1)."

Hum, ok, so we are starting to go off the rails here, aren't we ;)

e2fsprogs has this flag translation:
         { EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
for:
#define EXT2_NOCOMPR_FL                 0x00000400 /* Access raw compressed data */

and btrfs_ioctl_setflags claims to handle it:

        if (flags & FS_NOCOMP_FL) {
                ip->flags &= ~BTRFS_INODE_COMPRESS;
                ip->flags |= BTRFS_INODE_NOCOMPRESS;
		...

so hopefully you can understand my confusion? ;)

The comment says:

         * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
         * flag may be changed automatically if compression code won't make
         * things smaller.

(but doesn't says "may *only* be...")

But OTOH, chattr won't ever even *pass* "X" to the fs, will it.

So I guess I'm lost.  It looks like there's code to handle an incoming
"X" but I don't think chattr will send it.

Do we ever get an outbound "X" for an opportunistically not-compressed file?
If so, maybe that still needs to be specified.

Otherwise, yeah, the *format* changes look great, thanks. ;)

-Eric


> I've checked your patches, the meaning of 'X' hasn't changed.
> 
> I took the opportunity and reformated the options:
> 
> @@ -183,9 +183,24 @@ FILE ATTRIBUTES
>  ---------------
>  The btrfs filesystem supports setting the following file
>  attributes the `chattr`(1) utility
> -append only (a), no atime updates (A), compressed (c), no copy on write (C),
> -no dump (d), synchronous directory updates (d), immutable (i),
> -synchronous updates (S), and no compression (X).
> +
> +*a* -- append only
> +
> +*A* -- no atime updates
> +
> +*c* -- compressed
> +
> +*C* -- no copy on write
> +
> +*d* -- no dump
> +
> +*D* -- synchronous directory updates
> +
> +*i* -- immutable
> +
> +*S* -- synchronous updates
> 
>  For descriptions of these attribute flags, please refer to the
>  `chattr`(1) man page.
> ---
> 
> looks almost the same in the manpage and gives IMO a good
> overview. For initial patch I'm ok with the descriptions, we can enhance it
> later with btrfs specifics.
> 
> Are you ok with the proposed changes? (I don't want to bother with
> resending for simple changes.)
> 

