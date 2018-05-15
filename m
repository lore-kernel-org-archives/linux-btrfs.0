Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46639 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbeEOIiY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:38:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fIVRJ-0003qy-E2
        for linux-btrfs@vger.kernel.org; Tue, 15 May 2018 10:36:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs: property: Set incompat flag of lzo/zstd
 compression
Date: Tue, 15 May 2018 08:35:57 +0000 (UTC)
Message-ID: <pan$37a76$649690$3701a6f8$971fe67@cox.net>
References: <cover.1526370458.git.misono.tomohiro@jp.fujitsu.com>
        <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
        <88f4d96f-e362-4b09-b436-30b3d1720e8a@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Su Yue posted on Tue, 15 May 2018 16:05:01 +0800 as excerpted:


> 
> On 05/15/2018 03:51 PM, Misono Tomohiro wrote:
>> Incompat flag of lzo/zstd compression should be set at:
>>  1. mount time (-o compress/compress-force)
>>  2. when defrag is done 3. when property is set
>> 
>> Currently 3. is missing and this commit adds this.
>> 
>> 
> If I don't misunderstand, compression property of an inode is only apply
> for *the* inode, not the whole filesystem.
> So the original logical should be okay.

But the inode is on the filesystem, and if it's compressed with lzo/zstd, 
the incompat flag should be set to avoid mounting with an earlier kernel 
that doesn't understand that compression and would therefore, if we're 
lucky, simply fail to read the data compressed in that file/inode.  (If 
we're unlucky it could blow up with kernel memory corruption like James 
Harvey's current case of unexpected, corrupted compressed data in a nocow 
file that being nocow, doesn't have csum validation to fail and abort the 
decompression, and shouldn't be compressed at all.)

So better to set the incompat flag and refuse to mount at all on kernels 
that don't have the required compression support.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

