Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:36518 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbcDAN7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 09:59:20 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1alzba-0007oP-Ek
	for linux-btrfs@vger.kernel.org; Fri, 01 Apr 2016 15:59:18 +0200
Date: Fri, 1 Apr 2016 15:59:18 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160401135918.GI9342@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160227211450.GS26042@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 27, 2016 at 10:14:50PM +0100, Marc Haber wrote:
> I have again the issue of no space left on device while rebalancing
> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):

just for the record: The host started acting up in more and more
interesting ways, and after a call of rm during kernel build resulted
in SIGSEGV, I did the backup-format-restore routine for this system
back to ext4 just to find out whether I have bad hardware or a bad
filesystem.

And, since going back to ext4, the system is just fine again. So it's
not bad hardware.

This systems's root drive is going to stay on ext4 for a loooooong
time. If I get the btrfs phenomena I experience on other hosts get
solved at some time in the future, I might migrate /home back to
btrfs, but that's not going to happen in the next six months.

This is a really bad experience which has made me lost a lot of faith
in the new filesystem. I really feel sad about that.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
