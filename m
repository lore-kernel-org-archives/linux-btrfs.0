Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35907 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeAAMPn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jan 2018 07:15:43 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eVyyE-0007lN-P8
        for linux-btrfs@vger.kernel.org; Mon, 01 Jan 2018 13:13:34 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
Date: Mon, 1 Jan 2018 13:15:29 +0100
Message-ID: <1clphe-a7q.ln1@hurikhan77.spdns.de>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
        <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 01 Jan 2018 18:13:10 +0800 schrieb Qu Wenruo:

> On 2018年01月01日 08:48, Stirling Westrup wrote:
>> Okay, I want to start this post with a HUGE THANK YOU THANK YOU THANK
>> YOU to Nikolay Borisov and most especially to Qu Wenruo!
>> 
>> Thanks to their tireless help in answering all my dumb questions I have
>> managed to get my BTRFS working again! As I speak I have the full,
>> non-degraded, quad of drives mounted and am updating my latest backup
>> of their contents.
>> 
>> I had a 4-drive setup with 2x4T and 2x2T drives and one of the 2T
>> drives failed, and with help I was able to make a 100% recovery of the
>> lost data. I do have some observations on what I went through though.
>> Take this as constructive criticism, or as a point for discussing
>> additions to the recovery tools:
>> 
>> 1) I had a 2T drive die with exactly 3 hard-sector errors and those 3
>> errors exactly coincided with the 3 super-blocks on the drive.
> 
> WTF, why all these corruption all happens at btrfs super blocks?!
> 
> What a coincident.

Maybe it's a hybrid drive with flash? Or something that went wrong in the 
drive-internal cache memory the very time when superblocks where updated?

I bet that the sectors aren't really broken, just the on-disk checksum 
didn't match the sector. I remember such things happening to me more than 
once back in the days when drives where still connected by molex power 
connectors. Those connectors started to get loose over time, due to 
thermals or repeated disconnect and connect. That is, drives sometimes 
started to no longer have a reliable power source which let to all sorts 
of very strange problems, mostly resulting in pseudo-defective sectors.

That said, the OP would like to check the power supply after this 
coincidence... Maybe it's aging and no longer able to support all four 
drives, CPU, GPU and stuff with stable power.


-- 
Regards,
Kai

Replies to list-only preferred.

