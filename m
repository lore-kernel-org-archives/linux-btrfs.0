Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34319 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbbIUPCi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 11:02:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Ze2c0-0005xC-I1
	for linux-btrfs@vger.kernel.org; Mon, 21 Sep 2015 17:02:36 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 17:02:36 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 17:02:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs partition gets remounted as read only
Date: Mon, 21 Sep 2015 15:02:23 +0000 (UTC)
Message-ID: <pan$28fb6$e21baff8$67f806d3$ecee1b58@cox.net>
References: <CAOTVeoEVxAMHJ8Rw-YfAUmuvNUs3pAcEGgA7bXgOC1fToW9HYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Incorporeal Waffle posted on Mon, 21 Sep 2015 14:30:21 +0000 as excerpted:

> I tried converting my root partition (originally ext4) to btrfs.

There's some known bugs with btrfs-convert currently, with current or 
very recent discussion on-list about how to fix it, if you check the 
archives.

In the more general case, while the present bugs will no doubt be fixed, 
I (a user, not a dev) don't recommend using convert, as in the best case, 
it's a compromise, with better results if you treat the existing ext* as 
a backup and start with a brand new btrfs using mkfs.btrfs.

The admin's rule of backups states that if you care about the data, it's 
backed up, and if it's not backed up, in practice, you're defining the 
data as not worth the time and resources to back up, any claims to the 
contrary not withstanding.  (Meanwhile, a would-be backup that hasn't 
been tested restorable isn't considered a backup, because the backup 
isn't defined as complete until it is tested.)

>From that perspective, there's little reason to do a filesystem 
conversion, since if you care about the data, it's backed up and can be 
restored to a brand new filesystem, with a better layout than a 
filesystem that started as something else is likely to ever achieve, and 
if you don't care about the data, then there's no reason not to start out 
with a clean filesystem in the first place.

So while having a convert tool is "nice", even when it's working 
correctly, the best choice is to avoid using it, starting with brand new 
clean filesystem and copying existing data, if any, into it from backups 
so it is laid out ideally for the new filesystem, instead of the 
compromise of trying to work around the location of existing data and 
metadata, in a layout that should work, granted (and it's definitely a 
bug that it's not doing so today), but is unlikely to be ideal for a 
different filesystem than the one it started out as.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

