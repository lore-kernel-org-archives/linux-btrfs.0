Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab3HHNsL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 09:48:11 -0400
Date: Thu, 8 Aug 2013 06:48:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.de>,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130808134805.GB24181@infradead.org>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
 <20130807205146.GE2397@localhost.localdomain>
 <20130808121349.GC5180@infradead.org>
 <20130808130207.GA16712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130808130207.GA16712@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 09:02:07AM -0400, Josef Bacik wrote:
> This won't work, try having 10000 subvolumes with dirty inodes and do sync then
> go skiing, you'll have time :).  Thanks,

Why would the dirty inodes make any difference?  If you share the bdi
between the subvolumes the sync workflow should be exactly the same
still.

