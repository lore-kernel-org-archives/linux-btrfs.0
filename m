Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:41338 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753653Ab3CMJ2x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 05:28:53 -0400
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id 142765FCFD
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 18:28:52 +0900 (JST)
Message-ID: <514046D4.6050104@parallels.com>
Date: Wed, 13 Mar 2013 18:28:52 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: File space cache
References: <loom.20130312T171252-0@post.gmane.org> <51400F2F.5060109@parallels.com> <20130313085309.GB2327@carfax.org.uk>
In-Reply-To: <20130313085309.GB2327@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/13/2013 05:53 PM, Hugo Mills wrote:
> On Wed, Mar 13, 2013 at 02:31:27PM +0900, dima wrote:
>> Hello Alex,
>>
>> On 03/13/2013 01:17 AM, Alex wrote:
>>> Hi All,
>>>
>>> It seems my btrfs file space cache is corrupt; I had to run clear the log
>>> through a kernel problem.
>>>
>>> I've seen messages that the cache is rebuilt automatically, but this doesn't
>>> seem to be true as the messages that the free space is what is expected keep
>>> coming.
>>>
>>> I'm running kernel 3.8.2 (Siduction) on Debian testing.
>>
>>
>> I believe you may try clear_cache mount option
>> https://btrfs.wiki.kernel.org/index.php/Mount_options
>>
>>
>>>
>>> As a subsidiary question, please, should the <pass> value in fstab be zero or
>>> non-zero?
>>
>>
>> It should be zero. But since fsck.btrfs is non-existent, it does not
>> really matter I guess.
>
>     Eh? We've had a functional btrfsck for nearly a year.


Right. But it is not something that you run on boot, is it. That is why 
I mentioned fsck.btrfs



>     Hugo.
>
