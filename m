Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27615 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbcDAA2V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 20:28:21 -0400
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FDC0A2.1030909@cn.fujitsu.com>
Date: Fri, 1 Apr 2016 08:28:18 +0800
MIME-Version: 1.0
In-Reply-To: <20160331163006.GE6230@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/03/31 18:30 +0200:
> On Thu, Mar 31, 2016 at 10:19:34AM +0800, Qu Wenruo wrote:
>> At least 2 user from mail list reported btrfsck reported false alert of
>> "bad metadata [XXXX,YYYY) crossing stripe boundary".
>>
>> While the reported number are all inside the same 64K boundary.
>> After some check, all the false alert have the same bytenr feature,
>> which can be divided by stripe size (64K).
>>
>> The result seems to be initial 'max_size' can be 0, causing 'start' +
>> 'max_size' - 1, to cross the stripe boundary.
>>
>> Fix it by always update extent_record->cross_stripe when the
>> extent_record is updated, to avoid temporary false alert to be reported.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Applied, thanks.
>
> Do you have a test image for that?
>
>
Unfortunately, no.

Although I figured out the cause the the false alert, I still didn't 
find a image/method to reproduce it, except the images of reporters.

I can dig a little further trying to make a image.

Thanks,
Qu


