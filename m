Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934095AbeEIKXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 06:23:51 -0400
Date: Wed, 9 May 2018 12:21:11 +0200
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs :incremental send, improve rmdir performance
Message-ID: <20180509102110.GP6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525774298-6919-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525774298-6919-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 06:11:36PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> The following patch is to improve the btrfs send, the speed of large
> directory deletion.
> 
> 1. Optimization, avoid unnecessary allocations.
> 
> 2. Increase the speed of can_rmdir.
> 
> Robbie Ko (2):
>   btrfs: incremental send, optimization add orphan_dir_info
>   btrfs: incremental send, improve rmdir performance for large directory

Added to next, thanks. I've updated the changelogs a bit.
