Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52B1C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 18:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AF0220870
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 18:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AF0220870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbeJKBnj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 21:43:39 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:40764 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJKBnj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 21:43:39 -0400
Received: from tux.wizards.de (p3EE2F45F.dip0.t-ipconnect.de [62.226.244.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 36E6B4167C14;
        Wed, 10 Oct 2018 20:20:19 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 9086BF01602;
        Wed, 10 Oct 2018 20:20:18 +0200 (CEST)
Subject: Re: Scrub aborts due to corrupt leaf
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <d885e7ef-c78d-d89a-fc71-f1d4d7b12b31@applied-asynchrony.com>
Date:   Wed, 10 Oct 2018 20:20:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/10/18 19:25, Larkin Lowrey wrote:
> On 10/10/2018 12:04 PM, Holger Hoffstätte wrote:
>> On 10/10/18 17:44, Larkin Lowrey wrote:
>> (..)
>>> About once a week, or so, I'm running into the above situation where
>>> FS seems to deadlock. All IO to the FS blocks, there is no IO
>>> activity at all. I have to hard reboot the system to recover. There
>>> are no error indications except for the following which occurs well
>>> before the FS freezes up:
>>>
>>> BTRFS warning (device dm-3): block group 78691883286528 has wrong amount of free space
>>> BTRFS warning (device dm-3): failed to load free space cache for block group 78691883286528, rebuilding it now
>>>
>>> Do I have any options other the nuking the FS and starting over?
>>
>> Unmount cleanly & mount again with -o space_cache=v2.
> 
> It froze while unmounting. The attached zip is a stack dump captured
> via 'echo t > /proc/sysrq-trigger'. A second attempt after a hard
> reboot worked.

Trace says freespace cache writeout failed midway while the scsi device
was resetting itself and then went aaaarrrghh. Probably managed to hit
different blocks on the second attempt. So chances are your controller,
disk or something else is broken, dying, or both.
When things have settled and you have verified that r/o mounting works
and is stable, try rescuing the data (when necessary) before scrubbing,
dm-device-checking or whatever you have set up.

-h
