Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753244AbeDQRu1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 13:50:27 -0400
Date: Tue, 17 Apr 2018 19:47:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/16] btrfs: remove redundant read-only check from
 btrfs_cancel_balance
Message-ID: <20180417174755.GJ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522780026.git.dsterba@suse.com>
 <afdb0e99249c050b26a200ccbbc772a1ef90c1a4.1522780026.git.dsterba@suse.com>
 <8f34dff3-63e6-4ad6-115a-57959ede2124@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8f34dff3-63e6-4ad6-115a-57959ede2124@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 05:43:46PM +0800, Anand Jain wrote:
> On 04/04/2018 02:34 AM, David Sterba wrote:
> > Balance cannot be started on a read-only filesystem and will have to
> > finish/exit before eg. going to read-only via remount. Cancelling does
> > not need to check for that.
> > 
> > In case the filesystem is forcibly set to read-only after an error,
> > balance will finish anyway and if the cancel call is too fast it will
> > just wait for that to happen. Again does not have to check.
> 
>   What if there is a power recycle and mounted as readonly
>   after the reboot?

So the balance item would be stored on disk from previous run, mount
will set it up but balance will not be resumed (sb_rdonly check in
open_ctree happens earlier).

Calling btrfs_cancel_balance by ioctl would reset the in-memory state
and also would want to delete the balance item on disk, so yes, the
check is needed.

I'll add a comment explaining why the read-only check is there instead.
Thanks for catching it.
