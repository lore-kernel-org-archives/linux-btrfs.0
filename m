Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:33846 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932841AbeD1DJq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 23:09:46 -0400
Received: by mail-ot0-f181.google.com with SMTP id i5-v6so4172038oth.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 20:09:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk> <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 27 Apr 2018 21:09:45 -0600
Message-ID: <CAJCQCtTbC1iDBfNp26TPkjYvLd2TyTtoCZVSuKpoFL6D19W5yg@mail.gmail.com>
Subject: Re: Problems with btrfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "David C. Partridge" <david.partridge@perdrix.co.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 6:20 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年04月28日 02:38, David C. Partridge wrote:
>> I'm running Ubuntu 16.04.  I rebooted my server today as it wasn't
>> responding.
>>
>> When I rebooted the root FS was read only.
>>
>> I booted a live Ubuntu CD and checked the drive with the results shown in
>> attachment btrfs-check.log.
>>
>> The error was still there after completing the btrfs check --repair :( And
>> when I deleted some old subvolumes from there after that the filesystem went
>> read-only with a bunch errors in dmesg which are in the attached file
>> btrfs-dmesg-errs.log.
>>
>> Of course my last backup was longer ago than I like to think about. Though I
>> could restore back to about 8 months ago, I'd very much prefer not to ...
>>
>> On my bootable CD the Kernel is 4.18.3 and btrfs-progs is 4.7.3-1
>
> Hello time traveler. :)
> Or it's just 4.16.3.

4.8.13 actually according to the dmesg

The problem might have been setup by this problem (and fix in later kernels)
https://patchwork.kernel.org/patch/5449291/

Question if it's an SSD and what the mount options are.



-- 
Chris Murphy
