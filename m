Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:55418 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbaIEAU1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Sep 2014 20:20:27 -0400
Received: by mail-la0-f52.google.com with SMTP id b8so1985752lan.11
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 17:20:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
	<CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com>
	<pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net>
Date: Fri, 5 Sep 2014 02:20:26 +0200
Message-ID: <CANg_oxzTv3cDyS0prJc_ZLopt3YNvm7oa9dFnghV7aZGNiyMvA@mail.gmail.com>
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
From: john terragon <jterragon@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Everyone knows what raid0 entails. Moreover, with btrfs being an
experimental fs, not having backups would obviously be pure idiocy.

I wrote that it was "pretty serious" because the situation came out of
nowhere on a low-traffic fs on which the most exiciting thing that can
happen is an occasional snapshot once on a while when I do a heavy
update with apt-get (snapshot that gets always removed right after the
update goes invariably well and my paranoia fades).
The problem seems to have happen right after a hard lock probably due
to 3.17.0-rc3 (and before you explain to me what that rc3 stands for,
let me tell you that I'm not complaining, I knew what I was doing). I
had to power-off "brutally" and right after that the problem occurred.
I'm pretty sure about that because for obvious reasons I rsync the
hell out of that filesystem  every chance I get. Rsync obviously does
a traversal of the fs and so the "critical" (btrfs words, not mine)
problem would have showed on kmsg (another place that I watch like a
hawk, because of the raid0+experimental fs thing).

I don't know if you are a btrfs developer but that "pretty serious"
was not meant to offend them nor to complain. Actually I've been a
pretty happy customer up until now (and I still am) because I have
never been bitten by any big bug even with such a complex fs. I just
have this zombie directory that can't be rm'd, but I mv'd out of the
way and everything is fine. It'll get sorted when I do the next
wipe-and-restore iteration (again, being experimental, I don't let the
fs to become too "old").
So, the "pretty serious" was more due to the surprise than anything else.

John
