Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53150 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589Ab3AHSZo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 13:25:44 -0500
Date: Tue, 8 Jan 2013 13:25:41 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1
 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130108182541.GE2389@localhost.localdomain>
References: <20130108164958.GA2044@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130108164958.GA2044@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 09:49:58AM -0700, Marc MERLIN wrote:
> Unfortunately my laptop deadlocks from time to time, and too often
> it triggers this bug in btrfs which is quite hard to recover from.
> 

You are getting bad tree blocks which really isn't the tree logs fault.  Can you
scrub your file system and make sure there's not some sort of latent issue going
on?  And if you have problems again please try btrfs-next as I've fixed a few
log replay bugs recently.  Thanks,

Josef
