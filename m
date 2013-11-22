Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50242 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3KVV0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 16:26:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjyFL-0002Ph-Ba
	for linux-btrfs@vger.kernel.org; Fri, 22 Nov 2013 22:26:39 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 22:26:39 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 22:26:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: [virt-devel] btrfs NOCOW for VM disk images
Date: Fri, 22 Nov 2013 21:26:16 +0000 (UTC)
Message-ID: <pan$25aa5$1906a260$3a199c05$d941ebdc@cox.net>
References: <20131122142051.GA32192@stefanha-thinkpad.redhat.com>
	<1616992290.20969836.1385137054390.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Dulaney posted on Fri, 22 Nov 2013 11:17:34 -0500 as excerpted:

> In upstream QEMU we're discussing patches that set the NOCOW flag on
> disk image files.  We're told that this increases btrfs performance
> greatly since the file system will modify data in-place like ext4/xfs.

Indeed.  For VM images and similar large "internally modified" files, 
NOCOW is definitely recommended, since otherwise they can very rapidly 
become extremely heavily fragmented.  This is a use-case that COW-based 
filesystems simply don't deal well with, so turning off the COW is 
definitely recommended.

> During testing I found that the NOCOW flag prevents file cloning from
> working.  cp --reflink fails with EINVAL when the source file has the
> NOCOW flag set.

That would be expected, since disabling COW means the file will be 
updated in-place, and if reflink-copying was allowed, changing the one 
view in-place would by definition change the other view of the same file, 
since it /is/ the same file data.

If you want both views of the file to change together, why not use a 
normal hardlink?  If you don't want them to change together, then you 
can't set NOCOW and reflink-copy, since by definition NOCOW makes changes 
in-place, and if reflinks were allowed, that'd change both views.

Quoting the cp manpage --reflink discussion:

>>>>

When --reflink[=always] is specified, perform a lightweight copy, where 
the data blocks are copied only when modified.  If this is not possible 
the copy fails, or if --reflink=auto is specified, fall back to a 
standard copy.

<<<<

Since you disabled COW, the data blocks cannot be copied when modified, 
so the copy fails (or with auto falls back to a normal copy).  Defined, 
documented and expected behavior.

> It is not possible to toggle NOCOW back and forth later on since it can
> only be set when no data has been allocated for the file yet.
> 
> This leaves us with the choice between performance (NOCOW) and snapshots
> (default).  Both are important for VM disk images!
> 
> Questions:
> 
>  * Would it be possible to extend btrfs so that cp --reflink works on
>    NOCOW files?  (Clueless idea: quiesce I/O to the NOCOW file and clone
>    it, then resume I/O and COW only writes to shared blocks.)

Of course it's /possible/, but doing so would pervert the definition of 
NOCOW or of reflink or both.  Either reflinks would effectively become 
hardlinks and writing to one view of the NOCOW data would change them 
all, or it would no longer be NOCOW.  Since hardlinks already exist as a 
solution and COW is the default...

>  * Does NOCOW prevent any other functionality besides file-level
>  cloning?

Being a simple btrfs user/sysadmin, I'm not sure about the file-level 
option, but certainly when given as a mount option (nodatacow)[1], both 
data checksumming and file compression are turned off as well.  Given the 
technical requirements, I'd assume the same applies to NOCOW file 
attributes as well.

It's worth noting that there have been several bugs related to this as 
well, where btrfs was doing the wrong thing with "internally changed" 
files in one case or another.  One now fixed bug was triggered most often 
with systemd's journal, where systemd was doing direct-IO and btrfs 
wasn't properly handling checksums.  (Someone else reported a file-
preallocating bittorrent client triggering that same bug, so it wasn't 
/just/ systemd triggering it, but systemd was the most widely deployed 
and thus most common trigger.)   Turning off checksums for this sort of 
"internally changed" image file thus becomes the easiest way to avoid 
such issues and NOCOW is the way this type of file usage pattern is 
conveyed to the filesystem.   Mixing compression and internal-writes is 
another problematic situation, so turning that off for NOCOW files also 
makes sense.

>  * Does NOCOW increase risk of data loss/corruption?  (I guess yes since
>    overwriting in place puts data at risk of power failure or drive
>    failure.)

Absolutely, for that file at least.  The loss of data checksumming means 
loss of that normally important data integrity check as well, tho at the 
same time it's actually safer in some ways since you don't have the 
filesystem checksums fighting and racing with the internal file updates, 
the source of the now fixed systemd journal triggered bug mentioned above.

However, NOCOW on a large and very frequently internally changed file  
arguably makes other data/metadata on the filesystem safer, since the 
very frequent changes are now contained and isolated to their own 
unchanging location on the filesystem, no constantly changing partially 
shared extent tracking metadata and data checksum records to be keeping 
updated at the same time, thus no possibility of endangering the other 
files sharing the same metadata records.

[1] Btrfs mount options.  They aren't yet documented in the mount manpage, 
and mount doesn't ship with btrfs-progs so there's no manpage 
documentation for mount options there, so the kernel's btrfs.txt file and 
the wiki are the only good places to look up btrfs-specific mount-options:

https://btrfs.wiki.kernel.org/index.php/Mount_options

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

