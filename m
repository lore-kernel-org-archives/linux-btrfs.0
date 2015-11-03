Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbbKCTPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Nov 2015 14:15:43 -0500
Date: Tue, 3 Nov 2015 11:15:42 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jbacik@fb.com, Chris Mason <clm@fb.com>
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
Message-ID: <20151103191542.GD15575@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag>
 <5636BDA0.4020200@cn.fujitsu.com>
 <5636F89E.3010806@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5636F89E.3010806@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 06:46:06AM +0100, Stefan Priebe wrote:
> Am 02.11.2015 um 02:34 schrieb Qu Wenruo:
> >
> >
> >Stefan Priebe wrote on 2015/11/01 21:49 +0100:
> >>Hi,
> >>
> >>this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html
> >>
> >>adds a regression to my test systems with very large disks (30tb and
> >>50tb).
> >>
> >>btrfs balance is super slow afterwards while heavily making use of cp
> >>--reflink=always on big files (200gb - 500gb).
> >>
> >>Sorry didn't know how to correctly reply to that "old" message.
> >>
> >>Greets,
> >>Stefan
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >Thanks for the testing.
> >
> >Are you using qgroup or just doing normal balance with qgroup disabled?
> 
> just doing normal balance with qgroup disabled.

Then that patch is very unlikely to be your actual problem as it won't be
doing anything (ok some kmalloc/free of a very tiny object) since qgroups
are disabled.

Also, btrfs had working subtree accounting in that code for the last N
releases (doing the same exact thing) and it only changed for the one
release that Qu's rework was in (which lazily tore it out).
	--Mark

--
Mark Fasheh
