Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A5DC32789
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 01:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDA27204FD
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 01:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDA27204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbeKCKoY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 06:44:24 -0400
Received: from mout.gmx.net ([212.227.17.20]:59143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbeKCKoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Nov 2018 06:44:24 -0400
Received: from Damenlys-MBP.lan ([180.110.127.59]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LeALI-1fkSo31c0i-00pxWB; Sat, 03
 Nov 2018 02:34:43 +0100
Received: from Damenlys-MBP.lan ([180.110.127.59]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LeALI-1fkSo31c0i-00pxWB; Sat, 03
 Nov 2018 02:34:43 +0100
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
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <a88d9b34-6a99-ce64-4794-8e25f590f50e@gmx.com>
Date:   Sat, 3 Nov 2018 09:34:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <412fc97cf7979251b96c101c87e4ff171049a6dc.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:s6+5z8lJyyx3958fOfgbCqW3LVXwkuc+XIP6+cCUDRrhyVBi9By
 SBvSasVuVS7xUmLsCJwCjJRXDaG2bUdrk/vuvHlDOLQid+CEC+KVdouRtSGCPov5nAwxFjK
 0TepNtyJ3N07dSLJW3Cz0oZnrdrSjTB9j9AD78rx/go48GiHl5U+ql0A1uJwJdrlifAkte5
 G3gwzHgHV1LxUlF7FnMBg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:2s8QyJRhzDk=:wpMUBgKT5y6+CfADjiIalV
 LdKHqTb8yUnPsJfU9u5VXPi6U4Te+LmQVTVdMjg7xy0k7hgsnkdlseStJhXcPkx58nUMmoUxo
 f7Q7AnuroOiej7a8/hM7iN4ZcJzOdySRyWSshCzx7XpHDBf/Gh3gtVHwUd8rVR691bCSgKxsS
 UzOA4oBbE6qphGwXT+ii8VXkEEuKdYYPOCZ/RdodGZ9VwoZZU2sLla3fv499bWbmo/s79B+Z6
 YS8rfz5wDNVVi2eS3vtdG0SvHdDREPFKbx0LKLIukd51SrckyWMTx2HTNzfUOoUOWo4pURZy3
 8bB5kVGd4JELPt58edJzCakzcdIMHw3Fws94K9F/W884geGa6V5NynzwwYL0PbUyvvPK/L6lR
 GgzdBkJN9KMaZw9JLkBM+52AX9B5x4Iqy4ySRva3vHMYh7yIw5ywZydjMeRY0MJOxSimGnxco
 7e4vvmxXlkLn9nIhn/KOnybWMl8aHIbhhVoqy+aphyMpAmyPlFPvg/jwlQU8WuQCHX3zY1MZ1
 ssAqksJAZeH48BfYgV5zeDmJwzcKLRP4/jTkeaAPXTtelv+TwcrwxmMvUyfp3rvEh9a+xIXBO
 +BlK6kJBfBkmAIUlBmrpaWTYgTFejiMSXVY5u6oLUP15vuzvM3HGFtI2+HMi9+cxdAumAe0Ow
 L6EvDCIc82Kvhj4E42Jt+bHnxOujQBc5jLc4LNF4zjeT9hgyjqWNOpN5dotHGtXpSYbbWtoQg
 WYJ6pNra3E7tCcJCeLedKBNCAvkVK6xL+wlaXYQ5AHMhvCya51EEKu1oxwGnps2AKE9bDMxax
 9+7Zmonl1vYvr+UEo5zavCMx/YNb2PZwaPlHH28Ka1W5JFhNcsekhtjkIMOniN2krIwqiQ37X
 2VWl3PW7XuCn7aGWQdYztXxPL+RUU0Fx1bZC1ZAzX9nud97QtrD96tSlnzqfE2
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/2 10:10 PM, Christoph Anton Mitterer wrote:
> Hey Su.
> 

Sorry for the late reply cause I'm busy at other things.

> Anything further I need to do in this matter or can I consider it
> "solved" and you won't need further testing by my side, but just PR the
> patches of that branch? :-)
> 

I just looked through related codes and found the bug.
The patches can fix it. So no need to do more tests.
Thanks to your tests and patience. :)


In previous output of debug version, we can see @ret code
is 524296 which is (DIR_ITEM_MISMATCH(1 << 3) | DIR_INDEX_MISMATCH (1<<19)).

In btrfs-progs v4.17,
function check_inode_extref() passes u64 @mode as the last parameter
of find_dir_item();
However, find_dir_item() is defined as:
static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
                          struct btrfs_key *location_key, char *name,
                          u32 namelen, u8 file_type);

The type of the last argument is u8 not u64.

So the case is that while checking files with inode_extrefs,
if (imode != file_type), then find_dir_item() thinks it found
DIR_ITEM_MISMATCH or DIR_INDEX_MISMATCH.

Thanks,
Su

> Thanks,
> Chris.
> 
> On Sat, 2018-10-27 at 14:15 +0200, Christoph Anton Mitterer wrote:
>> Hey.
>>
>>
>> Without the last patches on 4.17:
>>
>> checking extents
>> checking free space cache
>> checking fs roots
>> ERROR: errors found in fs roots
>> Checking filesystem on /dev/mapper/system
>> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
>> found 619543498752 bytes used, error(s) found
>> total csum bytes: 602382204
>> total tree bytes: 2534309888
>> total fs tree bytes: 1652097024
>> total extent tree bytes: 160432128
>> btree space waste bytes: 459291608
>> file data blocks allocated: 7334036647936
>>   referenced 730839187456
>>
>>
>> With the last patches, on 4.17:
>>
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking only csum items (without verifying data)
>> checking root refs
>> Checking filesystem on /dev/mapper/system
>> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
>> found 619543498752 bytes used, no error found
>> total csum bytes: 602382204
>> total tree bytes: 2534309888
>> total fs tree bytes: 1652097024
>> total extent tree bytes: 160432128
>> btree space waste bytes: 459291608
>> file data blocks allocated: 7334036647936
>>   referenced 730839187456
>>
>>
>> Cheers,
>> Chris.
>>
> 
