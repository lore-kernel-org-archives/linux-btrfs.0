Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933269AbeGDMIy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 08:08:54 -0400
Date: Wed, 4 Jul 2018 14:08:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: Update man 5 btrfs for 4.18
Message-ID: <20180704120850.GO3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1530681903.git.misono.tomohiro@jp.fujitsu.com>
 <885cfb4fb56ecbacc60b2d8c05785e3fdc4c6a56.1530681903.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <885cfb4fb56ecbacc60b2d8c05785e3fdc4c6a56.1530681903.git.misono.tomohiro@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 02:31:20PM +0900, Misono Tomohiro wrote:
> Update the information to reflect the status of 4.18
> 
> Main Updates:
> - Add explanation of improved compression heuristic algorithm
> - Add explanation that norecovery == nologreplay
> - Add explanation of nossd_spread mount option
> - Add explanation of rmdir_subovl feature
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Applied, thanks.
