Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from odin.sdf-eu.org ([178.63.35.194]:52338 "EHLO sdfeu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968808AbdADWaP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jan 2017 17:30:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 04 Jan 2017 23:29:42 +0100
From: none <ytrezq@sdf-eu.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to recover a filesystem without formatting nor using the
 btrfs check command.
In-Reply-To: <24b88326-e44b-adc6-044d-ae678316f9a6@cn.fujitsu.com>
References: <580944C7.103@sdf-eu.org>
 <8c5ae48c-4af6-42d9-be0f-06d232764ff2@cn.fujitsu.com>
 <36f56365-27ac-878e-c5fb-f414646eda3a@sdf-eu.org>
 <61df188a-bc12-c9c4-0322-766df4fb18c0@cn.fujitsu.com>
 <a8b030a4fab174ade203bf061151f270@mx.sdfeu.org>
 <08227414-b241-28a5-bbc6-7fb21d4b3e62@cn.fujitsu.com>
 <7dcfffa62234ff0fa5ae060f75df25f1@mx.sdfeu.org>
 <2166adfe-88af-5d9a-295f-d7002d64ed0e@cn.fujitsu.com>
 <866efefad9d62f7f00c117edc4715651@mx.sdfeu.org>
 <24b88326-e44b-adc6-044d-ae678316f9a6@cn.fujitsu.com>
Message-ID: <ce3a4bebb63ae1c4d526f9943081e903@mx.sdfeu.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2017-01-03 07:11, Qu Wenruo a écrit :
>> 
>> Hello, what’s the status of my report since last October ?
>> 
>> thanks,
>> 
>> 
> Sorry for the late reply.
> 
> I tried your image but...
> It's so slow, no matter the mode I'm using.
> 
> So I'm not sure if it's a deadlock since lowmem mode still takes
> several minuts and just output the same output.
Anyway, I got the lowmem mode finishing. But it didn’t solved my 
problem. I have a core i7‑6700k ᴄᴘᴜ
> The fs contains SOOOOOOOOO many reflinks and I can hardly determine if
> it's normal or deadlock.
> 
Yes, but most those reflinks are used only by a small number of sparse 
file whose content are made of 0 bits (they still represent several 
hundreds of Gb data). If those files can be deleted, then I should be 
able to btrfs the disk normally. (the problem is I can’t do it because 
of filesystem corruption)

I don’t know how much they are, but I think the number is high enough to 
make btrfscking the disk as hard as breaking encryption.

> Considering btrfs check original mode is using list to iteration
> backrefs, it can be very very slow, maybe O(n^3)~O(n^4).
> 
> And considering the number of reflinks, it can be longer than your
> assumption (maybe longer than 48 hours).

I tried running it and even after a week nothing is finished. I never 
assumed anything.

> Just try xfstests generic/175, and see how slow btrfs check is.
> 
> 
> And since your fs tree is super big, normal btrfs-debug-tree output
> will be over several GBs for debugging, this also makes things quite
> nasty to debug manually.
But most of the virtual space is used by only a small number of very 
large files which I agree to delete.

> IMHO we only have 2 remaining methods to fix your fs:
> 1) Rework current backref structure.
>    Use rb-tree other than list to iteration.
> 2) Introduce --init-extent-tree in lowmem mode.
> 
> Neither way it's a quick fix.
> And I'm trying to implement the 2nd method first, but it may takes a
> lot of time.
> (I still have a lot of other btrfs development to do, sorry)
> 
> I'd suggest you to rebuild the fs, considering the time we need to fix 
> it.
which I can’t, looks like it will takes some months to get a rce 
vulnerability in git to get fixed (before corrupting the filesystem, I 
saw ᴄᴠᴇ‑2016‑2315 was fixed incorrectly on GitHub servers).

As soon as I get access to my previous work data, I will be able to 
trace the root cause in ~1‒5 hours.
> Thanks,
> Qu
regards,
