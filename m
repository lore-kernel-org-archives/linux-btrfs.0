Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:37046 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdB0RKB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 12:10:01 -0500
Date: Mon, 27 Feb 2017 11:23:42 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: assertion failed: last_size == new_size, file: fs/btrfs/inode.c
Message-ID: <20170227162342.z6j4bvinnqppwjjm@codemonkey.org.uk>
References: <20170227001842.dhrmaw3t3k4hkuii@codemonkey.org.uk>
 <20170227155348.GB13488@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170227155348.GB13488@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2017 at 07:53:48AM -0800, Liu Bo wrote:
 > On Sun, Feb 26, 2017 at 07:18:42PM -0500, Dave Jones wrote:
 > > Hitting this fairly frequently.. I'm not sure if this is the same bug I've
 > > been hitting occasionally since 4.9. The assertion looks new to me at least.
 > >
 > 
 > It was recently introduced by my commit and used to catch data loss at truncate.
 > 
 > Were you running the test with a mkfs.btrfs -O NO_HOLES?
 > (We just queued a fix for the NO_HOLES case in btrfs-next.)

No, a fs created with default mkfs.btrfs options.

	Dave

