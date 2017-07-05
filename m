Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33785 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbdGELnd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jul 2017 07:43:33 -0400
Received: by mail-io0-f178.google.com with SMTP id h64so84136754iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jul 2017 04:43:33 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
To: Nick Terrell <terrelln@fb.com>, "dsterba@suse.cz" <dsterba@suse.cz>,
        E V <eliventer@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
 <20170630142133.GU2866@twin.jikos.cz>
 <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
 <15B9D85B-F8AF-44B3-B644-7E4F13A3764C@fb.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0cf10bfd-8631-7542-be31-7cc04379b0a9@gmail.com>
Date: Wed, 5 Jul 2017 07:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <15B9D85B-F8AF-44B3-B644-7E4F13A3764C@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-30 19:01, Nick Terrell wrote:
>>> If we're going to make that configurable, there are some things to
>>> consider:
>>>
>>> * the underlying compressed format -- does not change for different
>>>     levels
> 
> This is true for zlib and zstd. lzo in the kernel only supports one
> compression level.
I had actually forgot that the kernel only implements one compression 
level for LZO.
> 
>>> * the configuration interface -- mount options, defrag ioctl
>>>
>>> * backward compatibility
>> There is also the fact of deciding what to use for the default when
>> specified without a level.  This is easy for lzo and zlib, where we can
>> just use the existing level, but for zstd we would need to decide how to
>> handle a user just specifying 'zstd' without a level.  I agree with E V
>> that level 3 appears to be the turnover point, and would suggest using
>> that for the default.
> 
> I chose level 1 because I thought if we had to choose one speed/compression
> trade off, faster would be better. However, with a configerable compression
> level, level 3 is a great default, and is the default of the zstd CLI.
Actually, even if it's not configurable, I would prefer 3, as that still 
performs better in both respects (speed and compression ratio) than zlib 
while being sufficiently different from lzo performance to make it easy 
to decide on one or the other.  As far as configurable levels for 
regular usage on a filesystem, there are only three levels you 
benchmarked that I would be interested in, namely level 1 (highly active 
data on slow storage with a fast CPU), 3 (stuff I would use zlib for 
today), and 15 (stuff I would use out-of-band compression for today (for 
example, archival storage)).
> 
>>> So, I don't see any problem making the level configurable.
>> I would actually love to see this, I regularly make use of varying
>> compression both on BTRFS (with separate filesystems) and on the
>> ZFS-based NAS systems we have at work (where it can be set per-dataset)
>> to allow better compression on less frequently accessed data.
> 
> I would love to see configurable compression level as well. Would you want
> me to add it to my patch set, or should I adapt my patch set to work on top
> of it when it is ready?
David or one of the other developers would be a better person to ask, I 
mostly review kernel patches from a admin perspective, not a development 
perspective, so I don't really know which option would be better in this 
case.

