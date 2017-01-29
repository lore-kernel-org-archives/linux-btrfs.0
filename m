Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35627 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdA2TxB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 14:53:01 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so4183327wmu.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jan 2017 11:52:33 -0800 (PST)
Subject: Re: btrfs recovery
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
 <3255da6a-c4a6-c464-7bc7-56fcff281937@googlemail.com>
 <42184069-91dd-9e32-5b41-f13f95960e86@mendix.com>
 <dab6c1c7-ebfc-5578-d9f4-ae3001b9efbf@googlemail.com>
 <0ab48f84-7e37-02aa-1de9-612fac3f02da@mendix.com>
 <58d4a6a0-fba9-79ca-9077-1c708b7a65a3@googlemail.com>
 <53a7797d-05b1-16f3-42f3-e6e9509cce4f@mendix.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <5f96c780-0ac3-ab61-581c-4d52e4a8ce02@googlemail.com>
Date: Sun, 29 Jan 2017 20:52:30 +0100
MIME-Version: 1.0
In-Reply-To: <53a7797d-05b1-16f3-42f3-e6e9509cce4f@mendix.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 29.01.2017 um 20:28 schrieb Hans van Kranenburg:
> On 01/29/2017 08:09 PM, Oliver Freyermuth wrote:
>>> [..whaaa.. text.. see previous message..]
>> Wow - this nice python toolset really makes it easy, bigmomma holding your hands ;-) . 
>>
>> Indeed, I get exactly the same output you did show in your example, which almost matches my manual change, apart from one bit here:
>> -00001fb0  d9 4f 00 00 00 00 00 00  00 20 a1 4d 01 00 95 d8
>> +00001fb0  d9 4f 00 00 00 00 00 00  00 20 a1 4d 00 00 00 00
>> I do not understand this change from 01 to 00, is this some parity information which python-btrfs fixed up automatically?
>>
>> Trusting the output, I did:
>> dd if=mblock_first_fixed of=/dev/sdb1 bs=1 seek=43417600 count=16384
>> dd if=mblock_first_fixed of=/dev/sdb1 bs=1 seek=1117159424 count=16384
>> and re-ran "btrfs-debug-tree -b 35028992 /dev/sdb1" to confirm, item 243 is now:
>> ...
>>         key (5547032576 EXTENT_ITEM 204800) block 596426752 (36403) gen 20441
>>         key (5561905152 EXTENT_ITEM 184320) block 596443136 (36404) gen 20441
>> =>      key (1302405120 EXTENT_ITEM 303104) block 596459520 (36405) gen 20441
>>         key (5726711808 EXTENT_ITEM 524288) block 596475904 (36406) gen 20441
>>         key (5820571648 EXTENT_ITEM 524288) block 350322688 (21382) gen 20427
> 
> Ehm, oh yes, that was obviously a mistake in what I showed. The
> 0xffffffff cuts off too much..
> 
>>>> 0xd89500014da12000 & 0xffffffff
> 1302405120L
> 
> This is better...
> 
>>>> 0xd89500014da12000 & 0xffffffffff
> 5597372416L
> 
> ...which is the value Hugo also mentioned to likely be the value that
> has to be there, since it nicely fits in between the surrounding keys.
Understood!
Now the diff matches exactly what I would done:
-00001fb0  d9 4f 00 00 00 00 00 00  00 20 a1 4d 01 00 95 d8
-00001fc0  4c 00 a0 04 00 00 00 00  00 00 40 8d 23 00 00 00
+00001fb0  d9 4f 00 00 00 00 00 00  00 20 a1 4d 01 00 00 00
+00001fc0  a8 00 a0 04 00 00 00 00  00 00 40 8d 23 00 00 00

It's really nice that python-btrfs takes over all the checksumming stuff. 

Writing things back and re-running "btrfs-debug-tree -b 35028992 /dev/sdb1", I find:

        key (5547032576 EXTENT_ITEM 204800) block 596426752 (36403) gen 20441
        key (5561905152 EXTENT_ITEM 184320) block 596443136 (36404) gen 20441
