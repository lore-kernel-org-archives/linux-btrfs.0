Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50035 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbaEGLgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 07:36:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wi08r-0005s5-EU
	for linux-btrfs@vger.kernel.org; Wed, 07 May 2014 13:36:05 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 13:36:05 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 13:36:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does Suse do live filesystem revert with btrfs?
Date: Wed, 7 May 2014 11:35:52 +0000 (UTC)
Message-ID: <pan$2da2e$d0644856$de7d595b$8d7f256e@cox.net>
References: <20140504005257.GF9061@merlins.org>
	<20140504232645.GQ9061@merlins.org> <20140505003639.GO24298@carfax.org.uk>
	<20140505050459.GF10159@merlins.org>
	<pan$4eac3$a2d76a4$a81e0fed$b4b18c9e@cox.net>
	<20140507085612.GB19238@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 07 May 2014 01:56:12 -0700 as excerpted:

> On Tue, May 06, 2014 at 04:26:48PM +0000, Duncan wrote:
>> Marc MERLIN posted on Sun, 04 May 2014 22:04:59 -0700 as excerpted:
>> 
>> > 
>> > Aaah, right, you can use a script to see the file differences between
>> > two snapshots, and then restore that with reflink if you can truly
>> > get a list of all changed files.
>> > However, that is indeed not atomic at all, even if faster than rsync.
>> 
>> Would send/receive help in such a script?
> 
> Not really, you still end up with a new snapshot that you can't live
> switch to.
> 
> It's really either 1) reboot 2) use cp --reflink to copy a list of
> changed files (as well as rm to delete the ones that were removed).

What I meant was... use send/receive locally, in place of the
cp --reflink.

But now that I think of it, at least in the normal sense that wouldn't 
work, since send is like diff and receive like patch, but what would be 
needed would actually be an option similar to patch --reverse.  With 
something like that, you could (in theory, in practice it'd be racy if 
other running apps were writing to it too) "reverse" the live subvolume 
to the state of the snapshot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

