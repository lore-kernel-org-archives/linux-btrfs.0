Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28718 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752920AbdESAUY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:20:24 -0400
Date: Thu, 18 May 2017 17:18:31 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: test for restoring multiple devices fs
 into a single device
Message-ID: <20170519001830.GH23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170517014131.8549-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517014131.8549-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 02:41:31AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that we are able to create an image from a multiple devices fs, that
> we are able to restore that image into a single device and finally that we
> are able to mount it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
