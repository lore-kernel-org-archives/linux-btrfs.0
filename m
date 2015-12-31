Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33761 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbLaUnv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 15:43:51 -0500
Received: by mail-io0-f174.google.com with SMTP id q21so98343773iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 12:43:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151231202419.GZ1586@carfax.org.uk>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
	<20151231202419.GZ1586@carfax.org.uk>
Date: Thu, 31 Dec 2015 13:43:51 -0700
Message-ID: <CAJCQCtSrvtMFPEaB4fodprJ4oZk_Sz3xeVx33O95fGve104zxA@mail.gmail.com>
Subject: Re: btrfs fail behavior when a device vanishes
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 1:24 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Dec 31, 2015 at 01:11:25PM -0700, Chris Murphy wrote:
>> This is a torture test, no data is at risk.
>>
>> Two devices, btrfs raid1 with some stuff on them.
>> Copy from that array, elsewhere.
>> During copy, yank the active device.
>>
>> dmesg shows many of these:
>>
>> [ 7179.373245] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr
>> 652123, rd 697237, flush 0, corrupt 0, gen 0
>>
>> Why are the write errors nearly as high as the read errors, when there
>> is only a copy from this device happening?
>
>    I'm guessing completely here, but maybe it's trying to write
> corrected data to sdc1, because the original read failed?
>

Egads. OK that makes sense.

-- 
Chris Murphy
