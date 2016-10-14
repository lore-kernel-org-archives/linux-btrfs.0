Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1224 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752495AbcJNBgm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 21:36:42 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: fsck-test: Add image for quota verify
 stack overflow
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161007072300.3367-1-quwenruo@cn.fujitsu.com>
 <20161007072300.3367-2-quwenruo@cn.fujitsu.com>
 <20161013142958.GX11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <834ec015-0579-b406-e58a-efe0090b8bff@cn.fujitsu.com>
Date: Fri, 14 Oct 2016 09:33:24 +0800
MIME-Version: 1.0
In-Reply-To: <20161013142958.GX11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/13/2016 10:29 PM, David Sterba wrote:
> On Fri, Oct 07, 2016 at 03:23:00PM +0800, Qu Wenruo wrote:
>> +for img in $(find . \( -iname '*.img' -o	\
>> +			-iname '*.img.xz' -o 	\
>> +			-iname '*.raw' -o 	\
>> +			-iname '*.raw.xz' \) | sort)
>> +do
>> +	image=$(extract_image $img)
>> +	run_check $TOP/btrfs check "$image"
>> +	rm -f "$image"
>> +done
>
> There's a helper that enumerates images and calls 'check_image' on each,
> so you should redefine 'check_image' if you don't want to do the default
> actions (check, repair and check). Fixed in devel.
>
>
Oh, thanks for this hint! I checked the commit in devel branch, and 
found that we could just override check_image() function.

Brilliant idea!

Thanks,
Qu


