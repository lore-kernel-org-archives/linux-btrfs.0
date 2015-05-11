Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36470 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbEKVUG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 17:20:06 -0400
Received: by pdea3 with SMTP id a3so157342349pde.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 14:20:05 -0700 (PDT)
Date: Mon, 11 May 2015 14:20:04 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Btrfs: show subvolume name and ID in /proc/mounts
Message-ID: <20150511212004.GB10078@mew.dhcp4.washington.edu>
References: <cover.1428614837.git.osandov@osandov.com>
 <20150511094258.GA18249@mew>
 <20150511145137.GN23255@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150511145137.GN23255@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 04:51:37PM +0200, David Sterba wrote:
> On Mon, May 11, 2015 at 02:42:58AM -0700, Omar Sandoval wrote:
> > Sorry for the long-winded email! Thoughts, David, Qu?
> 
> I'm ok with the approach and the patchset as a whole. There was one
> minor issue with the aliasing of the toplevel subvolume (id 0 or 5).
> I'll post a comment to the patch.

Thanks a lot for the review, I appreciate it.

I had to resolve a couple of minor conflicts rebasing this on v4.1-rc3
(due to the dentry->d_inode to d_inode(dentry) conversion), so I can
resend this soon if there are aren't any other issues.

-- 
Omar
