Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9614 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbbFRFlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 01:41:09 -0400
Subject: Re: Automatic balance after mkfs?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
References: <pan.2015.06.16.13.13.40@googlemail.com>
 <558022E8.7070201@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <558259F3.8060505@cn.fujitsu.com>
Date: Thu, 18 Jun 2015 13:41:07 +0800
MIME-Version: 1.0
In-Reply-To: <558022E8.7070201@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S Hemmelgarn wrote on 2015/06/16 09:21 -0400:
> On 2015-06-16 09:13, Holger Hoffstätte wrote:
>>
>> Forking from the other thread..
>>
>> On Tue, 16 Jun 2015 12:25:45 +0000, Hugo Mills wrote:
>>
>>>     Yes. It's an artefact of the way that mkfs works. If you run a
>>> balance on those chunks, they'll go away. (btrfs balance start
>>> -dusage=0 -musage=0 /mountpoint)
>>
>> Since I had to explain this very same thing to a new btrfs-using friend
>> just yesterday I wondered if it might not make sense for mkfs to issue
>> a general balance after creating the fs? It should be simple enough
>> (just issue the balance ioctl?) and not have any negative side effects.
>>
>> Just doing such a post-mkfs cleanup automatically would certainly
>> reduce the number of times we have to explain the this. :)
>>
>> Any reasons why we couldn't/shouldn't do this?
>>
> Following the same line of thinking, is there any reason we couldn't
> just rewrite mkfs to get rid of this legacy behavior?
>
>
Compared to the more complex auto balance, rewrite mkfs is a much better 
idea.

The original mkfs seems easy for developers, but bad for users.

I like the idea and I'll try to implment it if I have spare time.

Thanks.
Qu
