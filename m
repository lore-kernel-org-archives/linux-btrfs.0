Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:41204 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3JXWIq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 18:08:46 -0400
Date: Fri, 25 Oct 2013 00:09:19 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why cannot I move a read-only snapshot around?
Message-ID: <20131024220919.GB14128@kipc2.localdomain>
References: <20131024152955.GA6110@kipc2.localdomain>
 <pan$85344$b336f5bf$ca444091$a3ef1e0c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$85344$b336f5bf$ca444091$a3ef1e0c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

(pls see also my other reply in this thread)

On Thu 131024, Duncan wrote:
> Karl Kiniger posted on Thu, 24 Oct 2013 17:29:56 +0200 as excerpted:
> 
> > Dear list, (newbie alert)
> > 
> > After sucessfully sending and receiving a dozen of  related snapshots I
> > want to move them all to the readonly folder but I cannot:
> 
> I see you mention fedora 19 in a followup, but for those not on fedora, 
> that's not much help figuring out which kernel you're running.  It's 
> likely that the following is your problem, tho there's not enough 
> information in your post to be sure.

I promise to include more info in the future but just received
snapshots should be read-only if I read the docs correctly.

> 
> There was a recent regression with nested subvolumes that may be what 
> you're running into.  Kernel 3.11 was affected as well as early 3.12-rcs 
> and I believe 3.10 also but I'm not sure how far back, except that 
> someone mentioned trying an old kernel (3.8 or 3.6-ish) and moving 
> subvolumes into subvolumes worked there (tho doing anything involving 
> writing into read-only snapshots shouldn't work, by design, but that 
> doesn't appear to be what you're doing, you're just trying to move read-
> only snapshots to a different location on a read/write base or parent 
> subvolume, this post assuming it's a parent subvolume, thus triggering 
> the nested subvolumes bug).

No nested subvolumes involved. (Is this true? This all is inside the top 
level volume or what it is called in btrfs.....) 

> A fix is available but I'm not sure whether it got into 3.12 (which is 
> just about to be released) or will now have to wait for 3.13.  So either 
> try latest 3.12 git and see if its there, or find and cherry-pick the 
> patch, applying it against 3.11 or 3.12.  (Given that btrfs is still an 
> experimental filesystem with fixes applied every kernel, while reverting 
> to an old enough kernel should unregress this particular problem, I can't 
> recommend it except possibly for testing against data you don't care 
> about, since by doing so you're exposing yourself to other known and now 
> fixed bugs.)
Agreed, I dont want to go back to older kernels - too risky. The data  are
backed up anyways (on ZFS if you are curious)  but the time invested  into
my current btrfs setup would be gone.

I can live with the current situation, its just not nice to have the
snapshots lying around in a place where they should not belong.

If it were possible to temporarily make the r/o snapshots r/w just for
the purpose of moving (being aware that caution is needed) I would
not hesitate ane try that.

Karl


> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman

