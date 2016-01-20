Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58322 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbcATSjs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 13:39:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLxfW-0005Au-1S
	for linux-btrfs@vger.kernel.org; Wed, 20 Jan 2016 19:39:46 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 19:39:46 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 19:39:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Interjection: autodefrag mount option aye, nae?
Date: Wed, 20 Jan 2016 18:39:39 +0000 (UTC)
Message-ID: <pan$90a8f$b59e4c75$185631ae$dd96d553@cox.net>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<5697D0E9.3080007@gmail.com>
	<20160114192647.GB24567@localhost.localdomain>
	<5697F9E7.1020004@gmail.com> <loom.20160120T163054-326@post.gmane.org>
	<569FAA4E.1040204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 20 Jan 2016 10:39:58 -0500 as
excerpted:

> On 2016-01-20 10:33, Al wrote:
>> [very quietly] I've had autodefrag out of my mount options for a long
>> while now. Is that still the recommended position?

> I think it really depends on what you're doing.  In my case, I usually
> have it on, and the only issue I've ever seen is that Chrome sometimes
> loads pages from local cache slower than it should be.  I also don't use
> ridiculous numbers of snapshots either (I use them only to get a stable
> view of the filesystem when generating a backup), so I don't have much
> experience with how they interact with autodefrag.

I use autodefrag here too.

The situations where autodefrag won't make sense are going to be ones 
where people are doing large files (half-gig plus) with heavy rewrites -- 
typically large database and VM image files.  Those need other measures, 
generally nocow, lower snapshotting frequencies, and periodic manual 
defrag.

Autodefrag with heavy snapshotting is more of an open question, as would 
be autodefrag on SSD.  I'd personally argue that the benefits of 
autodefrag exceed the down sides in these cases, but can easily see how 
some may argue otherwise, so it's admin's call, after suitable testing if 
they care enough about it to do that.

Autodefrag is definitely recommended for "desktop" usage (particularly on 
non-ssd), however, where the largest random-rewrite-pattern files are the 
smaller (typically under quarter GiB) sqlite type databases common to 
firefox/chrome/thunderbird/evolution/etc, as that's where autodefrag does 
its best.

My typical usage is pretty close to this "desktop" usage, tho I am on 
SSD, so I use autodefrag.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

