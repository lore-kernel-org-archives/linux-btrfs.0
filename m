Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5A2C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 07:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5D572082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 07:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbfAPHL0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 02:11:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:43988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727247AbfAPHL0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 02:11:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16512AD86;
        Wed, 16 Jan 2019 07:11:25 +0000 (UTC)
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
 <2dba4f49-2be5-694b-2676-0fa75a250e2d@googlemail.com>
 <45de3cc0-b8b5-9e33-fbba-d02505583d2b@googlemail.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <45b6077b-11d2-2db9-ddc5-85743507ba4d@suse.com>
Date:   Wed, 16 Jan 2019 09:11:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <45de3cc0-b8b5-9e33-fbba-d02505583d2b@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 16.01.19 г. 0:24 ч., Oliver Freyermuth wrote:
> Am 14.01.19 um 01:48 schrieb Oliver Freyermuth:
>> Am 13.01.19 um 22:51 schrieb Oliver Freyermuth:
>>> I just upgraded to 4.20.1 from 4.19 (not sure if related) and my btrfs backup volume entered read-only mode when running btrfs-cleaner,
>>> i.e. when purging old subvolumes. 
>>>
>>> I have attached the kernel log from when this happens. 
>>>
>>> What is the best way to proceed from here? Running "btrfs check repair" on the device? 
>>> Worst case it's not a huge issue to lose the data stored there, it's my backup volume after all. 
>>> But it would be good to understand the cause and know if there is a better fix than starting from scratch. 
>> attached is the output of "btrfs check -p /dev/sdc2". 
>> I can't guarantee the volume has never been cleanly unmounted. 
>>
>> I found several past occasions of this here:
>> https://www.spinics.net/lists/linux-btrfs/msg69040.html
>> and here:
>> https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing
>> but without conclusive result. 
>>
>> Please let me know what's the best way to proceed. From these links, it seems
>> btrfs check --repair
>> _should_ help, but I would prefer to get some advice first whether this is really the best approach. 
>>
> 
> Dear BTRFS experts,
> 
> I have now salvaged all my backup subvolumes with btrfs send (using btrbk archive) to a new btrfs partition. 
> Interestingly, when the old partition was mounted r/w initially and remounted r/o after the described issue was triggered by btrfs-cleaner:
> 
> [34758.491644] BTRFS: error (device sdc2) in __btrfs_free_extent:6828: errno=-2 No such entry                                                                                                                                               
> [34758.491647] BTRFS info (device sdc2): forced readonly                                                                                                                                                                                     
> [34758.491652] BTRFS: error (device sdc2) in btrfs_run_delayed_refs:2978: errno=-2 No such entry 
> 

You are likely hitting a known issue, you need to apply:

btrfs: run delayed items before dropping the snapshot, currently this
patch is part of 5.0 but it has also been marked for stable so should
land in some of the stable kernels. So you have 2 options:

1. Backport the patch to the kernel you desire
2. Wait until the patch lands in a stable release.

> btrfs send appeared to fail on some subvolumes with:
> 
> [41822.676040] BTRFS error (device sdc2): parent transid verify failed on 52633681920 wanted 88063 found 87999                                                                                                                               
> [41822.676260] BTRFS error (device sdc2): parent transid verify failed on 52633681920 wanted 88063 found 87999                                                                                                                               
> [41822.676266] BTRFS info (device sdc2): no csum found for inode 22175978 start 0                                                                                                                                                           
> [41822.683112] BTRFS warning (device sdc2): csum failed root 25758 ino 22175978 off 4427459514368 csum 0x5d3b8d26 expected csum 0x00000000 mirror 1 
> 
> Unmounting and remounting the broken file system r/o, all visible subvolumes could be transferred without that issue. 
> I presume that there's also a bug when the automatic remount as r/o happens since csum 0x00000000 does not look correct. 
> 
> Since there's now nothing to lose and I received no other advice up to now, I'm running "btrfs check --repair" now just for the sake of learning
> whether this appears to fix it. I'll shortly report back when that's done. 

--repair won't fix the problem, also it's possible it *could* make
things worse.

> 
> If anybody can suggest a better solution in case this happens again (the issue appears to be wide-spread) I would be happy to learn. 
> 
> Cheers,
> 	Oliver
> 
