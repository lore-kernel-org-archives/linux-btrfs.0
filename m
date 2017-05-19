Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48726 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdESAqW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:46:22 -0400
Date: Thu, 18 May 2017 17:43:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/10] btrfs: scrub: use fs_info::sectorsize and drop it
 from scrub context
Message-ID: <20170519004338.GL23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1494954480.git.dsterba@suse.com>
 <4a48588c77c94dd0ce696732cf7e5476217f0204.1494954480.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a48588c77c94dd0ce696732cf7e5476217f0204.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 07:10:41PM +0200, David Sterba wrote:
> As we now have the node/block sizes in fs_info, we can use them and can
> drop the local copies.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
