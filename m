Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47416 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580AbbFCMqd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 08:46:33 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 3 Jun 2015 18:16:30 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 0F8481258056
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 18:18:53 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t53CkQ7r55967770
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 18:16:26 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t53BtdLJ026307
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 17:25:39 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: btrfs_defrag_file: Fix calculation of max_to_defrag.
Date: Wed, 03 Jun 2015 18:16:23 +0530
Message-ID: <5453369.Yc0I2j2qX5@localhost.localdomain>
In-Reply-To: <20150603104102.GL6761@twin.jikos.cz>
References: <1433323794-10045-1-git-send-email-chandan@linux.vnet.ibm.com> <20150603104102.GL6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 03 Jun 2015 12:41:02 David Sterba wrote:
> On Wed, Jun 03, 2015 at 02:59:54PM +0530, Chandan Rajendra wrote:
> > max_to_defrag represents the number of pages to defrag rather than the
> > last
> > page of the file range to be defragged. Fix this.
> 
> Please update the changelog and describe the buggy behaviour. From a
> brief look I think that the defrag batch will be much higher than
> desired. Elsewhere the defrag batch is 1024, the page indexes used here
> are always large numbers. I guess this could (partially) explain high
> load during defrag that people report.
> 
> ACK for the fix, I'll stick a reviewed-by to v2.

Hello Dave,

Consider a file having 10 4k blocks (i.e. blocks in the range [0 - 9]). If the
defrag ioctl was invoked for the block range [3 - 6], then max_to_defrag
should actually have the value 4. Instead in the current code we end up
setting it to 6.

Now, this does not (yet) cause an issue since the first part of the while loop
condition in btrfs_defrag_file() (i.e. "i <= last_index") causes the control
to flow out of the while loop before any buggy behavior is actually caused. So
the patch just makes sure that max_to_defrag ends up having the right value
rather than fixing a bug. I did run the xfstests suite to make sure that no
new regressions were introduced by this patch.

-- 
chandan

