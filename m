Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaBYRve (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:51:34 -0500
Date: Tue, 25 Feb 2014 18:51:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140225175133.GB16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1393242525-18587-1-git-send-email-Anand.Jain@oracle.com>
 <1393242525-18587-2-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393242525-18587-2-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 07:48:45PM +0800, Anand Jain wrote:
> The user land progs needs   a simple way to see
> the raw list of disks and its parameters as seen
> by the btrfs kernel.
> As of now btrfs-devlist uses this ioctl.

As discussed before together with Hugo, the ioctl could exist parallel
to sysfs export of the device data. From that point it's easier to
maintain and update a set of sysfs files than an ioctl. The way you
suggest it right now lacks future-proof extensibility and backward
compatibility handling.

The userspace code is said to be a small and debug program, the sysfs
would IMHO satsify it needs as well, so I suggest not to continue on the
ioctl approach.
