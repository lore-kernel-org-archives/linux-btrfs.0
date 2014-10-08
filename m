Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34506 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJHFbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Oct 2014 01:31:31 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] xfstests,btrfs/004: use FILEFRAG_PROG macro
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <773629AA-9F58-4A1A-A5D0-6CC0B5121233@gmail.com>
Date: Wed, 8 Oct 2014 13:31:24 +0800
Message-Id: <F03A6FA1-97B6-41B9-B12B-26626B7B3CF2@gmail.com>
References: <1412764522-15754-1-git-send-email-wangshilong1991@gmail.com> <1412764522-15754-2-git-send-email-wangshilong1991@gmail.com> <20141008042043.GG12693@dastard> <773629AA-9F58-4A1A-A5D0-6CC0B5121233@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc list

> On Wed, Oct 08, 2014 at 06:35:22AM -0400, Wang Shilong wrote:
>>> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
>>> ---
>>> i didn't find a way to remove filefrag here, but let us
>>> use macro firstly...
>> 
>> YOu shoul dbe able to use fiemap to calculate the same output.
>> i.e. _check_file_extents() outputs a strings of the format 
>> #physical#length#logical#flags and this is then cut up later
>> later by the test. fiemap outputs the same information,
>> it just requires slightly different processing via the
>> _filter_extents function to munge it into the same format¡­
> 
> I supposed there are some differences between fiemap and filefrag:
> 
> [root@vm01 mnt]# filefrag -v data 
> Filesystem type is: 9123683e
> File size of data is 1024 (1 block of 4096 bytes)
> ext:     logical_offset:        physical_offset: length:   expected: flags:
>   0:        0..    4095:          0..      4095:   4096:             not_aligned,inline,eof
> data: 1 extent found
> 
> [root@vm01 mnt]# xfs_io -c fiemap data 
> data:
> 	0: [0..7]: 0..7
> 
> Hm¡­.
> 
> 
>> 
>> Cheers,
>> 
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
> 
> Best Regards,
> Wang Shilong
> 

Best Regards,
Wang Shilong

