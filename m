Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9574 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbbLUCXt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 21:23:49 -0500
Subject: Re: btrfs check inconsistency with raid1, part 1
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
 <566E584B.5040104@cn.fujitsu.com>
 <CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
 <566E77FA.3050405@cn.fujitsu.com>
 <CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
 <CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
 <5677592F.5000202@cn.fujitsu.com>
 <CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <567762A3.9060007@cn.fujitsu.com>
Date: Mon, 21 Dec 2015 10:23:31 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2015/12/20 19:12 -0700:
> On Sun, Dec 20, 2015 at 6:43 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Chris Murphy wrote on 2015/12/20 15:31 -0700:
>
>>> I think the cause is related to bus power with buggy USB 3 LPM
>>> firmware (these enclosures are cheap maybe $6). I've found some
>>> threads about this being a problem, but it's not expected to cause any
>>> corruptions. So, the fact Btrfs picks up one some problems might prove
>>> that (somewhat) incorrect.
>>
>>
>> Seems possible. Maybe some metadata just failed to reach disk.
>> BTW, did I asked for a btrfs-show-super output?
>
> Nope. I will attach to this email below for both devices.
>
>> If that's the case, superblock on device 2 maybe older than superblock on
>> device 1.
>
> Yes, looks iike devid 1 transid 4924, and devid 2 transid 4923. And
> it's devid 2 that had device reset and write errors when it vanished
> and reappeared as a different block device.
>

Now all the problem is explained.

You should be good to mount it rw, as RAID1 will handle all the problem.
Then you can either use scrub on dev2 to fix all the generation mismatch.

Although I prefer to wipe dev2 and mount dev1 as degraded, and replace 
the missing dev2 with a good device/usb port.

Thanks,
Qu


