Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53283 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3KVRaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 12:30:00 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D78787C0428
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 10:29:59 -0700 (MST)
Date: Fri, 22 Nov 2013 12:29:57 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: avoid unnecessary ordered extent cache resets
Message-ID: <20131122172957.GC5349@localhost.localdomain>
References: <1385139163-7539-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1385139163-7539-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 22, 2013 at 04:52:43PM +0000, Filipe David Borba Manana wrote:
> After an ordered extent completes, don't blindly reset the
> inode's ordered tree last accessed ordered extent pointer.
> 
> While running the xfstests I noticed that about 29% of the
> time the ordered extent to which tree->last pointed was not
> the same as our just completed ordered extent. After that I
> ran the following sysbench test (after a prepare phase) and
> noticed that about 68% of the time tree->last pointed to
> a different ordered extent too.
> 
> sysbench --test=fileio --file-num=32 --file-total-size=4G \
>     --file-test-mode=rndwr --num-threads=512 \
>     --file-block-size=32768 --max-time=60 --max-requests=0 run
> 
> Therefore reset tree->last on ordered extent removal only if
> it pointed to the ordered extent we're removing from the tree.
> 

Well this is excellent, how much does it affect performance tho?  I'm still
going to take it, I'd just like to know how big of an impact it makes.  Thanks,

Josef
