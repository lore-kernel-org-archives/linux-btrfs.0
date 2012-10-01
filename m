Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53154 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2JARAR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 13:00:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TIjLk-0007XE-4U
	for linux-btrfs@vger.kernel.org; Mon, 01 Oct 2012 19:00:08 +0200
Received: from jfdmzpr03-ext.jf.intel.com ([134.134.139.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 19:00:08 +0200
Received: from tim.c.chen by jfdmzpr03-ext.jf.intel.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 19:00:08 +0200
To: linux-btrfs@vger.kernel.org
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [RFC][PATCH V2 0/4] Btrfs: introduce extent buffer cache to btrfs
Date: Mon, 1 Oct 2012 16:53:19 +0000 (UTC)
Message-ID: <loom.20121001T182737-438@post.gmane.org>
References: <5062E563.7090105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao Xie <miaox <at> cn.fujitsu.com> writes:

> 
> This patchset introduce extent buffer cache to btrfs. The basic idea
> is to reduce the search time and the contentions of the extent buffer
> lock by re-using the last search result.
> 
> I ran stress.sh, xfstests and some other tools to test it, all of them
> worked well.
> 
> As a performance improvement patchset, of course we did performance test.
> Because this patchset is to improve the b+ tree search, in other words,
> it improves the performance of the metadata operations, we use file creation
> test to measure it. So we ran 10 tasks, and all of them created 100000 files
> in their own directories at the same time. As the result, we found this 
patchset
> makes btrfs ~20% faster(98s -> 77s).
> 
> we can pull this patchset from the URL
> 
> 	git://github.com/miaoxie/linux-btrfs.git extent-buffer-cache
> 
> Thanks
> Miao
> ---

I tested the patchset with aim7's fileserver test with 16 processes on RAM 
emulated SCSI btrfs file system.  I got about 18% speedup in throughput.  The 
workload is a mix of file copy, read, write and file sync.

The contention on btrfs_tree_lock operation is reduced with the patchset, by 
about 8.4% of cpu cycles (from 48.3% to 39.9%).

Miao, I can send you the detailed profile if you are interested.

Thanks.

Tim Chen



