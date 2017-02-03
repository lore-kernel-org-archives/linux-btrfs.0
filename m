Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752230AbdBCGUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 01:20:53 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <christoph.anton.mitterer@lmu.de>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
 <1485276845.12065.1.camel@scientia.net>
 <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
 <1485305208.12065.9.camel@scientia.net>
 <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
 <1485399036.23328.7.camel@scientia.net>
 <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
 <1485473476.7613.12.camel@lmu.de>
 <7125b67b-1b7e-c191-290d-cf60e63ee93e@gmx.com>
 <1485745624.6333.1.camel@lmu.de>
 <0715efbc-44cd-5f84-9870-938dd80b7ae3@cn.fujitsu.com>
 <1485986636.6573.13.camel@lmu.de>
 <3c464199-27df-1a81-f309-8491c368ff13@cn.fujitsu.com>
 <97d42767-4ae4-a97e-2625-5028300fff67@cn.fujitsu.com>
 <1486098502.7443.3.camel@lmu.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <06e4296b-4512-1669-5bff-834d130ce701@cn.fujitsu.com>
Date: Fri, 3 Feb 2017 14:20:39 +0800
MIME-Version: 1.0
In-Reply-To: <1486098502.7443.3.camel@lmu.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/03/2017 01:08 PM, Christoph Anton Mitterer wrote:
> Hey Qu.
>
> I'm sending this off-list for privacy reasons of the contained file-
> names / hash sums.
> It doesn't contained anything particularly secret, nevertheless, please
>  try to avoid spreading it too far around and delete it once you don't
> need it anymore :)
>
> On Thu, 2017-02-02 at 10:12 +0800, Qu Wenruo wrote:
>> Would you please to check the latest lowmem_tests branch?
>> https://github.com/adam900710/btrfs-progs/tree/lowmem_tests
>
> Invocation was as usual:
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
>
> stdout/err output in the attachment

Great thanks for that!

Although I made a mistake in the debug patch, the output info is still 
good enough for me to catch the bug in inline extent check.

I also added missing error message output for other places I found, and 
updated the branch, the name remains as "lowmem_tests"

Please try it.

Thanks,
Qu

>
>
>> Sorry for the extra trouble.
> No worries :)
>
>
> Cheers,
> Chris.
>


