Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754811AbeD3RLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 13:11:00 -0400
Date: Mon, 30 Apr 2018 19:08:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: rename btrfs_balance_control::flags to b_flags
Message-ID: <20180430170824.GO21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430094913.26309-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430094913.26309-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 05:49:13PM +0800, Anand Jain wrote:
> As flags is a generic name, its often difficult to search, rename
> btrfs_balance_control::flags to btrfs_balance_control::b_flags.

I don't think this one is necessary as it's always tied to bctl.
