From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Sat, 4 Feb 2012 18:07:10 -0600
Message-ID: <CAKcLGm_=bRf7g+ezE7OBRNka57Z_NcofkMW-XkGmC1jAFv0gyw@mail.gmail.com>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
	<82ivv8-dsn.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <82ivv8-dsn.ln1@hurikhan.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 4, 2012 at 5:40 AM, Kai Krakow <hurikhan77+btrfs@gmail.com>=
 wrote:
> Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:
>
>> Just happened while writing a huge avi file to my usb3 backup disk:
>>
>> [356036.596292] ------------[ cut here ]------------
>> [356036.596300] kernel BUG at fs/btrfs/inode.c:1588!
> [...]
>>
>> btrfsck now finds many of these:
>>
>> jupiter ~ # btrfsck /dev/sde1
>> root 256 inode 12746 errors 400
>> root 256 inode 12747 errors 400
>> root 256 inode 12748 errors 400
>> root 256 inode 12749 errors 400
>> root 256 inode 17141 errors 400
>> root 256 inode 219966 errors 400
>> root 256 inode 224243 errors 400
>> root 256 inode 225245 errors 400
>> root 256 inode 225354 errors 400
>> root 256 inode 290639 errors 2000
>> root 256 inode 291751 errors 2000
>
> It looks like the latter isn't a consequence of the former. I found k=
ernel
> commit f70a9a6b9 which is supposed to do something about "inode error=
s 400":
>
> commit f70a9a6b94af86fca069a7552ab672c31b457786
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date: =A0 Thu Jan 12 19:10:12 2012 -0500
> Btrfs: fix btrfsck error 400 when truncating a compressed
>
> It's actually the case for me that rsync writes to the device using m=
ount
> options "compress-force=3Dzlib" and that rsync probably truncates fil=
es
> sometimes when using the inplace option.
>
> So that occurence is explained. Can anyone tell how bad it is to have=
 this
> error? May the fs explode at some point or is it just an error I coul=
d
> safely ignore for the moment?
>
> And what about the "inode errors 2000"? What's the 2000 standing for?
>

As I understand it, Miao Xie's "Btrfs: fix btrfsck error 400 when
truncating a compressed" patch was intended to address only one
scenario that would lead to 400 errors.  It was not intended to
comprehensively address problems that generate inode 400 errors, nor
will this patch fix the error once it encountered.

As it stands right now, if you have errors reported by btrfsck, and
you've exhausted the tools available for addressing errors (scrub and
zero-ing out the log are the only two I know of), you only really have
two options (until further tools such as btrfsck are released):

(1)  Run with the errors and cross your fingers.
(2)  Backup and restore onto a freshly formatted  volume (there are
some new tools available to extract data if you encounter errors).

My personal preference is to backup and restore.

With respect to the error codes, you have to look in the source for
btrfsck.c.  Inode errors are defined as I_ERR_<error>.

0x400 (1 << 8) errors are I_ERR_FILE_NBYTES_WRONG
0x2000 (1 << 13) errors are I_ERR_LINK_COUNT_WRONG

The 400 inode errors have been common lately.  I haven't seen as many
2000 inode errors.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
