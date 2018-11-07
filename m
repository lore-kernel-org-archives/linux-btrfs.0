Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BA0C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 07:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE23120827
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 07:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE23120827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbeKGQd2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 11:33:28 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10056 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727043AbeKGQd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 11:33:28 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47482174"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 07 Nov 2018 15:04:20 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id AED3F4B71EA0;
        Wed,  7 Nov 2018 15:04:19 +0800 (CST)
Received: from [10.167.226.33] (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 7 Nov 2018 15:04:19 +0800
Subject: Re: [PATCH 11/13] btrfs-progs: check: Delete file extent item with
 unaligned extent backref
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-12-suy.fnst@cn.fujitsu.com>
 <18e31f91-74ef-1416-8b87-32a108700269@gmx.com>
 <24a149df-1b5d-8c9d-2f4d-37e2338a6c8a@cn.fujitsu.com>
 <e2113bf4-b888-2d6f-0a7b-f0c734d63172@gmx.com>
From:   "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>
Message-ID: <05530906-9f07-0f36-baa5-ccbef423c632@cn.fujitsu.com>
Date:   Wed, 7 Nov 2018 15:04:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <e2113bf4-b888-2d6f-0a7b-f0c734d63172@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: AED3F4B71EA0.ABE49
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/7/2018 2:38 PM, Qu Wenruo wrote:
>
> On 2018/11/7 下午2:21, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
>>
>> On 10/24/2018 8:45 AM, Qu Wenruo wrote:
>>> On 2018/10/23 下午5:41, Su Yue wrote:
>>>> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>>>
>>>> In original mode, if some file extent item has unaligned extent backref,
>>>> fixup_extent_refs can't repair it. This patch will check extent
>>>> alignment
>>>> then delete file extent with unaligned extent backref.
>>> This looks a little strange to me.
>>>
>>> You mean, an unaligned FILE EXTENT has an unaligned EXTENT_ITEM?
>>>
>>> Then why not just delete the EXTENT_ITEM directly? No need to go back
>>> checking if it has a corresponding EXTENT_DATA since unaligned one is
>>> definitely corrupted.
>>>
>>> For corrupted EXTENT_DATA, it should get deleted when we check fs tree.
>>>
>>> This would save you a lot of codes.
>>>
>>> Thanks,
>>> Qu
>> The situation is that the file extent has wrong extent backref, actually
>> it doesn't exist.
> Did you mean extent EXTENT_ITEM key's objectid is unaligned?
>
> Would you please give an example on this case? Like:
> (<ino> EXTENT_DATA <offset>
>     disk bytenr <XXXX> disk len <YYYY>
>
> And its backref like:
> (<XXXX> EXTENT_ITEM <YYYY>)
>
> And then mark where the number is incorrect.
>
> Thanks,
> Qu

As in /btrfs-progs/tests/fsck-tests/001-bad-file-extent-bytenr case:

item 7 key (257 EXTENT_DATA 0) itemoff 3453 itemsize 53

                 generation 6 type 1 (regular)

                 extent data disk byte 755944791 nr 1048576
                                 ^^^^^^^^^

                 extent data offset 0 nr 1048576 ram 1048576

                 extent compression 0 (none)

Thanks,

Su

>> Thanks,
>> Su
>>
>>
>>
>>
>>
>



