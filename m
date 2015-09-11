Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6416 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbbIKAu3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 20:50:29 -0400
Subject: Re: [PATCH RFC 00/14] Accurate qgroup reserve framework
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <55EEA58A.8050503@cn.fujitsu.com> <20150910233444.GK9511@ret.masoncoding.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F22553.6050303@cn.fujitsu.com>
Date: Fri, 11 Sep 2015 08:50:27 +0800
MIME-Version: 1.0
In-Reply-To: <20150910233444.GK9511@ret.masoncoding.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2015/09/10 19:34 -0400:
> On Tue, Sep 08, 2015 at 05:08:26PM +0800, Qu Wenruo wrote:
>> Sorry for the confusing cover letter title.
>>
>> This patch is no longer RFC now.
>> It's already a working one, and we're doing stress test to ensure it's
>> completely OK, but seems quite good for now.
>>
>> To Chris,
>>
>> I know the timing I sent the patchset is quite awful, as there is only less
>> than 1 week for rc1, and the merge window will close soon.
>>
>> But I still hope there would be a small chance we can merge it into early
>> v4.3-rc. Maybe rc2 or rc3?
>> As the reserve space leaking problem is quite annoying, sometimes even
>> making qgroup limit unusable.
>
> Sorry, this is much too big for rc2 or rc3.

Completely acceptable, as I also consider it's too big anyway.

>
>>
>> If that's not possible, I'm completely OK with that though, as Linus won't
>> be happy about that without doubt.
>
> Lets use the rest of the 4.3 cycle to get reviews (esp from Mark) and
> work through any problems.  I'd really like to focus on this and the
> subvol deletion accounting

Makes a lot of sense.

BTW, we were originally to submit another qgroup enhancement for 4.4 cycle.
(The one originally submitted by Yang Dongsheng, seperate btrfs qgroup 
accounting for data and metadata)

Will it be OK to submit them at the same time for 4.4?
Or better to postpone it for 4.5?
(40+ patches will surely be quite a hell to merge)

Thanks,
Qu

>
> -chris
>
