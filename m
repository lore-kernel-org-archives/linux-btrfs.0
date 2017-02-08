Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35248 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbdBHTIJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 14:08:09 -0500
Received: by mail-io0-f177.google.com with SMTP id j18so123606909ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 11:06:18 -0800 (PST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
 <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
 <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
 <20170201115530.l2ce5afcqld2kzi4@angband.pl>
 <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
 <7cb699fd-44a7-d8eb-e492-c448f67b0eac@gmail.com>
 <20170202142521.nfiy73ye6bi5smjv@angband.pl>
 <ZIyPcL4cW36fIZIyQcB9Hs@videotron.ca>
 <6e26ee22-3d67-d2aa-22b7-c03f9ffc18f2@deragon.biz>
 <6e4b9b4f-d4df-5679-5645-a52dbc15b424@gmail.com>
 <20170208134647.GA86702@mother.pipebreaker.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0565ffd4-dd9b-cf56-61fe-8da887f99848@gmail.com>
Date: Wed, 8 Feb 2017 14:06:07 -0500
MIME-Version: 1.0
In-Reply-To: <20170208134647.GA86702@mother.pipebreaker.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-08 08:46, Tomasz Torcz wrote:
> On Wed, Feb 08, 2017 at 07:50:22AM -0500, Austin S. Hemmelgarn wrote:
>>  It is exponentially safer in BTRFS
>> to run single data single metadata than half raid1 data half raid1 metadata.
>
>   Why?
>
>> To convert to profiles _designed_ for a single device and then convert back
>> to raid1 when I got another disk.  The issue you've stumbled across is only
>> partial motivation for this, the bigger motivation is that running half a 2
>> disk array is more risky than running a single disk by itself.
>
>   Again, why?  What's the difference?  What causes increased risk?
Aside from bugs like the one that sparked this thread that is?  Just off 
the top of my head:
* You're running with half a System chunk.  This is _very_ risky because 
almost any errors in the system chunk run the risk of nuking entire 
files and possibly the whole filesystem.  This is part of the reason 
that I explicitly listed -mconvert=dup instead of -mconvert=single.
* It performs significantly better.  As odd as this sounds, this 
actually has an impact on safety.  Better overall performance reduces 
the size of the windows of time during which part of the filesystem is 
committed.  This has less impact than running a traditional filesystem 
on top of a traditional RAID array, but it still has some impact.
* Single device is exponentially more well tested than running a 
degraded multi-device array.  IOW, you're less likely to hit obscure 
bugs by running a single profile instead of half a raid1 profile.
