Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728873AbeHNNcq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 09:32:46 -0400
Date: Tue, 14 Aug 2018 12:46:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove duplicated btrfs_release_path in
 btrfs_unlink_subvol
Message-ID: <20180814104600.GE24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534214829-26202-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534214829-26202-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2018 at 10:47:09AM +0800, Liu Bo wrote:
> The btrfs_release_path() is just useless as path is only used in error handling.

Where is it duplicated? And I don't think it's useless, while the
changelog does not explain why and it's not obvious from the context. If
the path is locked, then releasing it right after it's not needed makes
sense.  There are several potentially heavyweight operations between the
release and final free.
