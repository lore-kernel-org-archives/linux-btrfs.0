Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58482 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab3G2SZ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 14:25:28 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A9E719A0420
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 12:25:27 -0600 (MDT)
Date: Mon, 29 Jul 2013 14:25:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eric Sandeen <sandeen@sandeen.net>
CC: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@fusionio.com>,
        <jeff.liu@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: generic/315: add one more sync and more output
Message-ID: <20130729182525.GD24583@localhost.localdomain>
References: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
 <51F6A6DA.3080102@redhat.com>
 <51F6A891.7070608@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51F6A891.7070608@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 29, 2013 at 12:38:25PM -0500, Eric Sandeen wrote:
> On 7/29/13 12:31 PM, Eric Sandeen wrote:
> > Honest question: does one more sync make this deterministic, or is it a best-effort, um, hack?
> 
> I'm not quite sure why even 1 sync is needed.  :(
> 

Because of COW, we won't free up the data space until the transaction commits
because it is pinned, so doing the truncate and then immediately doing df will
show no difference.

> I'm not sure what bug this is trying to test; if you need 2 syncs for global space stats to accurately reflect the fact that you chopped off the end of a block, maybe that's ... still a bug?
> 

No, it's just COW for you, in this case we do our sync, stuff gets updated and
some metadata is cow'ed for once reason or another and now df doesn't quite
match up (in my case it was off by like 9 blocks), doing a second sync clears
these out and then df's match.

> Or if it's just the big-hammer question of "does the truncated space *ever* get freed?" then maybe umount/remount/check would tell you that more definitively.

Yeah but I think I'll do what you suggested on IRC and just use _within_range.
Thanks,

Josef
