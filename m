Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51352 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbdLGC4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 21:56:36 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eMmMN-0004FJ-5x
        for linux-btrfs@vger.kernel.org; Thu, 07 Dec 2017 03:56:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC] Improve subvolume usability for a normal user
Date: Thu, 7 Dec 2017 02:56:21 +0000 (UTC)
Message-ID: <pan$33b4a$60a76f26$86fed72c$a3e3152c@cox.net>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
        <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
        <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
        <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
        <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 06 Dec 2017 07:39:56 -0500 as
excerpted:

> Somewhat OT, but the only operation that's remotely 'instant' is
> creating an empty subvolume.  Snapshot creation has to walk the tree in
> the subvolume being snapshotted, which can take a long time (and as a
> result of it's implementation, also means BTRFS snapshots are _not_
> atomic). Subvolume deletion has to do a bunch of cleanup work in the
> background (though it may be fairly quick if it was a snapshot and the
> source subvolume hasn't changed much).

Indeed, while btrfs in general has taken a strategy of making /creating/ 
snapshots and subvolumes fast, snapshot deletion in particular can take 
some time[1].

And in that regard a question just occurred to me regarding this whole 
very tough problem of a user being able to create but not delete 
subvolumes and snapshots:

Given that at least snapshot deletion (not so sure about non-snapshot 
subvolume deletion, tho I strongly suspect it would depend on the number 
of cross-subvolume reflinks) is already a task that can take some time, 
why /not/ just bite the bullet and make the behavior much more like the 
directory deletion, given that subvolumes already behave much like 
directories.  Yes, for non-root, that /does/ mean tracing the entire 
subtree and checking permissions, and yes, that's going to take time and 
lower performance somewhat, but subvolume and in particular snapshot 
deletion is already an operation that takes time, so this wouldn't be 
unduly changing the situation, and it would eliminate the entire class of 
security issues that come with either asymmetrically restricting deletion 
(but not creation) to root on the one hand, or possible data loss due to 
allowing a user to delete a subvolume they couldn't delete were it an 
ordinary directory due to not owning stuff further down the tree.

---
[1] Based on comments and reports here.  My own use-case doesn't involve 
snapshots/subvolumes.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

