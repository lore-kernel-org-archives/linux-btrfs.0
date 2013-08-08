Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3HHMOA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 08:14:00 -0400
Date: Thu, 8 Aug 2013 05:13:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.de>,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130808121349.GC5180@infradead.org>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
 <20130807205146.GE2397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130807205146.GE2397@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 04:51:46PM -0400, Josef Bacik wrote:
> Not possible, this will break other things as subvolumes have their own inode
> space, it will confuse applications that get multiples of an inode number for
> different devices with the same st_dev.  Each subvolume has it's own anonymous
> dev to segregate things.  Thanks,

Yes, it's the same old issue of btrfs volumes misbehaving, and the
solution is still the same as 5 years ago: make sure each subvolume
has it's own sb, vfsmount and gets automounted, similar to what nfs4
does for this case.
