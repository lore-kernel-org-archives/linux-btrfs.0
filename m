Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59860 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2IHQ4V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2012 12:56:21 -0400
Date: Sat, 8 Sep 2012 09:56:20 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Cc: mfasheh@suse.de
Subject: Workaround for hardlink count problem?
Message-ID: <20120908165620.GA17951@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I read the discussions on hardlinks, and saw that there was a proposed patch
(although I'm not sure if it's due in 3.6 or not, or whether I can apply it 
to my 3.5.3 tree).

I was migrating a backup disk to a new btrfs disk, and the backup had a lot of hardlinks
to collapse identical files to cut down on inode count and disk space.

Then, I started seeing:

cp: cannot create hard link `../dshelf3/backup/saroumane/20080319/var/lib/dpkg/info/libaspell15.postrm' to `../dshelf3/backup/moremagic/oldinstall/var/lib/dpkg/info/libncurses5.postrm': Too many links
cp: cannot create hard link `../dshelf3/backup/saroumane/20080319/var/lib/dpkg/info/libxp6.postrm' to `../dshelf3/backup/moremagic/oldinstall/var/lib/dpkg/info/libncurses5.postrm': Too many links
cp: cannot create symbolic link `../dshelf3/backup/saroumane/20020317_oldload/usr/share/doc/menu/examples/system.fvwmrc': File name too long
cp: cannot create hard link `../dshelf3/backup/saroumane/20061218/var/lib/dpkg/info/libxxf86vm1.postrm' to `../dshelf3/backup/moremagic/oldinstall/var/lib/dpkg/info/libncurses5.postrm': Too many links
cp: cannot create hard link `../dshelf3/backup/saroumane/20061218/var/lib/dpkg/info/libxxf86dga1.postrm' to `../dshelf3/backup/moremagic/oldinstall/var/lib/dpkg/info/libncurses5.postrm': Too many links
cp: cannot create hard link `../dshelf3/backup/saroumane/20061218/var/lib/dpkg/info/libavc1394-0.postrm' to `../dshelf3/backup/moremagic/oldinstall/var/lib/dpkg/info/libncurses5.postrm': Too many links

What's interesting is the 'File name too long' one, but more generally, 
I'm trying to find a userspace workaround for this by unlinking files that go beyond
the hardlink count that btrfs can support for now.

Has someone come up with a cool way to work around the too many link error
and only when that happens, turn the hardlink into a file copy instead?
(that is when copying an entire tree with millions of files).

I realize I could parse the errors and pipe that into some crafty shell to do this,
but if there is a smarter already made solution, I'm all ears :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
