Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:44156 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdIRIUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 04:20:30 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id B675FB48069
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 08:20:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 08:20:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 18 Sep 2017 17:20:22 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
Message-ID: <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> # df -h /var/lib/lxd
>> 
>> FWIW, standard (aka util-linux) df is effectively useless in a 
>> situation
>> such as this, as it really doesn't give you the information you need 
>> (it
>> can say you have lots of space available, but if btrfs has all of it
>> allocated into chunks, even if the chunks have space in them still, 
>> there
>> can be problems).

I see here on RAID-1, "df -h" it shows pretty much the same amount of 
free space as "btrfs fi show":

- "df -h" shows 105G free
- "btrfs fi show" says: Free (estimated):            104.28GiB      
(min: 104.28GiB)



> But chances are pretty good that one you get that patch integrated,
> whether by integrating it yourself to what you have currently, or by
> trying 4.14-rc1 or waiting until it hits release or stable, that bug 
> will
> have been squashed! =:^)

OK, will wait for 4.14.


Tomasz Chmielewski
https://lxadm.com
