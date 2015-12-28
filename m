Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56308 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbL1ECm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 23:02:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDP15-00016A-BU
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 05:02:39 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 05:02:39 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 05:02:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
Date: Mon, 28 Dec 2015 04:02:31 +0000 (UTC)
Message-ID: <pan$2108f$416fcf23$11933405$72f48ca8@cox.net>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no> <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
	<568098B1.2040908@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Waxhead posted on Mon, 28 Dec 2015 03:04:33 +0100 as excerpted:

> Duncan wrote:
>> Waxhead posted on Mon, 28 Dec 2015 00:06:46 +0100 as excerpted:
>>
>>> btrfs scrub status /mnt
>>> scrub status for 2832346e-0720-499f-8239-355534e5721b
>>>           scrub started at Sun Mar 29 23:21:04 2015

>>> Now here is the first worrying part... it says that scrub started at
>>> Sun Mar 29.

>> Hmm...  The status is stored in readable plain-text files in /var/lib/
>> btrfs/scrub.status.*, where the * is the UUID.  If you check there, the
>> start time (t_start) seems to be in POSIX time.
>>
>> Is it possible you were or are running the scrub from, for instance, a
>> rescue image that might not set the system time correctly and that
>> falls back to, say, the date the rescue image was created, if it can't
>> get network connectivity or some such?
>>
> No I don't think so....
> 
> # ls -la
> /var/lib/btrfs/scrub.status.2832346e-0720-499f-8239-355534e5721b
> -rw------- 1 root root 2315 Mar 29  2015
> /var/lib/btrfs/scrub.status.2832346e-0720-499f-8239-355534e5721b
> 
> # cat /var/lib/btrfs/scrub.status.2832346e-0720-499f-8239-355534e5721b
> scrub status:1
> 2832346e-0720-499f-8239-355534e5721b:1|[...]|t_start:1427664064|[...]
> 
> # date Mon Dec 28 02:54:11 CET 2015
> 
> Just to clear up any possible misunderstandings. I run this from a
> simple netbook, and I have no idea why the date is off by so much.

Well, both the file time and the unix time in the file say back in March, 
so whatever time syncing mechanism you use on that netbook, it evidently 
failed the boot you did that scrub.

> Note:  I have used the same USB drives (memory sticks really) to create
> various configs of btrfs filesystems earlier. Could it be old metadata
> in the filesystem that mess up things? Is not metadata stamped with the
> UUID of the filesystem to prevent such things?

Yes, metadata is stamped with UUID.  But one other possible explanation 
for the scrub time back in March might be if you were already playing 
with it back then, and somehow you have a USB stick with a filesystem 
from back then that... somehow... has the same UUID as the one you're 
experimenting on today.

Don't ask me how it could get the same UUID.  I don't understand it 
either.  But if it did somehow happen, btrfs would be /very/ confused, 
and crashing scrubs and further data corruption could certainly result.

Of course if you weren't experimenting with btrfs on these devices back 
at the end of March and there's absolutely no way they could have gotten 
btrfs on them until say October or whenever, then we're back to the date 
somehow being wrong for that scrub, and having to look elsewhere for why 
scrub is crashing.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

