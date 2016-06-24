Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33448 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbcFXLZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 07:25:05 -0400
Received: by mail-io0-f177.google.com with SMTP id t74so96734767ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 04:25:04 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu> <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
 <20160624020712.GC14667@hungrycats.org>
 <CAJCQCtSt832VcaKanj9cn9wY6+FZ68G9mOuSS=8i-AzmGQuV9g@mail.gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <74831e14-62b1-209a-73c0-416766d8dc46@gmail.com>
Date: Fri, 24 Jun 2016 07:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSt832VcaKanj9cn9wY6+FZ68G9mOuSS=8i-AzmGQuV9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-24 01:20, Chris Murphy wrote:
> On Thu, Jun 23, 2016 at 8:07 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
>
>>> With simple files changing one character with vi and gedit,
>>> I get completely different logical and physical numbers with each
>>> change, so it's clearly cowing the entire stripe (192KiB in my 3 dev
>>> raid5).
>>
>> You are COWing the entire file because vi and gedit do truncate followed
>> by full-file write.
>
> I'm seeing the file inode changes with either a vi or gedit
> modification, even when file size is exactly the same, just character
> substitute. So as far as VFS and Btrfs are concerned, it's an entirely
> different file, so it's like faux-CoW that would have happened on any
> file system, not an overwrite.
Yes, at least Vim (which is what most Linux systems use for vi) writes 
to a temporary file then does a replace by rename.  The idea is that 
POSIX implies that this should be atomic (except it's not actually 
required by POSIX, and even on some journaled and COW filesystems, it 
isn't actually atomic).
