Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8D9C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C199420883
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfAIBKy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:10:54 -0500
Received: from [195.159.176.226] ([195.159.176.226]:58960 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbfAIBKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:10:54 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gh2MK-00083P-B8
        for linux-btrfs@vger.kernel.org; Wed, 09 Jan 2019 02:08:40 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balance of Raid1 pool, does not balance properly.
Date:   Wed, 9 Jan 2019 01:08:34 +0000 (UTC)
Message-ID: <pan$1fea6$3b8d5139$fd9c8f61$c86a0817@cox.net>
References: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; edad96df2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Karsten Vinding posted on Tue, 08 Jan 2019 20:40:12 +0100 as excerpted:

> Hello.
> 
> I have a Raid1 pool consisting of 6 drives, 3 3TB disks and 3 2TB disks.
> 
> Until yesterday it consisted of 3 2TB disks, 2 3TB disks and one 1TB
> disk.
> 
> I replaced the 1TB disk as the pool was close to full.
> 
> Replacement went well, and I ended up with 5 almost full disks, and 1
> 3TB disk that was one third full.
> 
> So I kicked of a balance, expecting it to balance the data as evenly as
> possible on the 6 disks (btrfs balace start poolname).
> 
> The balance ran fine but I ended up with this:
> 
> Total devices 6 FS bytes used 5.66TiB
>          devid    9 size 2.73TiB used 2.69TiB path /dev/sdf
>          devid   10 size 1.82TiB used 1.78TiB path /dev/sdb
>          devid   11 size 1.82TiB used 1.73TiB path /dev/sdc
>          devid   12 size 1.82TiB used 1.73TiB path /dev/sdd
>          devid   13 size 2.73TiB used 2.65TiB path /dev/sde
>          devid   15 size 2.73TiB used 817.87GiB path /dev/sdg
> 
> The sixth drive sdg, is still only one third full.
> 
> How do I force BTRFS to distribute the data more evenly across the
> disks?
> 
> The way BTRFS has done it now, will bring problems, when I write more
> data to the array.

After doing the btrfs replace to the larger device, did you resize to the 
full size of the larger device as noted in the btrfs-replace manpage (but 
before you do please post btrfs device usage from before, and then again 
after the resize, as below)?  I ask because that's an easy to forget step 
that you don't specifically mention doing.

If you didn't, that's your problem -- the filesystem on that device is 
still the size of the old device, and needs resized to the larger size of 
the new one, after which a balance should work as expected.

Note that there is very recently reported bug in the way btrfs filesystem 
usage reports the size in this case, adding the device slack to 
unallocated altho it can't actually be allocated by the filesystem at all 
as the filesystem size doesn't cover that space on that device.  I 
thought the bug didn't extend to show, which would indicate that you did 
the resize and just didn't mention it, but am asking as that's otherwise 
the most likely reason for the listed behavior.

I /believe/ btrfs device usage indicates the extra space in its device 
slack line, but the reporter had already increased the size by the time 
of posting and hadn't run btrfs device usage previous to that, and it was 
non-dev list regulars in the discussion that didn't know for sure and 
didn't have a replaced and as yet unresized-filesystem device to check, 
so we haven't actually verified whether it displays correctly or not yet.

Thus the request for the btrfs device usage output, to verify all that 
for both your case and the previous similar thread...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

