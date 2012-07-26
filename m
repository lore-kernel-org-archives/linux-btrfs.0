Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42333 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2GZVKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 17:10:07 -0400
Date: Thu, 26 Jul 2012 23:09:59 +0200
From: David Sterba <dave@jikos.cz>
To: cbay@alwaysdata.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: mkfs devices ordering relevant with devices of different sizes?
Message-ID: <20120726210959.GK17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <juos5r$2tp$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <juos5r$2tp$1@dough.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2012 at 03:26:20PM +0200, Cyril B.  wrote:
> When creating a filesystem with devices of different sizes, the resulting 
> filesystem total size depends on the device order specified to mkfs. When 
> the smaller device is specified first, the second (larger) device is seen as 
> the same size as the first. This doesn't occur when the order is reversed.
> 
> It's confusing. Is this expected? I'm using the latest btrfs-progs and Linux 
> 3.5.

Confusing it is, caused by this commit

Author:     Josef Bacik <josef@redhat.com>
AuthorDate: Wed Mar 28 14:20:52 2012 -0400
Commit:     Chris Mason <chris.mason@fusionio.com>
CommitDate: Tue Jul 3 16:27:46 2012 -0400

    btrfs-progs: enforce block count on all devices in mkfs

    I had a test that creates a 7gig raid1 device but it was ending up wonky
    because the second device that gets added is the full size of the disk
    instead of the limited size.  So enforce the limited size on all disks
    passed in at mkfs time, otherwise our threshold calculations end up wonky
    when doing chunk allocations.  Thanks,
---


david
