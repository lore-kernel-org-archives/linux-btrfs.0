Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54845 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754479AbaIPBRA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 21:17:00 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49350 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XThO6-000lU9-UB
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 19:16:59 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: unable to mount, tools segfault
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5F01E283-D95E-4F81-B358-6470ABD58C0D@colorremedies.com>
Date: Mon, 15 Sep 2014 19:16:57 -0600
Message-Id: <45CDD4CC-7486-4074-A8E1-4573C40F8462@colorremedies.com>
References: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com> <5F01E283-D95E-4F81-B358-6470ABD58C0D@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 15, 2014, at 6:56 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Sep 15, 2014, at 3:41 PM, Tony Murray <murraytony@gmail.com> wrote:
>> 
>> # btrfs restore -v -i /dev/sda7 /mnt/sdb1/
> 
> Starting with umounted volume:
> 
> btrfs check <dev>
> btrfs-debug-tree -R <dev>

Oh nevermind I just saw that you did a btrfsck --repair, so you really kinda got the sequence wrong by doing that so soon and without list advice. I don't see whether you tried btrfs-zero-log first, or btrfs rescue super-recover, did you?

btrfs-debug-tree -R should show four backup slots, and it's possible to plug in the tree root block value into btrfs restore -t, and maybe extract some data. And then it gets more aggressive from there, by seeing if you get any different recovery results with kernel 3.17rc5; and then it's btrfs-progs integration branch territory to see if maybe btrfs-zero-log or btrfs check will do something differently.


Chris Murphy