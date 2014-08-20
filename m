Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60753 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbaHTCez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 22:34:55 -0400
Message-ID: <53F4094D.2060606@cn.fujitsu.com>
Date: Wed, 20 Aug 2014 10:34:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum mismatches
 even generation is less than 10.
References: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com> <53E2E9A3.6060206@cn.fujitsu.com> <53F3A9F7.9070709@fb.com>
In-Reply-To: <53F3A9F7.9070709@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum 
mismatches even generation is less than 10.
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: 2014年08月20日 03:48
> On 08/06/2014 10:51 PM, Qu Wenruo wrote:
>> It seems that the patch is rejected in patchwork,
>>
>> Could any one tell me the reason?
> I had nack'd it because I was worried at the time about the super crc
> errors that Dave had found in the past.  Sorry, I really thought I had
> sent email about it.
>
> But Dave has a great point in his reply about validating the super
> generation.
Thanks for the reason.
I'll search and look at Dave's mail and dig into it.

Although as mentioned in the reply to David,
the main problem is that I found two disk images with crazy values in 
superblock and wrong csum,
but generation is still 4, and ignoring the csum error caused kernel BUG.

Thanks,
Qu

>
> -chris

