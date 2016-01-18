Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33730 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbcARMtb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 07:49:31 -0500
Received: by mail-io0-f180.google.com with SMTP id q21so548396702iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:49:31 -0800 (PST)
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <loom.20160116T132316-196@post.gmane.org>
 <569C41B1.1090206@cn.fujitsu.com>
 <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
 <569C58FB.70407@cn.fujitsu.com> <pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <569CDF0D.9030609@gmail.com>
Date: Mon, 18 Jan 2016 07:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-17 22:51, Duncan wrote:
> Qu Wenruo posted on Mon, 18 Jan 2016 11:16:11 +0800 as excerpted:
>
>> Duncan wrote on 2016/01/18 03:10 +0000:
>>>
>>> Doesn't the kernel write cache get synced by timeout as well as
>>> memory pressure and manual sync, with the timeouts found in
>>> /proc/sys/vm/dirty_*_centisecs, with defaults of 5 seconds
>>> background and 30 seconds higher priority foreground expiry?
>>>
>> Yep, I forgot timeout. It can also be specified by per fs mount
>> option "commit=".
>>
>> But I never /proc/sys/vm/dirty_* interface before... I'd better
>> check the code or add some debug pr_info to learn such behavior.
>
> Checking a bit more my understanding, since you brought up the
> btrfs "commit=" mount option.
>
> I knew about the option previously, and obviously knew it worked in the
> same context as the page-cache stuff, but in my understanding the btrfs
> "commit=" mount option operates at the filesystem layer, not the general
> filesystem-vm layer controlled by /proc/sys/vm/dirty_*.  In my
> understanding, therefore, the two timeouts could effectively be added,
> yielding a maximum 1 minute (30 seconds btrfs default commit time plus 30
> seconds vm expiry) commit time.
In a way, yes, except the commit option controls when a transaction is 
committed, and thus how often the log tree gets cleared.  It's 
essentially saying 'ensure the filesystem is consistent without 
replaying a log at least this often'.  AFAIUI, this doesn't guarantee 
that you'll go that long without a transaction, but puts an upper bound 
on it.  Looking at it another way, it pretty much says that you don't 
care about losing the last n seconds of changes to the FS.

The sysctl values are a bit different, and control how long the kernel 
will wait in the VFS layer to try and submit a larger batch of writes at 
once, so that the block layer has more it can try to merge, and 
hopefully things get written out faster as a result.  IOW, it's a knob 
to control the VFS level write-back caching to try and tune for 
performance.  This also ties in with 
/proc/sys/vm/dirty_writeback_centisecs, which is how often after the 
expiration hits that the kernel will flush a chunk of the cache, and 
/proc/sys/vm/dirty_{background,}_{bytes,ratio} which puts an upper limit 
on how much data will be buffered before trying to flush it out to 
persistent storage.  You almost certainly want to change these, as they 
defaults to 10% of system RAM, which is why it often takes a ridiculous 
amount of time to unmount a flash drive that's been written to a lot. 
dirty_{ratio,bytes} control the per-process limit, and 
dirty_background_{ratio,bytes} control the system-wide limit.
>
> But that has always been an unverified on my part fuzzy assumption.  The
> two times could be the same layer, with the btrfs mount option being a
> per-filesystem method of controlling the same thing that /proc/sys/vm/
> dirty_expire_centisecs controls globally (as you seemed to imply above),
> or the two could be different layers but with the countdown times
> overlapping, both of which would result in a 30-second total timeout,
> instead of the 30+30=60 that I had assumed.
The two timers do overlap.
>
> And while we're at it, how does /proc/sys/vm/vfs_cache_pressure play into
> all this?  I know the dirty_* and how the dirty_*bytes vs. dirty_*ratio
> vs. dirty_*centisecs thing works, but don't quite understand how
> vfs_cache_pressure fits in with dirty_*.
vfs_cache_pressure controls how likely the kernel is to drop clean pages 
(the documentation says just dentries and inodes, but I'm relatively 
certain it's anything in the VFS cache) from the VFS cache to get memory 
to allocate.  The higher this is, the more likely the VFS cache is to 
get invalidated.  In general, you probably want to increase this on 
systems that have fast storage (like SSD's or really good SAS RAID 
arrays, 150 is usually a decent start), and decrease it if you have 
really slow storage (Like a Raspberry Pi for example).  Setting this too 
low (below about 50) however, will give you a very high chance of 
getting an OOM condition.
>
> Of course if there's already a good writeup on the dirty_* vs
> vfs_cache_pressure question somewhere, a link would be fine.  But I doubt
> there's good info on how the btrfs commit= mount option fits into it all,
> as the btrfs option is relatively newer and it's likely I'd have seen
> that all ready, if it was out there.
Documentation/sysctl/vm.txt in the kernel sources covers them, although 
the documentation is a bit sparse even there.

