Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56543 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaLBIvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 03:51:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvjAm-0000kp-A3
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 09:51:04 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 09:51:04 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 09:51:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Moving an entire subvol?
Date: Tue, 2 Dec 2014 08:50:48 +0000 (UTC)
Message-ID: <pan$364c4$821651d0$d839f1d8$302350b3@cox.net>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
	<CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
	<CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shriramana Sharma posted on Tue, 02 Dec 2014 08:51:40 +0530 as excerpted:

> On Mon, Dec 1, 2014 at 6:24 AM, Chris Murphy <lists@colorremedies.com>
> wrote:
>>> But isn't it just possible to move i.e. reparent a subvol so I can
>>> move these two under another subvol and have that as default?
>>
>> You can move subvolumes.
> 
> OK so I just found out that just mv test1/foo test2/ where test1,
> test2 and foo are all subvolumes is sufficient to reparent foo to test2,
> if what btr sub list shows as "top level" is indeed the parent
> subvolume.
> 
> Is that correct: what btr sub list shows as "top level" is indeed the
> parent subvolume?

[Noting that my use-case doesn't involve subvolumes so while I've played 
with them a bit my direct knowledge is limited...]

It should be correct, yes.

Subvolumes are in many ways "super-directories", so it's little surprise 
simply directory manipulation such as moves would do what you might 
expect.  They just happen to be directly mountable too, and to have 
various btrfs-specific effects such as snapshots stopping at subvolume 
boundaries, usage for btrfs send/receive, etc.

>> My suggestion is subvolumes containing binaries shouldn't be located
>> within another subvolume that ends up being mounted, that way old
>> binaries with possible vulnerabilities aren't exposed in the normal
>> search path.
> 
> I'm not sure what you mean. Are you saying that for example /usr/bin
> should be:
> 
> 1) a separate subvolume than / or /usr,
> 2) not a child subvolume of / or /usr?

What I believe he's referencing is the potential security issue if for 
example you have older snapshots of /usr (which would include /usr/bin 
and /usr/lib(64)) accessible under normal operating conditions.  These 
snapshots would contain older versions of binaries (and libraries) that 
have been security-updated on the main system, but the snapshots would of 
course contain the still vulnerable versions.  A user trying to do a root-
escalation, for instance, could then access and run one of these old and 
vulnerable versions by specifying the full path instead of just the name, 
thus getting access to a known root-escalation vuln long since patched in 
the main path but still vulnerable in the snapshot path.

If for instance the master id=5 subvolume is still the default and 
routinely mounted, it will have all snapshots appearing as directories 
somewhere beneath its mountpoint in the tree.  If those snapshots contain 
bin or lib dirs, the above security scenario is a real possibility, since 
they'll be accessible in the tree.

So making something other than the master id=5 subvolume the default, 
mounting id=5 only when doing subvolume maintenance not routinely, and 
making such bin/lib-containing snapshots direct children of id=5 instead 
of children of the / subvolume or the like, will keep the snapshots 
containing the possibly vulnerable bins/libs out of normal accessibility 
as they'll only be visible in the tree when id=5 is mounted for snapshot 
maintenance, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

