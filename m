Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62184 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab2FAIxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2012 04:53:39 -0400
Received: by vbbff1 with SMTP id ff1so1154200vbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jun 2012 01:53:38 -0700 (PDT)
MIME-Version: 1.0
From: Randall Mason <randall@mason.ch>
Date: Fri, 1 Jun 2012 11:53:18 +0300
Message-ID: <CADP2XCmhPX9HyLn6XWs4jgDHhHj8S1-G8PrZo50m4pRRXVft7A@mail.gmail.com>
Subject: Uncorrectable errors on newly extended volume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having a problem with a newly extended btrfs volume.  It is
running on debian testing with an almost stock 3.1.0 kernel with a
little bit of patches to get it compiling for my LaCie Network Space
v2 'Classic' (http://lacie.nas-central.org/wiki/Category:Network_Space_2).
 It's been working perfectly for about a year and a half with just the
internal sda2 and I've had luck with extending disks before so I added
a 3TB usb drive.  My dad wanted to backup his computer so I gave him
an SMB share and he copied everything using Windows Vista's internal
copy to it.  The copy checked out by comparing sized and file/folder
counts, but we didn't verify anything else.  He is now needing to
restore the backup and he is getting zero sized files.  I checked the
some of the same files on the NAS itself and I get:
> ERROR: cannot read `<filename>' (Input/output error)

I checked my kernel logs to see what the deal was and I didn't see
anything that makes sense so I ran a scrub:
sudo /sbin/btrfs scrub status .
> scrub status for 3a29a904-ad28-4e2a-8e80-df29d8d5fafc
>         scrub started at Thu May 31 10:15:39 2012 and finished after 27581 seconds
>         total bytes scrubbed: 1.00TB with 23929636 errors
>         error details: csum=23929636
>         corrected errors: 0, uncorrectable errors: 23929636, unverified errors: 0

These are the most frequent lines in the kern.log:
>   1189 <datetime> <hostname> kernel: scrub_fixup: <number> callbacks suppressed
>   1442 <datetime> <hostname> kernel: btrfs_readpage_end_io_hook: <number> callbacks suppressed
>  11900 <datetime> <hostname> kernel: btrfs: unable to fixup at <number>
>  14538 <datetime> <hostname> kernel: btrfs csum failed ino <number> off <number> csum <number> private <number>
> 237549 <datetime> <hostname> kernel: bio too big device sdb1 (<number> > <number>)

Many are from the scrub that I ran after I was getting I/O errors, but
all of the non-scrub related errors were happening before I ran a
scrub.  If you need more info, my kern.log run through 7z is 322kB,
but I don't know if that will help.  I rebooted the device out of
desperation to see if it would help and when it came back up the btrfs
volume wouldn't mount using the origional sda2, but mounted fine when
I mounted the sdb1:
> May 31 10:05:48 eeyore kernel: device fsid 3a29a904-ad28-4e2a-8e80-df29d8d5fafc devid 1 transid 132729 /dev/sda2
> May 31 10:05:48 eeyore kernel: btrfs: failed to read chunk tree on sda2
> May 31 10:05:48 eeyore kernel: btrfs: open_ctree failed
Trying "mount /dev/sdb1 /var/lib/btrfs" worked:
> May 31 10:11:14 eeyore kernel: device fsid 3a29a904-ad28-4e2a-8e80-df29d8d5fafc devid 2 transid 132729 /dev/sdb1
Then a mount -a worked to get /home mounted again.

So, the question:  What went wrong?  Is there any hope of getting my
Dad's data back?  How should I proceed from here?  Delete the volume
and start from scratch?  Is btrfs not compatible with the size of
disk/volume on this architecture?  Is the external disk broken?
Should I use a different filesystem?  Why were there no indications of
error when copying?  If worse comes to worse, how can I tell which
files are bad?  Can scrub go through and unlink the bad files?

Thanks for such a great file system and thanks for any help you can give.

--
Randall Mason
randall@mason.ch

Here is some more information that may help:

fstab:
> UUID=3a29a904-ad28-4e2a-8e80-df29d8d5fafc /var/lib/btrfs  btrfs   defaults                0 0
> UUID=3a29a904-ad28-4e2a-8e80-df29d8d5fafc /home           btrfs   defaults,subvol=current 0 0

sudo /sbin/btrfs filesystem show /dev/sdb1
> Label: none  uuid: 3a29a904-ad28-4e2a-8e80-df29d8d5fafc
>         Total devices 2 FS bytes used 1.04TB
>         devid    2 size 2.73TB used 185.50GB path /dev/sdb1
>         devid    1 size 922.19GB used 922.19GB path /dev/sda2
> Btrfs Btrfs v0.19

dpkg -l | grep -i btrfs
> ii  btrfs-tools                           0.19+20120328-1                    Checksumming Copy on Write Filesystem utilities
