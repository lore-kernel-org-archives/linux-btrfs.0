Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36817 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3CZSEA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 14:04:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 57B949A03E9
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 12:04:00 -0600 (MDT)
Date: Tue, 26 Mar 2013 14:03:57 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: yiletian <lonat_front@163.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Re: compression btrfs
Message-ID: <20130326180357.GC28030@localhost.localdomain>
References: <15c1f0b7.19e37.13da4dd5320.Coremail.lonat_front@163.com>
 <20130326131430.GJ1955@localhost.localdomain>
 <57473f27.23ac0.13da786afad.Coremail.lonat_front@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <57473f27.23ac0.13da786afad.Coremail.lonat_front@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 10:27:34AM -0600, yiletian wrote:
> Yes, I use compress-force=zlib for my partition.
> 
> Consider this scenario.
> 
> We first write a file with size of 256KB. Assume all data is compressed to 128KB size,
> btrfs create a extent item in extent-tree to record the 128KB disk range  (named E).
> and btrfs also creates a single file extent to records the disk range of E.
> 
> Then we overwrite from 16KB to the end of file, with size of 240KB.
> Btrfs will create a new file extent for the overwritten range.
> That is, the file has two file extents: the first one is to record the first 16KB and the second one record the remaining 240KB.
> 
> Then we are in a dilemma:
> 1. the first one only occupies a disk range of 16KB, but entire E is reserved for it. This is because the __btrfs_drop_exte nts function do not decrease the number of back refs of E.
> 2. because the overwritten range is large enough, the compress_file_range does not  call btrfs_add_inode_defrag to kick off a defrag for the file automatically.
> 
> With this dilemma,  how can btrfs reclaim the 112KB disk range (at least) recorded in E.
> 

Oh yeah welcome to btrfs, you must be new here ;).  So yeah this is the way it
works, until we overwrite the entire extent we don't reclaim any of the space.
This includes the "prealloc an 8 gig vm image and then random write inside of
it" workload, you could end up using up to 16gb in the worst case scenario.  The
thing we could do to fix this would be to instead of splitting the file extents
and then inc'ing the ref of the original extent we instead split the extent ref
as well, so we can reclaim this space.  It's on my list of things to do down the
road, but it keeps getting supplanted by other priorities.  THanks,

Josef
