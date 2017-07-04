Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45165 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751645AbdGDNQo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jul 2017 09:16:44 -0400
Date: Tue, 4 Jul 2017 21:16:36 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Filippe LeMarchand <gasinvein@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Btrfs check reports errors, filesystem seems fine
Message-ID: <20170704131636.GC2114@fnst>
References: <2049018.boNrIqZ5uI@carbide>
 <83ad37c7-7c86-1c8f-e575-78ebbc1749b9@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <83ad37c7-7c86-1c8f-e575-78ebbc1749b9@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 03, 2017 at 08:34:52AM +0800, Qu Wenruo wrote:
>
>
>At 07/01/2017 07:59 PM, Filippe LeMarchand wrote:
>> Hello everyone.
>> 
>> I have an btrfs root partition on Intel 530 ssd, which mounts without errors and seem to work fine,
>> but `btrfs check` gives me foloowing output (and --repair doesn't remove errors):
>> 
>> enabling repair mode
>> Checking filesystem on /dev/sda2
>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
>> checking extents
>> Fixed 0 roots.
>> checking free space cache
>> cache and super generation don't match, space cache will be invalidated
>> checking fs roots
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>
>This means that in dir whose inode number is 79177, it has a child inode
>pointer pointing to depercated.sxt.
>
>But it doesn't have dir index and corresponding inode ref, which is breaking
>the cross reference rule of btrfs.
>
>Would you please run the following command to dump needed info for us to
>debug?
>
># btrfs-debug-tree /dev/sda2 | grep 79177 -C 10
>
>and
>
># btrfs-debug-tree /dev/sda2 | grep deprecated.sxt -C 10
>
>and
>
># btrfs-debug-tree /dev/sda2 | grep deprecated.txt -C 10
>
>
>Considering the output has both .txt and .sxt, I think that's the problem.
>But such bit-flip should be detected by tree block csum.
>I'm not sure what's wrong with it.
>
>Thanks,
>Qu
>
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>> checking csums
>> checking root refs
>> found 23421812736 bytes used err is 0
>> total csum bytes: 21531608
>> total tree bytes: 776650752
>> total fs tree bytes: 711278592
>> total extent tree bytes: 36798464
>> btree space waste bytes: 116002036
>> file data blocks allocated: 850546470912
>>   referenced 27611987968
>> 
>> Is it dangerous and what should I do about it?
>> 
>> I also tried --clear-space-cache, but it just removes the line about space cache.
>> 
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm afraid that your mail may be rejected because the attachment size
exceeds the allowable limit(100kB) of btrfs mailing list. Could you
share the attachment by google drive? 

Lastly, while Qu's timing is too tight, I will assist you on this issue.

-- 
Thanks,
Lu


