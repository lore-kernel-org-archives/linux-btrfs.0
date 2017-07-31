Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37333 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdGaMIV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 08:08:21 -0400
Received: by mail-it0-f50.google.com with SMTP id v127so125090689itd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 05:08:21 -0700 (PDT)
Subject: Re: btrfs-freespace ever doing anything?
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <bf03be69-e9c4-f0c3-6853-936647630d05@cs.uni-bonn.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <76fe586d-37af-5e4d-106e-7f6f0d92e2bb@gmail.com>
Date: Mon, 31 Jul 2017 08:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <bf03be69-e9c4-f0c3-6853-936647630d05@cs.uni-bonn.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-31 06:51, Sebastian Ochmann wrote:
> Hello,
> 
> I have a quite simple and possibly stupid question. Since I'm 
> occasionally seeing warnings about failed loading of free space cache, I 
> wanted to clear and rebuild space cache. So I mounted the filesystem(s) 
> with -o clear_cache and subsequently with my regular options which 
> includes space_cache. Indeed, dmesg tells me:
> 
> [   60.285190] BTRFS info (device dm-1): force clearing of disk cache
> 
> and then
> 
> [  137.151845] BTRFS info (device dm-1): use ssd allocation scheme
> [  137.151850] BTRFS info (device dm-1): disk space caching is enabled
> [  137.151852] BTRFS info (device dm-1): has skinny extents
> 
> To my understanding, btrfs-freespace should then start working to 
> rebuild the free space cache. However, I can't remember that I have ever 
> seen btrfs work hard after clearing the space cache. The drives aren't 
> working much, and the btrfs-freespace processes (which are indeed there) 
> don't do anything either.
> 
> So simple question: Can anyone try to clear their space cache and 
> confirm that btrfs actually does something after doing so? Is there 
> anything I could do to confirm that something is happening?
Based on my (limited) understanding of that code, assuming you're using 
the original free space cache (which I think is the case, since you said 
you're using the regular 'space_cache' option instead of 
'space_cache=v2'), there's not _much_ work that needs to be done unless 
free space is heavily fragmented and the disk is reasonably full.  The 
original free space cache is pretty similar to an allocation bitmap, and 
computing that is not hard to do (you just figure out which blocks are 
actually used).

Based on my own experience, you'll see almost zero activity most of the 
time when rebuilding the free space cache regardless of which you are 
using (the original, or the new version), although the newer free space 
tree code appears to do a bit more work.
> 
> The drives in question are a SSD and a HDD, both in the range of 1-2 TB 
> in size.
> 
> I'm on Arch Linux, kernel 4.12.3, btrfs-progs 4.11.1

