Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbbKCT01 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Nov 2015 14:26:27 -0500
Date: Tue, 3 Nov 2015 11:26:25 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jbacik@fb.com, Chris Mason <clm@fb.com>
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
Message-ID: <20151103192625.GE15575@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag>
 <5636BDA0.4020200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5636BDA0.4020200@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 09:34:24AM +0800, Qu Wenruo wrote:
> 
> 
> Stefan Priebe wrote on 2015/11/01 21:49 +0100:
> >Hi,
> >
> >this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html
> >
> >adds a regression to my test systems with very large disks (30tb and 50tb).
> >
> >btrfs balance is super slow afterwards while heavily making use of cp
> >--reflink=always on big files (200gb - 500gb).
> >
> >Sorry didn't know how to correctly reply to that "old" message.
> >
> >Greets,
> >Stefan
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Thanks for the testing.
> 
> Are you using qgroup or just doing normal balance with qgroup disabled?
> 
> For the latter case, that's should be optimized to skip the dirty
> extent insert in qgroup disabled case.
> 
> For qgroup enabled case, I'm afraid that's the design.
> As relocation will drop a subtree to relocate, and to ensure qgroup
> consistent, we must walk down all the tree blocks and mark them
> dirty for later qgroup accounting.

Qu, we're always going to have to walk the tree when deleting it, this is
part of removing a subvolume. We've walked shared subtrees in this code for
numerous kernel releases without incident before it was removed in 4.2.

Do you have any actual evidence that this is a major performance regression?
>From our previous conversations you seemed convinced of this, without even
having a working subtree walk to test. I remember the hand wringing
about an individual commit being too heavy with the qgroup code (even though
I pointed out that tree walk is a restartable transaction).

It seems that you are confused still about how we handle removing a volume
wrt qgroups.

If you have questions or concerns I would be happy to explain them but
IMHO your statements there are opinion and not based in fact.

Yes btw, we might have to do more work for the uncommon case of a
qgroup being referenced by higher level groups but that is clearly not
happening here (and honestly it's not a common case at all).
	--Mark


--
Mark Fasheh
