Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36694 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753130AbdF3XBU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 19:01:20 -0400
From: Nick Terrell <terrelln@fb.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>, E V <eliventer@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Date: Fri, 30 Jun 2017 23:01:08 +0000
Message-ID: <15B9D85B-F8AF-44B3-B644-7E4F13A3764C@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
 <20170630142133.GU2866@twin.jikos.cz>
 <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
In-Reply-To: <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> If we're going to make that configurable, there are some things to
>> consider:
>> 
>> * the underlying compressed format -- does not change for different
>>    levels

This is true for zlib and zstd. lzo in the kernel only supports one
compression level.

>> * the configuration interface -- mount options, defrag ioctl
>> 
>> * backward compatibility
> There is also the fact of deciding what to use for the default when 
> specified without a level.  This is easy for lzo and zlib, where we can 
> just use the existing level, but for zstd we would need to decide how to 
> handle a user just specifying 'zstd' without a level.  I agree with E V 
> that level 3 appears to be the turnover point, and would suggest using 
> that for the default.

I chose level 1 because I thought if we had to choose one speed/compression
trade off, faster would be better. However, with a configerable compression
level, level 3 is a great default, and is the default of the zstd CLI.

>> So, I don't see any problem making the level configurable.
> I would actually love to see this, I regularly make use of varying 
> compression both on BTRFS (with separate filesystems) and on the 
> ZFS-based NAS systems we have at work (where it can be set per-dataset) 
> to allow better compression on less frequently accessed data.

I would love to see configurable compression level as well. Would you want
me to add it to my patch set, or should I adapt my patch set to work on top
of it when it is ready?
    

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
