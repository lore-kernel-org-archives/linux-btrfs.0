Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1807 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752763AbcERVLY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 17:11:24 -0400
Date: Wed, 18 May 2016 17:10:43 -0400
From: Chris Mason <clm@fb.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>
Subject: incoming merge conflict to linux-next
Message-ID: <20160518211043.qqzesbrmbbr7xba2@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stephen,

Dave Sterba's tree in linux-next has a few btrfs patches that we're not
sending yet into Linus.  We've got an update for Josef's enospc work
that'll get sent in next week.

So he prepped a pull for me that merged up a number of his branches but
didn't include Josef's new code.  It has all been in -next for some
time, and then I put some fixes from Filipe on top.

Long story short, you'll get a merge conflict from my next branch:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git next

I've got the sample resolution in next-merge:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git next-merge

Please let us know if you have any problems.

-chris

