Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from odin.sdf-eu.org ([178.63.35.194]:65496 "EHLO sdfeu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755167AbdAAXkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Jan 2017 18:40:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 02 Jan 2017 00:29:52 +0100
From: none <ytrezq@sdf-eu.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to recover a filesystem without formatting nor using the
 btrfs check command.
In-Reply-To: <2166adfe-88af-5d9a-295f-d7002d64ed0e@cn.fujitsu.com>
References: <580944C7.103@sdf-eu.org>
 <8c5ae48c-4af6-42d9-be0f-06d232764ff2@cn.fujitsu.com>
 <36f56365-27ac-878e-c5fb-f414646eda3a@sdf-eu.org>
 <61df188a-bc12-c9c4-0322-766df4fb18c0@cn.fujitsu.com>
 <a8b030a4fab174ade203bf061151f270@mx.sdfeu.org>
 <08227414-b241-28a5-bbc6-7fb21d4b3e62@cn.fujitsu.com>
 <7dcfffa62234ff0fa5ae060f75df25f1@mx.sdfeu.org>
 <2166adfe-88af-5d9a-295f-d7002d64ed0e@cn.fujitsu.com>
Message-ID: <866efefad9d62f7f00c117edc4715651@mx.sdfeu.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2016-10-27 03:11, Qu Wenruo a écrit :
> At 10/26/2016 07:52 PM, none wrote:
>> Le 2016-10-26 03:43, Qu Wenruo a écrit :
>>> Unfortunately, low memory mode is right here.
>>> 
>>> If btrfs-image dump the image correctly, your extent tree is really
>>> screwed up.
>>> 
>>> And how badly it is screwed up?
>>> It only contains the basic block group info.
>>> Almost empty, without any really useful EXTENT_ITEM/METADATA_ITEM.
>>> You can check it by btrfs-debug-tree -t extent.
>>> Normally, one EXTENT_DATA or tree block should have corresponding
>>> EXTENT_ITEM or METADATA_ITEM in extent tree.
>>> 
>>> But in your dump, I only find EXTENT_ITEM less than a dozen, which is
>>> totally abnormal for the used size of your fs.
>> Please note df -h report 55Gb used due to a very high compression 
>> ratio.
>> Basically most of the theoretical used space is done by less than 100
>> files. I want to delete them
>>> That's why lowmem mode is reporting so many backref lost.
>> Whithout the lowmem mode, only 3 lines are reported :
>> 
>> Failed to find [75191291904, 168, 4096]
>> btrfs unable to find ref byte nr 75191291904 parent 0 root 1  owner 1
>> offset 0
>> Failed to find [75191316480, 168, 4096]
>> btrfs unable to find ref byte nr 75191316480 parent 0 root 1  owner 0
>> offset 1
>> parent transid verify failed on 75191349248 wanted 3555361 found 
>> 3555362
>> Ignoring transid failure
>> 
>> and then it’s cpu locked.
> 
> It's the dead loop make btrfsck only able to check the first several
> extents, no method to continue.
> 
> If we solve the dead loop, then there won't be less error report from
> original btrfsck.
> (lowmem mode just avoid the possibility to dead loop by its design)
> 
>> 
>>> It's almost a miracle that you can still write data into the fs.
>>> And I heavily doubt the correctness of your existing files.
>> They are definitely correct. I have several root filesystem and I can
>> chroot to all of them (though I’m mounting the partition readonly in
>> order to avoid dangerous writes in that case). In each case I tried
>> python and ruby cgi scripts.
> 
> You should check more, normally scrub will help, but considering the
> state of btrfs, scrub may not work at all or make things worse.
> 
>>> As extent tree is screwed up, it's completely possible new write are
>>> overwriting existing data.
>> Though I only attempted to write to 3 files. But yes, this was 
>> something
>> I suspected : that writing damage things.
>>> The only chance seems to be --init-extent-tree, but that's very
>>> dangerous and I highly suspect the screwed up extent tree is caused 
>>> by
>>> interrupted extent tree rebuild.
>> The problem is --init-extent-tree implies --repair which discard
>> --mode=lowmem and cause the dead lock :
>> https://bugzilla.kernel.org/show_bug.cgi?id=178781
> 
> Yes, that's the problem, and current situation may be caused by
> interrupted extent tree rebuild.
> 
>>> Thanks,
>>> Qu
>>> 
>> And finally, I found several corrupt directories yesterday.
>> 
>> Do you mean it’s impossible to rescue anything by repairing ? (this is
>> something I doubt since most files are valid)
> 
> Not completely, I'm digging into the dead loop problem, and after that
> you may still recover the fs(or part of it) using --init-extent-tree.
> 
> Thanks,
> Qu
> 
>> 
>> Thank you.

Hello, what’s the status of my report since last October ?

thanks,
