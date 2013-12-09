Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab3LIMZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 07:25:00 -0500
Message-ID: <52A5B645.2060100@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 20:23:33 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, vikigoyal@gmail.com
Subject: Re: scub neither running nor canceling nor can be restarted.
References: <20131209095133.GA6579@mail2.smcindiaonline.com> <52A59EF7.8050007@cn.fujitsu.com> <20131209121856.GA18083@mail2.smcindiaonline.com>
In-Reply-To: <20131209121856.GA18083@mail2.smcindiaonline.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2013 08:18 PM, Vikram Goyal wrote:
> On Mon, Dec 09, 2013 at 06:44:07PM +0800, Wang Shilong wrote:
>> Hello Vikram,
>>
>> On 12/09/2013 05:51 PM, Vikram Goyal wrote:
>>> Hello,
>>>
>>> I am having a problem where a stuck scrub on root FS cannot be
>>> cancelled or restsrted.
>>>
> <snip>
>>> To cancel use 'btrfs scrub cancel /'.
>>> To see the status use 'btrfs scrub status [-d] /'.
>> I came the same issue before and i sent a patch for this:
>> https://patchwork.kernel.org/patch/3264051/
>>
>> This patch has been merged into David's integration branch.
>> You can pull from:
>>
>> https://github.com/kdave/btrfs-progs.git integration-20131206
>>
>> you can use:
>> # btrfs scrub start -f /
>>
>> This should help, -f will force us to skip check in userspace.
>>
>> Thanks,
>> Wang
> Hello Wang,
>
> I am on Fedora 19. I just checked, I don't have -f as option in
> btrfs-progs. The installed version is:
>
> btrfs-progs.x86_64                  3.12-1.fc18         @updates
>
> current kernel is 3.11.9-100.fc18.x86_64
>
> I just wanted to know if its not dangerous to have this state of FS
> since I will wait for the update to come from the repo rather than build
> package myself
I think one way to slove this problms is:

# rm -f  /var/lib/btrfs/*

This will remove scrub status record file, and then you can start scrub 
again.

Thanks,
Wang
>
> Thanks!

