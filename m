Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932199AbeFFAVF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 20:21:05 -0400
From: Chris Mason <clm@fb.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        <bugzilla-daemon@bugzilla.kernel.org>, <bugzilla.kernel.org@plan9.de>,
        <linux-btrfs@vger.kernel.org>, <linux-mm@kvack.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [Bug 199931] New: systemd/rtorrent file data corruption when
 using echo 3 >/proc/sys/vm/drop_caches
Date: Tue, 5 Jun 2018 20:18:37 -0400
Message-ID: <9C514595-AA27-4794-9831-BEF3A8A6787E@fb.com>
In-Reply-To: <20180605130329.f7069e01c5faacc08a10996c@linux-foundation.org>
References: <bug-199931-27@https.bugzilla.kernel.org/>
 <20180605130329.f7069e01c5faacc08a10996c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 5 Jun 2018, at 16:03, Andrew Morton wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via 
> the
> bugzilla web interface).
>
> On Tue, 05 Jun 2018 18:01:36 +0000 bugzilla-daemon@bugzilla.kernel.org 
> wrote:
>
>> https://bugzilla.kernel.org/show_bug.cgi?id=199931
>>
>>             Bug ID: 199931
>>            Summary: systemd/rtorrent file data corruption when using 
>> echo
>>                     3 >/proc/sys/vm/drop_caches
>
> A long tale of woe here.  Chris, do you think the pagecache corruption
> is a general thing, or is it possible that btrfs is contributing?
>
> Also, that 4.4 oom-killer regression sounds very serious.

This week I found a bug in btrfs file write with how we handle stable 
pages.  Basically it works like this:

write(fd, some bytes less than a page)
write(fd, some bytes into the same page)
     btrfs prefaults the userland page
     lock_and_cleanup_extent_if_need()	<- stable pages
		wait for writeback()
		clear_page_dirty_for_io()

At this point we have a page that was dirty and is now clean.  That's 
normally fine, unless our prefaulted page isn't in ram anymore.

	iov_iter_copy_from_user_atomic() <--- uh oh

If the copy_from_user fails, we drop all our locks and retry.  But along 
the way, we completely lost the dirty bit on the page.  If the page is 
dropped by drop_caches, the writes are lost.  We'll just read back the 
stale contents of that page during the retry loop.  This won't result in 
crc errors because the bytes we lost were never crc'd.

It could result in zeros in the file because we're basically reading a 
hole, and those zeros could move around in the page depending on which 
part of the page was dirty when the writes were lost.

I spent a morning trying to trigger this with drop_caches and couldn't 
make it happen, even with schedule_timeout()s inserted and other tricks. 
  But I was able to get corruptions if I manually invalidated pages in 
the critical section.

I'm working on a patch, and I'll check and see if any of the other 
recent fixes Dave integrated may have a less exotic explanation.

-chris
