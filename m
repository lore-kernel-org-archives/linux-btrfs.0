Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:36062 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753312AbdCAVfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 16:35:02 -0500
Date: Wed, 1 Mar 2017 15:03:19 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: assertion failed: last_size == new_size, file: fs/btrfs/inode.c
Message-ID: <20170301200319.oqrftzsuj6u4nuuz@codemonkey.org.uk>
References: <20170227001842.dhrmaw3t3k4hkuii@codemonkey.org.uk>
 <20170227155348.GB13488@lim.localdomain>
 <20170227162342.z6j4bvinnqppwjjm@codemonkey.org.uk>
 <20170301011201.GB9546@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170301011201.GB9546@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 28, 2017 at 05:12:01PM -0800, Liu Bo wrote:
 > On Mon, Feb 27, 2017 at 11:23:42AM -0500, Dave Jones wrote:
 > > On Mon, Feb 27, 2017 at 07:53:48AM -0800, Liu Bo wrote:
 > >  > On Sun, Feb 26, 2017 at 07:18:42PM -0500, Dave Jones wrote:
 > >  > > Hitting this fairly frequently.. I'm not sure if this is the same bug I've
 > >  > > been hitting occasionally since 4.9. The assertion looks new to me at least.
 > >  > >
 > >  > 
 > >  > It was recently introduced by my commit and used to catch data loss at truncate.
 > >  > 
 > >  > Were you running the test with a mkfs.btrfs -O NO_HOLES?
 > >  > (We just queued a fix for the NO_HOLES case in btrfs-next.)
 > > 
 > > No, a fs created with default mkfs.btrfs options.
 > 
 > I have this patch[1] to fix a bug which results in file hole extent, and this
 > bug could lead us to hit the assertion.
 > 
 > Would you try to run the test w/ it, please?
 > 
 > [1]: https://patchwork.kernel.org/patch/9597281/

Made no difference. Still see the same trace & assertion.

	Dave

