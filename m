Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaIKB3Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 21:29:16 -0400
Date: Wed, 10 Sep 2014 18:29:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Samer Al-Kiswany <samera@ece.ubc.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mkdir and fsync
Message-ID: <20140911012915.GA17887@infradead.org>
References: <BAY168-DS1747B8D83FA04E0D49D89AC1CF0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BAY168-DS1747B8D83FA04E0D49D89AC1CF0@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 10, 2014 at 01:55:35PM -0700, Samer Al-Kiswany wrote:
> Btrfs seems to achieve around 100k fsycs/second, which makes me believe it
> is not touching the disk during these fsyncs.
> After looking at the code, it seems indeed that fsync adds the inode to the
> current transaction but does not sync the transaction to disk.
> 
> Is this the intended behavior for metadata fsync or is this a bug?
> Is this POSIX compliant?

Posix is basically meaningless for fsync:

    The fsync() function shall request that all data for the open file
    descriptor named by fildes is to be transferred to the storage
    device associated with the file described by fildes. The nature of
    the transfer is implementation-defined. The fsync() function shall
    not return until the system has completed that action or until an
    error is detected.

    [SIO] [Option Start] If _POSIX_SYNCHRONIZED_IO is defined, the
    fsync() function shall force all currently queued I/O operations
    associated with the file indicated by file descriptor fildes to
    the synchronized I/O completion state. All I/O operations shall
    be completed as defined for synchronized I/O file integrity
    completion. [Option End]

but Linux semantics do expect a filesystem to write out all metadata for
a directory file descriptor on a fsync.
