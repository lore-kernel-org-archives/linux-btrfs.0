Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39599 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab2IJXJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 19:09:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Workaround for hardlink count problem?
Date: Tue, 11 Sep 2012 01:09:17 +0200
Cc: "Fajar A. Nugraha" <list@fajar.net>
References: <20120908165620.GA17951@merlins.org> <201209101112.34839.Martin@lichtvoll.de> <CAG1y0scP+O9kTLiF5ZpxRwZTbOFQWctQDquCu4ATSwYyE3SZmQ@mail.gmail.com> (sfid-20120910_140743_108130_BF222C36)
In-Reply-To: <CAG1y0scP+O9kTLiF5ZpxRwZTbOFQWctQDquCu4ATSwYyE3SZmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201209110109.17604.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 10. September 2012 schrieb Fajar A. Nugraha:
> On Mon, Sep 10, 2012 at 4:12 PM, Martin Steigerwald 
<Martin@lichtvoll.de> wrote:
> > Am Samstag, 8. September 2012 schrieb Marc MERLIN:
> >> I was migrating a backup disk to a new btrfs disk, and the backup
> >> had a lot of hardlinks to collapse identical files to cut down on
> >> inode count and disk space.
> > 
> >> Then, I started seeing:
> > […]
> > 
> >> Has someone come up with a cool way to work around the too many link
> >> error and only when that happens, turn the hardlink into a file copy
> >> instead? (that is when copying an entire tree with millions of
> >> files).
> > 
> > What about:
> > 
> > - copy first backup version
> > - btrfs subvol create first next
> > - copy next backup version
> > - btrfs subvol create previous next
> 
> Wouldn't "btrfs subvolume snapshot", plus "rsync --inplace" more
> useful here? That is. if the original hardlink is caused by multiple
> versions of backup of the same file.

Sure, I meant subvol snapshot in above example. Thanks for noticing.

But I do not use --inplace as it conflicts with some other rsync options I 
like to use:

-ax --acls --xattrs --sparse --hard-links --del --delete-excluded --
exclude-from "debian-exclude"

Yes, it was --sparse:

       -S, --sparse
              Try to handle sparse files efficiently so they  take  up
              less space on the destination.  Conflicts with --inplace
              because it’s not possible to overwrite data in a  sparse
              fashion.

As I have some pretty big sparse files, I went without --inplace:

martin@merkaba:~/Amiga> du -sch M-Archiv.hardfile Messages.hardfile 
241M    M-Archiv.hardfile
726M    Messages.hardfile
966M    insgesamt
martin@merkaba:~/Amiga> ls -lh M-Archiv.hardfile Messages.hardfile 
-rw-r----- 1 martin martin 1,0G Mär 27  2005 M-Archiv.hardfile
-rw-r----- 1 martin martin 1,0G Sep 10 17:33 Messages.hardfile
martin@merkaba:~/Amiga>

(my old mails when I used Amiga as my main machine, still accessible via 
e-uae ;)

Anyway, I think that will be solved by btrfs send/receive.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