=>      key (5597372416 EXTENT_ITEM 303104) block 596459520 (36405) gen 20441
        key (5726711808 EXTENT_ITEM 524288) block 596475904 (36406) gen 20441
        key (5820571648 EXTENT_ITEM 524288) block 350322688 (21382) gen 20427

This matches the surroundings much better. 

> 
>> ...
>> Sadly, trying to mount, I still get:
>> [190422.147717] BTRFS info (device sdb1): use lzo compression
>> [190422.147846] BTRFS info (device sdb1): disk space caching is enabled
>> [190422.229227] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=242
>> [190422.241635] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=242
>> [190422.241644] BTRFS error (device sdb1): failed to read block groups: -5
>> [190422.254824] BTRFS error (device sdb1): open_ctree failed
>> The notable difference is that previously, the message was:
>> corrupt node, bad key order: block=35028992, root=1, slot=243
>> So does this tell me that also item 242 was corrupted?
> 
> No, I was just going too fast.
> 
> A nice extra excercise is to look up the block at 596459520, which this
> item points to, and then see which object is the first one in the part
> of the tree stored in that page. It should be (5597372416 EXTENT_ITEM
> 303104) I guess.
> 
That indeed matches your expectation, i.e.:
# btrfs-debug-tree -b 596459520 /dev/sdb1
contains:
        item 0 key (5597372416 EXTENT_ITEM 303104) itemoff 16230 itemsize 53

So all looks well! 

And now the final good news:
I can mount, no error messages in the syslog are shown! 


Finally, just to make sure there are no other issues, I ran a btrfs check in readonly mode:
 # btrfs check --readonly /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: cfd16c65-7f3b-4f5e-9029-971f2433d7ab
checking extents
checking free space cache
checking fs roots
invalid location in dir item 120
root 5 inode 177542 errors 2000, link count wrong
        unresolved ref dir 117670 index 29695 namelen 20 name 2016-07-12_10_26.jpg filetype 1 errors 1, no dir item
root 5 inode 18446744073709551361 errors 2001, no inode item, link count wrong
        unresolved ref dir 117670 index 0 namelen 20 name 2016-07-12_10_26.jpg filetype 1 errors 6, no dir index, no inode ref
found 127774183424 bytes used err is 1
total csum bytes: 124401728
total tree bytes: 346046464
total fs tree bytes: 163315712
total extent tree bytes: 35667968
btree space waste bytes: 53986463
file data blocks allocated: 177184325632
 referenced 130490667008

These errors are unrelated and likely caused by an earlier hard poweroff sometime last year. 

Nevertheless, since I'll now try to use this FS (let's see how long it keeps stable), I ran repair:
# btrfs check --repair /dev/sdb1
enabling repair mode
Checking filesystem on /dev/sdb1
UUID: cfd16c65-7f3b-4f5e-9029-971f2433d7ab
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
invalid location in dir item 120
Trying to rebuild inode:18446744073709551361
Failed to reset nlink for inode 18446744073709551361: No such file or directory
        unresolved ref dir 117670 index 0 namelen 20 name 2016-07-12_10_26.jpg filetype 1 errors 6, no dir index, no inode ref
checking csums
checking root refs
found 127774183424 bytes used err is 0
total csum bytes: 124401728
total tree bytes: 346046464
total fs tree bytes: 163315712
total extent tree bytes: 35667968
btree space waste bytes: 53986463
file data blocks allocated: 177184325632
 referenced 130490667008

It still mounts, and now:
[193339.299305] BTRFS info (device sdb1): use lzo compression
[193339.299308] BTRFS info (device sdb1): disk space caching is enabled
[193339.653980] BTRFS info (device sdb1): checking UUID tree

I guess this all is fine :-) . 

So all in all, I have to say a great thanks for all this support - it really was a good educational experience, and I am pretty sure this functionality of python-btrfs will be of help to others, too! 

Cheers and thanks, 
	Oliver
