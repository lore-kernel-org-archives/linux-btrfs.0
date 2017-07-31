Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36754 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbdGaOdu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 10:33:50 -0400
Received: by mail-wr0-f196.google.com with SMTP id y67so30888775wrb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 07:33:49 -0700 (PDT)
Subject: Re: btrfs-freespace ever doing anything?
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <bf03be69-e9c4-f0c3-6853-936647630d05@cs.uni-bonn.de>
 <76fe586d-37af-5e4d-106e-7f6f0d92e2bb@gmail.com>
 <3a87aaa8-7341-27a3-399d-d3051257fa24@cs.uni-bonn.de>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <ecbc620b-db6e-85bb-f12a-563db3a2be1f@gmail.com>
Date: Mon, 31 Jul 2017 17:33:46 +0300
MIME-Version: 1.0
In-Reply-To: <3a87aaa8-7341-27a3-399d-d3051257fa24@cs.uni-bonn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.07.2017 15:30, Sebastian Ochmann wrote:
> On 31.07.2017 14:08, Austin S. Hemmelgarn wrote:
>> On 2017-07-31 06:51, Sebastian Ochmann wrote:
>>> Hello,
>>>
>>> I have a quite simple and possibly stupid question. Since I'm
>>> occasionally seeing warnings about failed loading of free space
>>> cache, I wanted to clear and rebuild space cache. So I mounted the
>>> filesystem(s) with -o clear_cache and subsequently with my regular
>>> options which includes space_cache. Indeed, dmesg tells me:
>>>
>>> [   60.285190] BTRFS info (device dm-1): force clearing of disk cache
>>>
>>> and then
>>>
>>> [  137.151845] BTRFS info (device dm-1): use ssd allocation scheme
>>> [  137.151850] BTRFS info (device dm-1): disk space caching is enabled
>>> [  137.151852] BTRFS info (device dm-1): has skinny extents
>>>
>>> To my understanding, btrfs-freespace should then start working to
>>> rebuild the free space cache. However, I can't remember that I have
>>> ever seen btrfs work hard after clearing the space cache. The drives
>>> aren't working much, and the btrfs-freespace processes (which are
>>> indeed there) don't do anything either.
>>>
>>> So simple question: Can anyone try to clear their space cache and
>>> confirm that btrfs actually does something after doing so? Is there
>>> anything I could do to confirm that something is happening?
>> Based on my (limited) understanding of that code, assuming you're
>> using the original free space cache (which I think is the case, since
>> you said you're using the regular 'space_cache' option instead of
>> 'space_cache=v2'), there's not _much_ work that needs to be done
>> unless free space is heavily fragmented and the disk is reasonably
>> full.  The original free space cache is pretty similar to an
>> allocation bitmap, and computing that is not hard to do (you just
>> figure out which blocks are actually used).
>>
>> Based on my own experience, you'll see almost zero activity most of
>> the time when rebuilding the free space cache regardless of which you
>> are using (the original, or the new version), although the newer free
>> space tree code appears to do a bit more work.
> 
> Ah, that's interesting, I have to admit I wasn't even aware of
> space_cache v2. That said, the btrfs wiki doesn't state its existence on
> the mount options page. It's only mentioned at the bottom of the Status
> page where clearing the space cache for v2 using "btrfs check" is
> explained.
> 
> The man page of "btrfs-check" states something interesting regarding the
> clearing of space cache using the "clear_cache" mount option when using v1:
> 
> "For free space cache v1, the clear_cache kernel mount option only
> rebuilds the free space cache for block groups that are modified while
> the filesystem is mounted with that option."
> 
> So "clear_cache" is, to my understanding, pretty much a misnomer. Only
> for v2, it actually clears the whole cache. I now used "btrfs check
> --clear-space-cache v1" on one of the devices and it took a while to
> clear the cache (way longer than when using the clear_cache mount
> option) (rebuilding still seems to be quick though).
> 
> The explanation of the space_cache and clear_cache options in the Wiki
> should be updated. The mount options page doesn't mention space_cache v2
> and the clear_cache option supposedly clears "all the free space caches"
> according to the wiki which contradicts the btrfs check manpage.


In case you are interested in learning a bit more on v2 you can check
Omar's presentation:
events.linuxfoundation.org/sites/events/files/slides/vault2016_0.pdf

> 
>>> The drives in question are a SSD and a HDD, both in the range of 1-2
>>> TB in size.
>>>
>>> I'm on Arch Linux, kernel 4.12.3, btrfs-progs 4.11.1
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
