Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750846AbdE2Rkc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 13:40:32 -0400
Date: Mon, 29 May 2017 19:39:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, hurikhan77@gmail.com
Subject: Re: [PATCH 2/5] btrfs-progs: Enhance chunk item validation check
Message-ID: <20170529173931.GT14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
 <20170515082742.21363-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170515082742.21363-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 15, 2017 at 04:27:39PM +0800, Qu Wenruo wrote:
> btrfs_check_chunk_valid() doesn't check if
> 1) chunk flag has conflicting flags
>    For example chunk type DATA|METADATA|RAID1|RAID10 is completely
>    invalid, while current check_chunk_valid() can't detect it.
> 2) num_stripes is invalid for RAID10
>    Num_stripes 5 is not valid for RAID10.
> 
> This patch will enhance btrfs_check_chunk_valid() to handle above cases.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Most tests fail with this patch, mkfs or from restored images created.
Simple test-check or test-misc fails in the first test. Have I missed
some other patch or test update?
