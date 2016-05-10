Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22384 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115AbcEJCEo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 22:04:44 -0400
Subject: Re: Idea on compatibility for old distributions
To: Mark Fasheh <mfasheh@suse.de>
References: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
 <20160510015211.GC7633@wotan.suse.de>
CC: David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <32aae76c-89cc-bda3-3d80-b2757c646ef9@cn.fujitsu.com>
Date: Tue, 10 May 2016 10:04:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160510015211.GC7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/05/09 18:52 -0700:
> On Tue, May 10, 2016 at 09:16:04AM +0800, Qu Wenruo wrote:
>> In the recent test for new btrfs-convert backward compatibility, I
>> found that cmds-fi-du.c uses FIEMAP_EXTENT_SHARED bits, which is not
>> present in kernel of old distributions like RHEL6 (Sorry, didn't
>> test on openSUSE equivalent).
>>
>> Unlike e2fsprogs, we can check its version with pkgconfig, any idea
>> to avoid such compiling error?
>
> #ifndef FIEMAP_EXTENT_SHARED
> #define FIEMAP_EXTENT_SHARED           0x00002000
> #endif
>
> This is what I do in duperemove. Many distributions dind't update their
> kernel header packages for that bit so even though it's in the kernel
> userspace programs using it won't compile.

Oh, I just forgot such easy fix. :)
>
>
>> And further more, without kernel support for FIEMAP_EXTENT_SHARED,
>> will fi-du work anymore?
>
> RHEL6 says they're using 2.6.32 which is just before the introduction of
> SHARED. It couild be that they have it though considering there is an
> immense number of backports done for distro kernels. I would honestly check
> the source. What we're really looking to see is what version of btrfs they
> have.
>
> With the above patch we would compile and run everywhere. If someone runs an
> obsolete version of btrfs then fi du won't report any shared extents. This
> is unfortunate but so is running btrfs from 2.6.32.
> 	--Mark

As long as compile passes, it's completely acceptable.

Hopes the patch will be sent out soon.

Thanks,
Qu
>
> --
> Mark Fasheh
>
>


