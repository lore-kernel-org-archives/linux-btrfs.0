Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:45695 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdISPr3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:47:29 -0400
Received: by mail-it0-f42.google.com with SMTP id v19so48813ite.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 08:47:29 -0700 (PDT)
Subject: Re: SSD caching an existing btrfs raid1
To: Pat Sailor <psalleetsile@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2a208f7c-a140-3ac6-12c6-2e953f3f96ec@gmail.com>
Date: Tue, 19 Sep 2017 11:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-19 11:30, Pat Sailor wrote:
> Hello,
> 
> I have a half-filled raid1 on top of six spinning devices. Now I have 
> come into a spare SSD I'd like to use for caching, if possible without 
> having to rebuild or, failing that, without having to renounce to btrfs 
> and flexible reshaping.
> 
> I've been reading about the several options out there; I thought that 
> EnhanceIO would be the simplest bet but unfortunately I couldn't get it 
> to build with my recent kernel (last commits are from years ago).
As a general rule, avoid things that are out of tree if you want any 
chance of support here.  In the case of a third party module like 
EnhanceIO, you'll likely get asked to retest with a kernel without that 
module loaded if you run into a bug (because the module itself is suspect).
> 
> Failing that, I read that lvmcache could be the way to go. However, I 
> can't think of a way of setting it up in which I retain the ability to 
> add/remove/replace drives as I can do now with pure btrfs; if I opted to 
> drop btrfs to go to ext4 I still would have to offline the filesystem 
> for downsizes. Not a frequent occurrence I hope, but now I'm used to 
> keep working while I reshape things in btrfs, and it's better if I can 
> avoid large downtimes.
> 
> Is what I want doable at all? Thanks in advance for any 
> suggestions/experiences to proceed.
dm-cache (or lvmcache as the LVM2 developers want you to call it, 
despite it not being an LVM specific thing) would work fine, it won't 
prevent you from adding and removing devices, it would just make it more 
complicated.  Without it, you just need to issue a replace command (or 
add then remove).  With it, you need to set up the new cache device, 
bind that to the target, add the new device, and then delete the old 
device and remove the old cache target.  dm-cache managed through LVM 
also has the advantage that you can convert the existing FS trivially, 
although you will have to take it off-line for the conversion.

A better option if you can afford to remove a single device from that 
array temporarily is to use bcache.  Bcache has one specific advantage 
in this case, multiple backend devices can share the same cache device. 
This means you don't have to carve out dedicated cache space for each 
disk on the SSD and leave some unused space so that you can add new 
devices if needed.  The downside is that you can't convert each device 
in-place, but because you're using BTRFS, you can still convert the 
volume as a whole in-place.  The procedure for doing so looks like this:

1. Format the SSD as a bcache cache.
2. Use `btrfs device delete` to remove a single hard drive from the array.
3. Set up the drive you just removed as a bcache backing device bound to 
the cache you created in step 1.
4. Add the new bcache device to the array.
5. Repeat from step 2 until the whole array is converted.

A similar procedure can actually be used to do almost any underlying 
storage conversion (for example, switching to whole disk encryption, or 
adding LVM underneath BTRFS) provided all your data can fit on one less 
disk than you have.
