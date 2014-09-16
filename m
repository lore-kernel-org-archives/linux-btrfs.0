Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44259 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaIPTg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 15:36:27 -0400
Received: by mail-lb0-f177.google.com with SMTP id l4so472307lbv.22
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 12:36:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45CDD4CC-7486-4074-A8E1-4573C40F8462@colorremedies.com>
References: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com>
 <5F01E283-D95E-4F81-B358-6470ABD58C0D@colorremedies.com> <45CDD4CC-7486-4074-A8E1-4573C40F8462@colorremedies.com>
From: Tony Murray <murraytony@gmail.com>
Date: Tue, 16 Sep 2014 14:36:05 -0500
Message-ID: <CAPDSe6s2_bk18wakrjUb5+z+2fmVu3jjFpPEE63dM_rmeMEOeA@mail.gmail.com>
Subject: Re: unable to mount, tools segfault
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, that was really just a sample of output rather then a
run-through of my steps.  Also, I captured an image of the partition
so I could re-install my OS.

I did try btrfs-zero-log first, but not btrfs rescue super-recover (as
I was afraid it might break my superblock).

I will try the latest 3.17rc and btrfs-progs integration (one at a
time) when I get a chance.

# btrfs-zero-log btrfs.img
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
Check tree block failedd, want=688963584, have=0
read block failed check_tree_block
Couldn't setup extent tree



#btrfs-debug-tree -R btrfs.img
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
Check tree block failed, want=688963584, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=686817280, have=0
Check tree block failed, want=686817280, have=0
Check tree block failed, want=686817280, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=687718400, have=0
Check tree block failed, want=687718400, have=0
Check tree block failed, want=687718400, have=0
read block failed check_tree_block
Couldn't setup log root tree
unable to open btrfs.img

On Mon, Sep 15, 2014 at 8:16 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sep 15, 2014, at 6:56 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>
>> On Sep 15, 2014, at 3:41 PM, Tony Murray <murraytony@gmail.com> wrote:
>>>
>>> # btrfs restore -v -i /dev/sda7 /mnt/sdb1/
>>
>> Starting with umounted volume:
>>
>> btrfs check <dev>
>> btrfs-debug-tree -R <dev>
>
> Oh nevermind I just saw that you did a btrfsck --repair, so you really kinda got the sequence wrong by doing that so soon and without list advice. I don't see whether you tried btrfs-zero-log first, or btrfs rescue super-recover, did you?
>
> btrfs-debug-tree -R should show four backup slots, and it's possible to plug in the tree root block value into btrfs restore -t, and maybe extract some data. And then it gets more aggressive from there, by seeing if you get any different recovery results with kernel 3.17rc5; and then it's btrfs-progs integration branch territory to see if maybe btrfs-zero-log or btrfs check will do something differently.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
