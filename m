Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57110 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752610AbaJVQP3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 12:15:29 -0400
Received: from 65-183-131-85-dhcp.burlingtontelecom.net ([65.183.131.85]:61418 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XgyZK-001hby-4N
	for linux-btrfs@vger.kernel.org; Wed, 22 Oct 2014 10:15:26 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: device balance times
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
Date: Wed, 22 Oct 2014 12:15:25 -0400
Message-Id: <C163903C-CE75-4296-AF34-4B27F0FE2C2C@colorremedies.com>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 21, 2014, at 9:43 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Oct 21, 2014, at 4:14 PM, Piotr Pawłow <pp@siedziba.pl> wrote:
> 
>> On 21.10.2014 20:59, Tomasz Chmielewski wrote:
>>> FYI - after a failed disk and replacing it I've run a balance; it took almost 3 weeks to complete, for 120 GBs of data:
>> 
>> Looks normal to me. Last time I started a balance after adding 6th device to my FS, it took 4 days to move 25GBs of data.
> 
> It's long term untenable. At some point it must be fixed. It's way, way slower than md raid.

Granted I'm ignoring the fact there are 5000+ snapshots, as well as the fact we were told something like ~200 is OK but things rapidly get pathological above that. Josef has some patches to better deal with this, but I'm fairly sure they're not merged yet. My "long term untenable" assertion is in relation to scalability. Another thing is the snapshot aware defrag stuff was recently pulled out and needs to be redone, which may also be a factor with this. The short term, maybe even medium term, it's "doctor, it hurts when I do this!" and the doctor says, "well then don't do that!"


Chris Murphy

