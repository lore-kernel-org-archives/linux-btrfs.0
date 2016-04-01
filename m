Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:37194 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbcDAQuO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 12:50:14 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1am2Gy-0000P4-Oh
	for linux-btrfs@vger.kernel.org; Fri, 01 Apr 2016 18:50:12 +0200
Date: Fri, 1 Apr 2016 18:50:12 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Another ENOSPC situation
Message-ID: <20160401165012.GM9342@torres.zugschlus.de>
References: <20160401134029.GH9342@torres.zugschlus.de>
 <CAPmG0jY7qftBouGb=g6RC5MTS4qjmAx2S=95p=Fpqqr35bk_eA@mail.gmail.com>
 <20160401163020.GL9342@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160401163020.GL9342@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 06:30:20PM +0200, Marc Haber wrote:
> On Fri, Apr 01, 2016 at 05:44:30PM +0200, Henk Slager wrote:
> > On Fri, Apr 1, 2016 at 3:40 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > > btrfs balance -mprofiles seems to do something. one kworked and one
> > > btrfs-transaction process hog one CPU core each for hours, while
> > > blocking the filesystem for minutes apiece, which leads to the host
> > > being nearly unuseable up to the point of "clock and mouse pointer
> > > frozen for nearly ten minutes".
> > 
> > I assume you still have your every 10 minutes snapshotting running
> > while balancing?
> 
> No, I disabled the cronjob before trying the balance. I might be
> crazy, but not stup^wunexperienced.

That being said, I would still expect the code not to allow _this_
kind of effect on the entire system when two alledgely incompatible
operations run simultaneously. I mean, Linux is a multi-user,
multi-tasking operating system where one simply cannot expect all
processes to be cooperative to each other. We have the operating
systems to prevent this kind of issues, not to cause them.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
