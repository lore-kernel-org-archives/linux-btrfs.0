Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388086AbeGWO00 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:26:26 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CAB3AD64
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 13:25:10 +0000 (UTC)
Date: Mon, 23 Jul 2018 15:25:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] fs_info cleanups for volume.c
Message-ID: <20180723132501.GL26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 07:37:46PM +0300, Nikolay Borisov wrote:
> Here are a bunch of patches which cleanup extraneous fs_info parameters to 
> function which already take a structure that holds a reference to the fs_info. 
> 
> Except for patches 4 and 5, everything else is correct - due to those functions
> always taking a transaction. 4 and 5 in turn reference the fs_info from 
> struct btrfs_device. Inspecting the callers I managed to convince myself that 
> those function are always called with well-formed btrfs_device i.e one which 
> has its fs_info member initialised. Reviewers might want to pay extra 
> attention to that but otherwise they are trivial. 

4 and 5 look good to me, a device without a valid fs_info has a short
timespan and should not appear anywhere besides the helpers that set up
fs_devices etc. Series added to misc-next, thanks.
