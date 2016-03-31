Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33756 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbcCaUhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 16:37:05 -0400
Received: by mail-lf0-f53.google.com with SMTP id p188so40489129lfd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 13:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160331222751.0585f1a7@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
	<56F7E65C.7020300@gmx.com>
	<20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
	<56FC7E6D.8010805@cn.fujitsu.com>
	<56FC8C15.5060002@cn.fujitsu.com>
	<20160331222751.0585f1a7@jupiter.sol.kaishome.de>
Date: Thu, 31 Mar 2016 22:37:03 +0200
Message-ID: <CAPmG0jZ=d=t7iJBDHykT2RL6zFFPAuuoWtfiHwrBQt0+89LrKw@mail.gmail.com>
Subject: Re: bad metadata crossing stripe boundary
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Would you please try the following patch based on v4.5 btrfs-progs?
>> https://patchwork.kernel.org/patch/8706891/
>>
>> According to your output, all the output is false alert.
>> All the extent starting bytenr can be divided by 64K, and I think at
>> initial time, its 'max_size' may be set to 0, causing "start + 0 - 1"
>> to be inside previous 64K range.
>>
>> The patch would update cross_stripe every time the extent is updated,
>> so such temporary false alert should disappear.
>
> Applied and no more reports of crossing stripe boundary - thanks.
>
> Will this go into 4.5.1 or 4.5.2?

It is not in 4.5.1
