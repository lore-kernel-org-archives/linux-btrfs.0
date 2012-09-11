Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43235 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2IKJQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 05:16:34 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Workaround for hardlink count problem?
Date: Tue, 11 Sep 2012 11:16:32 +0200
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
References: <20120908165620.GA17951@merlins.org> <201209110109.17604.Martin@lichtvoll.de> <alpine.LNX.2.01.1209110121050.22773@frira.zrqbmnf.qr> (sfid-20120911_110731_924237_D85CF14D)
In-Reply-To: <alpine.LNX.2.01.1209110121050.22773@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209111116.32850.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 11. September 2012 schrieb Jan Engelhardt:
> 
> On Tuesday 2012-09-11 01:09, Martin Steigerwald wrote:
> >> > What about:
> >> > 
> >> > - copy first backup version
> >> > - btrfs subvol create first next
> >> > - copy next backup version
> >> > - btrfs subvol create previous next
> >> 
> >> Wouldn't "btrfs subvolume snapshot", plus "rsync --inplace" more
> >> useful here? That is. if the original hardlink is caused by multiple
> >> versions of backup of the same file.
> >
> >Sure, I meant subvol snapshot in above example. Thanks for noticing.
> >
> >But I do not use --inplace as it conflicts with some other rsync options I 
> >like to use:
> 
> It is a tradeoff.
> 
> rsync "--inplace" leads to fragmentation which is detrimental for the
> speed of reads (and read-write-cycles as used by rsync) of big files
> (multi-GB) that are regularly updated, but it is probably even worse
> for smaller-than-GB files because percent-wise, they are even more
> fragmented.
> 
> $ filefrag */vm/intranet.dsk
> snap-2012-08-15/vm/intranet.dsk: 23 extents found
> snap-2012-08-16/vm/intranet.dsk: 23 extents found
> snap-2012-08-17/vm/intranet.dsk: 4602 extents found
> snap-2012-08-18/vm/intranet.dsk: 6221 extents found
[…]
> snap-2012-08-25/vm/intranet.dsk: 7464 extents found
[…]
> snap-2012-09-09/vm/intranet.dsk: 10488 extents found
> 
> Without --inplace (prerequisite to use -S) however, it will recreate
> a file if it has been touched. While this easily avoids fragmentation
> (since it won't share any data blocks with the old one), it can take
> up more space with the big files.

Yes. But I do not care as much as about sparse files. Cause for the
example I gave on a backup restore those sparse files would consume
about 1 GiB more on the SSD. Then I prefer to have some duplicated
files on the 2TB backup harddisk.

As for recreating the sparse nature of the files I´d have to format new
hardfiles and copy tons of mail files over within E-UAE. Thus I prefer
not to loose it on backup.

> >-ax --acls --xattrs --sparse --hard-links --del --delete-excluded --
> 
> I knew short options would be helpful here: -axAXSH
> (why don't they just become the standard... they are in like almost
> every other rsync invocation I ever had)

Hey, I like those. I do not have to look up in the manpage what each
option means ;)

> >       -S, --sparse
> >              Try to handle sparse files efficiently so they  take  up
> >              less space on the destination.  Conflicts with --inplace
> >              because it’s not possible to overwrite data in a  sparse
> >              fashion.
> 
> Oh and if anybody from the rsync camp reads it: with hole-punching
> now supported in Linux, there is no reason not to support "-S" with
> "--inplace", I think.

Hmm, maybe I forward this to them.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
