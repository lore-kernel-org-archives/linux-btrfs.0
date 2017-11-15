Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:40167 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbdKOM5J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 07:57:09 -0500
Received: by mail-io0-f196.google.com with SMTP id 71so1457076ior.7
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 04:57:09 -0800 (PST)
Subject: Re: zstd compression
To: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
References: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
 <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de>
 <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <361d92ee-9aee-35e1-024d-45ec5b79902b@gmail.com>
Date: Wed, 15 Nov 2017 07:57:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-15 05:35, Imran Geriskovan wrote:
> On 11/15/17, Lukas Pirl <btrfs@lukas-pirl.de> wrote:
>> you might be interested in the thread "Read before you deploy
>> btrfs + zstd"¹.
> 
> Thanks. I've read it. Bootloader is not an issue since /boot is on
> another uncompressed fs.
> 
> Let me make my question more generic:
> 
> Can there be any issues for switching mount time
> compressions options from one to another, in any order?
> (i.e none -> lzo -> zlib -> zstd -> none -> ...)
> 
> zstd is only a newcomer so my question applies to all
> combinations..
The 'compress' and 'compress-force' mount options only impact newly 
written data.  The compression used is stored with the metadata for the 
extents themselves, so any existing data on the volume will be read just 
fine with whatever compression method it was written with, while new 
data will be written with the specified compression method.

If you want to convert existing files, you can use the '-c' option to 
the defrag command to do so.

Aside from this, there is one other thing to keep in mind about zstd 
which I mentioned later in the above mentioned thread.  Most system 
recovery tools do not yet have a new enough version of the kernel and/or 
  btrfs-progs to be able to access BTRFS volumes with zstd compressed 
data or metadata, so you may need to roll your own recovery solution for 
the time being if you want to use zstd.
