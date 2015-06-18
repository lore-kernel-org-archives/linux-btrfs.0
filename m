Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48666 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbbFRF0A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 01:26:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5SKT-0001Yt-0X
	for linux-btrfs@vger.kernel.org; Thu, 18 Jun 2015 07:25:38 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 07:25:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 07:25:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: trim not working and irreparable errors from btrfsck
Date: Thu, 18 Jun 2015 05:25:05 +0000 (UTC)
Message-ID: <pan$e2fd3$4225d55d$123c95d2$8d29df22@cox.net>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<CAJCQCtTJU3z4je=CBWDP6qE7_rDt46ivYBs9T1NNj3b-5Fy_PA@mail.gmail.com>
	<mls4dj$2oh$1@ger.gmane.org> <5581ABA2.30906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 17 Jun 2015 13:17:22 -0400 as
excerpted:

> On 2015-06-17 11:40, Christian wrote:
>> On 06/17/2015 11:28 AM, Chris Murphy wrote:
>>
>>
>>>> However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be
>>>> another problem. Is there a way to check if trim works?
>>>
>>> That sounds like maybe your SSD is blacklisted for trim, is all I can
>>> think of. So trim shouldn't be the cause of the problem if it's being
>>> blacklisted. The recent problems appear to be around newer SSDs that
>>> support queue trim and newer kernels that issue queued trim. There
>>> have been some patches related to trim to the kernel, but the
>>> existence of blacklisting and claims of bugs in firmware make it
>>> difficult to test and isolate.
>>>
>>> http://techreport.com/news/28473/some-samsung-ssds-may-suffer-from-a-
buggy-trim-implementation
>>>
>>>
>> This is an Intel SSD in a Lenovo Thinkpad X1 Carbon. Trim worked until
>> a few weeks ago and still works for my small ext4 boot partition (just
>> ran it to check). I will keep looking for a solution. Thanks!
>>
> I'm seeing the same issue here, but with a Crucial brand SSD.  Somewhat
> interestingly, I don't see any issues like this with BTRFS on top of
> LVM's thin-provisioning volumes, or with any other filesystems, so I
> think it has something to do with how BTRFS is reporting unused space or
> how it is submitting the discard requests.

FWIW, there's a current btrfs patch in progress that relates to problems 
with btrfs trim.

But while I do have SSDs, I purposefully overprovisioned them by nearly 
100% (IOW I partitioned only about 55%, the rest is entirely unused), so 
trim isn't as critical here as it is for many.  I don't use the discard 
mount option, and have a systemd timer job setup to automate my fstrims 
and don't worry about the output too much, so I haven't been following 
the patch progress /that/ closely.

But I do know that recent kernel btrfs trims (either fstrim or discard 
mount option triggered) haven't been working as originally intended due 
to some bug, and this patch is supposed to fix it.

I'd thus conclude that you're very likely hitting this known issue, and 
that either for 4.1 or 4.2 (again, I'm not following progress that 
closely, and don't remember for sure if it's in 4.1, altho I've been 
running the rcs since rc6 or so), the problem should be fixed as that 
patch gets into mainline.

Anyone wishing to investigate further can of course check the list (and/
or possibly the kernel's git log) for discard/trim related patches and 
follow the progress once found.

... Actually, just checked myself.  Looks like the patches were first 
posted on March 30 @ 15:12:17 -0400 or so (that's the time for one of 
them).  There's one for the discard mount option, and another for FITRIM 
(which may or may not be a typo for FSTRIM, I'm not actually sure).  Jeff 
Mahoney <jeffm@suse.com> author.  That should be enough to find the 
threads.  And I don't see the patches in the late 4.1-rc I'm running so 
either my git log search foo is bad or it'll be (at least) 4.2.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

