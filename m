Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaH2Ovb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 10:51:31 -0400
Date: Fri, 29 Aug 2014 07:51:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash while a ranged msync() is ongoing
Message-ID: <20140829145130.GA14038@infradead.org>
References: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 29, 2014 at 01:37:48PM +0100, Filipe Manana wrote:
> After the commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8 (titled
> "mm/msync.c: sync only the requested range in msync()"), our fsync
> callback can be called with a range that covers only part of the
> file and not the whole file anymore.

Not that there have been other users of range fsyncs around for a long
time.  The SCSI target code is one, the NFS server another, and last but
not least generic_write_sync() which is used by most filesystems
including btrfs to implement O_SYNC writes.
