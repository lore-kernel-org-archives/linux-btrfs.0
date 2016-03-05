Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39664 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbcCEOMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 09:12:34 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acCwa-00065j-Rf
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 15:12:32 +0100
Date: Sat, 5 Mar 2016 15:12:32 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: balance hangs and starts again on reboot
Message-ID: <20160305141232.GB1902@torres.zugschlus.de>
References: <20160304173125.GA1902@torres.zugschlus.de>
 <CAJCQCtTtfwQgt5+MwP9QjKMLwAM+StMSq+DFDTMTV7u_78t45g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTtfwQgt5+MwP9QjKMLwAM+StMSq+DFDTMTV7u_78t45g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I apologize for not being able to deliver logs in the way you might
find them more helpful.

On Fri, Mar 04, 2016 at 12:08:10PM -0700, Chris Murphy wrote:
> On Fri, Mar 4, 2016 at 10:31 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > I have another btrfs on the same host that has no the no space left on
> > device balance issue, but on another disk. On this btrfs, it seems
> > like a balance process is stuck, with a lot of hanging kernel
> > threads. After a reboot, when I mount the filesystem, the balance
> > immediately starts again. btrfs balance cancel just hangs around with
> > no visible reaction for hours.
> >
> > Log appended. Is there rescue?
> 
> The log is made much more useful if you can sysrq+w while the blocked
> task is happening; and then dmesg or journalctl -k to get the results
> into a file for attachment to avoid the annoying MUA wrapping.

This list has repeatedly eaten log attachments without giving any
indication why. I had assumed that attachments are disallowed here,
and am taking careful attention that inserted logs are not wrapped on
my side. The list archives
(http://www.spinics.net/lists/linux-btrfs/msg52663.html) show that my
efforts not to cause wrapping on my side were actually successful.

What is the most helpful way to include logs? Pastebinning them would
probably reduce the list archives' usefulness due to pastebin
expiring, attaching doesn't work (see above), and including them
causes "annoying MUA wrapping".  I do only have 24 years of e-mail
experience, so I'm a clueless newbie, maybe one can give advice how to
do that properly.

I'm going to try the sysrq+w thing next time things happen.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
