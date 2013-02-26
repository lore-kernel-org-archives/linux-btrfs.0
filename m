Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43134 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3BZM64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 07:58:56 -0500
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 9D8FFA6
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 13:58:55 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Date: Tue, 26 Feb 2013 13:58:55 +0100
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com> <201302261209.54617.Martin@lichtvoll.de> <CA+WRLO-Tx0sUQd3ibszckzayUFvK9KJqWcQHrkDoEf2F-yo-+Q@mail.gmail.com> (sfid-20130226_135550_378708_0629B7A4)
In-Reply-To: <CA+WRLO-Tx0sUQd3ibszckzayUFvK9KJqWcQHrkDoEf2F-yo-+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302261358.55623.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 26. Februar 2013 schrieb Gareth Pye:
> On Tue, Feb 26, 2013 at 10:09 PM, Martin Steigerwald
> 
> <Martin@lichtvoll.de> wrote:
> > I´d still like that for df, whose output is quite bogus in certain
> > BTRFS setups at the moment and does not give applications a realistic
> > estimate at all. One example is raid 1 with 10 GB each disk. Shows 20
> > GB free. An application which wants to write 15 GB will fail. Which
> > can break installer scripts, package management, cache software or
> > anything else which checks for free space. Thus I´d like df to default
> > to *minimum* free.
> 
> Is that any better than the script failing to attempt to install
> because it needs 15G but because some of the storage is used in RAID1
> then df shows 10G free but the 15G install would work fine. If you
> could force the tool to install where it know it doesn't have
> sufficient space?

I do not quite understand your question. In RAID-1 with 10 GB and two disks, 
df will show 20 GB free. If the script needs 15 GB and checks for it it 
would run, but then fail. I would prefer that the script space check bails 
out in that case it is know that there is not enough space available 
anymore.

So or so one can always argue that current free space is just a snapshot of 
the current moment and there is *never* a guarentee that there is enough 
space, cause another application may write to the filesystem at the same 
time.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
