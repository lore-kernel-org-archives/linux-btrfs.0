Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2251C6786F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 09:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948B02081F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 09:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 948B02081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbeKCSbd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 14:31:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:45716 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbeKCSbc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Nov 2018 14:31:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 771A1AE15;
        Sat,  3 Nov 2018 09:20:49 +0000 (UTC)
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
To:     Christoph Anton Mitterer <calestyo@scientia.net>,
        Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
 <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
 <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
 <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
 <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
 <04ccd53107bb11e08baaa8c1ec55b11b00133d3b.camel@scientia.net>
 <412fc97cf7979251b96c101c87e4ff171049a6dc.camel@scientia.net>
 <a88d9b34-6a99-ce64-4794-8e25f590f50e@gmx.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <df428289-aac7-5bf8-b0d8-d6cf1d399a38@suse.com>
Date:   Sat, 3 Nov 2018 11:20:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <a88d9b34-6a99-ce64-4794-8e25f590f50e@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.11.18 г. 3:34 ч., Su Yue wrote:
> 
> 
> On 2018/11/2 10:10 PM, Christoph Anton Mitterer wrote:
>> Hey Su.
>>
> 
> Sorry for the late reply cause I'm busy at other things.
> 
>> Anything further I need to do in this matter or can I consider it
>> "solved" and you won't need further testing by my side, but just PR the
>> patches of that branch? :-)
>>
> 
> I just looked through related codes and found the bug.
> The patches can fix it. So no need to do more tests.
> Thanks to your tests and patience. :)
> 
> 
> In previous output of debug version, we can see @ret code
> is 524296 which is (DIR_ITEM_MISMATCH(1 << 3) | DIR_INDEX_MISMATCH
> (1<<19)).
> 
> In btrfs-progs v4.17,
> function check_inode_extref() passes u64 @mode as the last parameter
> of find_dir_item();
> However, find_dir_item() is defined as:
> static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
>                          struct btrfs_key *location_key, char *name,
>                          u32 namelen, u8 file_type);
> 
> The type of the last argument is u8 not u64.

So this would have been caught by gcc's -Wconversion, except it likely
wouldn't have been because right now this option produces loads of false
positives... Too bad...

> 
> So the case is that while checking files with inode_extrefs,
> if (imode != file_type), then find_dir_item() thinks it found
> DIR_ITEM_MISMATCH or DIR_INDEX_MISMATCH.
> 
> Thanks,
> Su
> 
>> Thanks,
>> Chris.
>>
>> On Sat, 2018-10-27 at 14:15 +0200, Christoph Anton Mitterer wrote:
>>> Hey.
>>>
>>>
>>> Without the last patches on 4.17:
>>>
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> ERROR: errors found in fs roots
>>> Checking filesystem on /dev/mapper/system
>>> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
>>> found 619543498752 bytes used, error(s) found
>>> total csum bytes: 602382204
>>> total tree bytes: 2534309888
>>> total fs tree bytes: 1652097024
>>> total extent tree bytes: 160432128
>>> btree space waste bytes: 459291608
>>> file data blocks allocated: 7334036647936
>>>   referenced 730839187456
>>>
>>>
>>> With the last patches, on 4.17:
>>>
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> checking only csum items (without verifying data)
>>> checking root refs
>>> Checking filesystem on /dev/mapper/system
>>> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
>>> found 619543498752 bytes used, no error found
>>> total csum bytes: 602382204
>>> total tree bytes: 2534309888
>>> total fs tree bytes: 1652097024
>>> total extent tree bytes: 160432128
>>> btree space waste bytes: 459291608
>>> file data blocks allocated: 7334036647936
>>>   referenced 730839187456
>>>
>>>
>>> Cheers,
>>> Chris.
>>>
>>
