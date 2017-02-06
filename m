Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6744 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751710AbdBFBZb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 20:25:31 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <calestyo@scientia.net>,
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
 <06e4296b-4512-1669-5bff-834d130ce701@cn.fujitsu.com>
 <1486162890.6884.4.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5569b391-3025-289b-72a7-adbc648d9d31@cn.fujitsu.com>
Date: Mon, 6 Feb 2017 09:25:18 +0800
MIME-Version: 1.0
In-Reply-To: <1486162890.6884.4.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/04/2017 07:01 AM, Christoph Anton Mitterer wrote:
> Hey Qu
>
> On Fri, 2017-02-03 at 14:20 +0800, Qu Wenruo wrote:
>> Great thanks for that!
> You're welcome. :)
>
>
>> I also added missing error message output for other places I found,
>> and
>> updated the branch, the name remains as "lowmem_tests"
>>
>> Please try it.
> # btrfs check /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7519512838144 bytes used, no error found
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 0
>
> # btrfs check /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7519512838144 bytes used, no error found
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 0
>
> => looks good this time :)

Great!

>
>
> btw: In your commit messages, please change my email to
> calestyo@scientia.net everywhere... I accidentally used my university
> address (christoph.anton.mitterer@lmu.de) sometimes when sending mail.

Not a problem.

I'll change the address and re-send the patchset to mail list.

Thanks,
Qu

>
> Cheers,
> Chris.
>


