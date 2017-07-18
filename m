Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52380 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751560AbdGRPGt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:06:49 -0400
Date: Tue, 18 Jul 2017 17:05:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: btrfs_inherit_iflags() can be static
Message-ID: <20170718150533.GU2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170718093705.18901-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170718093705.18901-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 18, 2017 at 05:37:05PM +0800, Anand Jain wrote:
> btrfs_new_inode() is the only consumer move it to inode.c,
> from ioctl.c.

Yes, moving the functions out of ioctl.c is ok.

Reviewed-by: David Sterba <dsterba@suse.com>
