Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:37794 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727648AbeGTXwa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 19:52:30 -0400
Date: Fri, 20 Jul 2018 15:53:55 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Alexander Wetzel <alexander.wetzel@web.de>
cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
In-Reply-To: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
Message-ID: <alpine.DEB.2.21.999.1807201548500.2131@trent.utfs.org>
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 20 Jul 2018, Alexander Wetzel wrote:
> [  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080: errno=-5
> IO failure

Are there no other messages in syslog? "IO failure" (from 
fs/btrfs/super.c:75) sounds like a problem with the underlying device. 
Maybe try w/o the "discard" mount option? Does "cat /dev/sdc2 > /dev/null" 
complete w/o errors?

C.
-- 
BOFH excuse #184:

loop found in loop in redundant loopback
