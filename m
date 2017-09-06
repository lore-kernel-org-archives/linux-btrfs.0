Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932823AbdIFPi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 11:38:57 -0400
Date: Wed, 6 Sep 2017 17:37:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 5/7] Btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
Message-ID: <20170906153728.GW31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1503470354.git.osandov@fb.com>
 <433d5c3c5a47154a8bead243a9f6e0c8b3b7ad7d.1503470354.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <433d5c3c5a47154a8bead243a9f6e0c8b3b7ad7d.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:46:03PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> A naked read of the value of an RCU pointer isn't safe. Put the whole
> access in an RCU critical section, not just the pointer dereference.

In this case it is safe, as the device will not go away (and potentially
free dev->name) because it's under the device_list_mutex.

The locking around devices and related structures is not exactly
straightforward, but here I don't think we need to stick to the RCU
pattern if the protection is guaranteed by other means. This applies to
uuid_mutex and device_list_mutex.
