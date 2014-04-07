Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58759 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaDGO2z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 10:28:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXAXd-0007Uo-0x
	for linux-btrfs@vger.kernel.org; Mon, 07 Apr 2014 16:28:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 16:28:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 16:28:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "No space left on device" during retroactive compression with
 btrfs filesystem defragment
Date: Mon, 7 Apr 2014 14:28:37 +0000 (UTC)
Message-ID: <pan$31cdd$96b07dfa$63c463e0$e30da66c@cox.net>
References: <CAPpBBdPc4ScNEhfYF0SMHwSxZSjN4hYni66VTytMRE6D0BB1rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Eleftheriou posted on Mon, 07 Apr 2014 12:34:27 +0200 as excerpted:

> Browsing the btrfs wiki for a relevant warning I just found this one:
> 
> Caveat: Before Linux 3.9, which adds snapshot-aware defragmentation,
> defragmenting a file which had a COW copy (either a snapshot copy or one
> made with cp --reflink or bcp) would produce two unrelated files. If you
> defragmented a subvolume that had a snapshot, you would roughly double
> the disk usage, as the snapshot files were no longer COW images of the
> originals.
> 
> Which comes close but not quite, since the issue happened during
> compression and not plain defragmentation and since the kernel I was
> running was 3.13.8

Unfortunately, that bit of the wiki isn't current.  3.14 disabled 
snapshot-aware defrag once again and I believe the disabling was pulled 
into stable as well, as the algorithm used simply didn't scale well at 
all, and people with lots of snapshots (as with snapper) were seeing 
defrag go hours, even days, with little apparent progress at all!  So it 
was disabled, allowing people to at least have a /somewhat/ useable 
defrag on the currently mounted snapshot, even if it was at the expense 
of increasing space usage due to being snapshot unaware once again.

The idea was to rewrite the algorithm to something that scaled rather 
better, and then reenable snapshot-awareness, but I've seen nothing 
posted as to the progress on that.

If you have a kernel git tree, it's...
commit 8101c8dbf6243ba517aab58d69bf1bc37d8b7b9c , merged in
commit 878a876b2e10888afe53766dcca33f723ae20edc , which is described as 
v3.14-rc1-13-g878a876, so just after 3.14-rc1.

So anyway, that's very likely what you were seeing, not only the 
compression thing, which might or might not work that way as well.

Meanwhile, however, your post did help me make the connection.  Someone 
else had posted similar results, tho I think without compression involved 
but I *DO* know he had lots of snapshots, and I didn't make the logical 
connection with snapshot unaware defrag there, so the fact that he had to 
delete the snapshots to do the defrag was there but unexplained.  But 
your post prodded my thinking and now I realize what happened there as 
well.  Thanks. =:^)


I've been meaning to get myself a wiki account so I can fix such things 
myself, but I tend to work much better in the familiar environment of 
lists and newsgroups and I've not done so, so as of now the task of 
editing the wiki for such updates must fall to others.  I'm sure others 
reading the wiki would be grateful if you took the time to do that 
update, now that you have the knowledge to do so. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

