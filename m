Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56087 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932116AbeE1RAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 13:00:46 -0400
Date: Mon, 28 May 2018 18:57:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: kill btrfs_write_inode
Message-ID: <20180528165759.GH6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180522174723.13620-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522174723.13620-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 01:47:22PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We don't actually need this.  It used to be in place for O_SYNC writes,
> but we've used the normal fsync() path for that for years now.  The
> other case we hit this is through sync(), which will commit the
> transaction anyway.  All this does is make us commit the transaction a
> bunch for no reason, and it could deadlock with delayed iput's.

In what way does it deadlock with delayed iput?
