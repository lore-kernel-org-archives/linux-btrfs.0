Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:39506 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbeHQQEc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 12:04:32 -0400
Received: by mail-io0-f169.google.com with SMTP id l7-v6so6817492iok.6
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Aug 2018 06:01:12 -0700 (PDT)
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
To: Roman Mamedov <rm@romanrm.net>, Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
References: <2331408.nK7QgfhVWv@merkaba>
 <5591e89c-eb89-dc48-1dc6-dc46775c7817@gmail.com> <1598008.Z1BGxZKWFL@merkaba>
 <20180817175022.70cd084e@natsu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <94de7bd8-1b35-ecbb-566a-86b5c9de06fc@gmail.com>
Date: Fri, 17 Aug 2018 09:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <20180817175022.70cd084e@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-17 08:50, Roman Mamedov wrote:
> On Fri, 17 Aug 2018 14:28:25 +0200
> Martin Steigerwald <martin@lichtvoll.de> wrote:
> 
>>> First off, keep in mind that the SSD firmware doing compression only
>>> really helps with wear-leveling.  Doing it in the filesystem will help
>>> not only with that, but will also give you more space to work with.
>>
>> While also reducing the ability of the SSD to wear-level. The more data
>> I fit on the SSD, the less it can wear-level. And the better I compress
>> that data, the less it can wear-level.
> 
> Do not consider SSD "compression" as a factor in any of your calculations or
> planning. Modern controllers do not do it anymore, the last ones that did are
> SandForce, and that's 2010 era stuff. You can check for yourself by comparing
> write speeds of compressible vs incompressible data, it should be the same. At
> most, the modern ones know to recognize a stream of binary zeroes and have a
> special case for that.
All that testing write speeds forz compressible versus incompressible 
data tells you is if the SSD is doing real-time compression of data, not 
if they are doing any compression at all..  Also, this test only works 
if you turn the write-cache on the device off.

Besides, you can't prove 100% for certain that any manufacturer who does 
not sell their controller chips isn't doing this, which means there are 
a few manufacturers that may still be doing it.
