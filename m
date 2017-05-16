Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35499 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdEPMgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 08:36:00 -0400
Received: by mail-it0-f50.google.com with SMTP id c15so60953713ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 05:36:00 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
 <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
 <20170512203644.26e068e5@jupiter.sol.kaishome.de>
 <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
 <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
 <20170515200505.GB5285@mother.pipebreaker.pl>
 <20170516035841.310cd1e7@jupiter.sol.kaishome.de>
 <20170516122120.GC5285@mother.pipebreaker.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3646af85-cd39-7882-b9b2-921b31f5481c@gmail.com>
Date: Tue, 16 May 2017 08:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <20170516122120.GC5285@mother.pipebreaker.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-16 08:21, Tomasz Torcz wrote:
> On Tue, May 16, 2017 at 03:58:41AM +0200, Kai Krakow wrote:
>> Am Mon, 15 May 2017 22:05:05 +0200
>> schrieb Tomasz Torcz <tomek@pipebreaker.pl>:
>>> My
>>> drive has  # smartctl -a /dev/sda  | grep LBA 241
>>> Total_LBAs_Written      0x0032   099   099   000    Old_age
>>> Always       -       136025596053
>>
>> Doesn't say this "99%" remaining? The threshold is far from being
>> reached...
>>
>> I'm curious, what is Wear_Leveling_Count reporting?
>
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   9 Power_On_Hours          0x0032   096   096   000    Old_age   Always       -       18227
>  12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       29
> 177 Wear_Leveling_Count     0x0013   001   001   000    Pre-fail  Always       -       4916
>
>  Is this 001 mean 1%? If so, SMART contradicts datasheets. And I
> don't think I shoud see read errors for 1% wear.
The 'normalized' values shown in the VALUE, WORST, and THRESH columns 
usually count down to zero (with the notable exception of the thermal 
attributes, which usually match the raw value), they exist as a way of 
comparing things without having to know what vendor or model the device 
is, as the raw values are (again with limited exceptions) technically 
vendor specific (the various *_Error_Rate counters on traditional HDD's 
are good examples of this).  VALUE is your current value, WORST is a 
peak-detector type thing that monitors the worst it's been, and THRESH 
is the point at which the device manufacturer considers that aspect 
failed (which will usually result in the 'Overall Health Assessment' 
failing as well), though I'm pretty sure that if THRESH is 000, that 
means that the firmware doesn't base it's asse3ssment for that attribute 
on the normalized value at all.
