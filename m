Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44568 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbaJGBBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 21:01:18 -0400
Message-ID: <54333B55.2010304@cn.fujitsu.com>
Date: Tue, 7 Oct 2014 09:01:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>,
        <guaneryu@gmail.com>
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options internally
 to avoid losing security label.
References: <54320637.4030506@cn.fujitsu.com> <1412601999.31886.2@mail.thefacebook.com>
In-Reply-To: <1412601999.31886.2@mail.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options 
internally to avoid losing security label.
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年10月06日 21:26
> On Sun, Oct 5, 2014 at 11:02 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
> wrote:
>>
>>>
>>> I don't think that my "wish" should disallow your patch.
>>>
>>> For the problem I was looking at, I think the only way forward would 
>>> require
>>> some significant selinux modification, and treating a subvol root 
>>> essentially
>>> like a superblock.
>>>
>>> So ... don't let me slow you down, at least for now.  ;)
>>>
>>> -Eric
>>>
>> To Chris, any other comment?
>
> It looks good to me, and I have it queued up here in testing.
>
> -chris
>
>
>
Thanks a lot.

Qu
