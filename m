Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425204AbeE1Pxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:53:49 -0400
Date: Mon, 28 May 2018 15:29:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v4 3/6] Btrfs: push EXCL_OP set into btrfs_rm_device()
Message-ID: <20180528132955.GX6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527197312.git.osandov@fb.com>
 <d87c19f340768141b564cec3af1deda6e921eaa5.1527197312.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d87c19f340768141b564cec3af1deda6e921eaa5.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 24, 2018 at 02:41:27PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_ioctl_rm_dev() and btrfs_ioctl_rm_dev_v2() both manipulate this
> bit. Let's move it into the common btrfs_rm_device(), which also makes
> the following change to deal with swap files easier.

I'd rather keep it in both places as it's clear where the EXCL_OP
context starts in the ioctl handlers, not in some helper function.
