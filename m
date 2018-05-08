Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49427 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751806AbeEHRrw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 13:47:52 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 66A48AD2E
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 17:47:51 +0000 (UTC)
Date: Tue, 8 May 2018 19:45:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error
 for qgroup mismatch
Message-ID: <20180508174513.GO6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430061700.18498-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430061700.18498-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 02:16:59PM +0800, Qu Wenruo wrote:
> Current btrfs-check will check qgroup consistency, but even when it
> finds something wrong, the return value is still 0.
> 
> Fix it by allowing report_qgroups() to return int to indicate qgroup
> mismatch, and also add extra logical to return no error if qgroup repair
> is successful.
> 
> Without this patch, fstests can't detect qgroup corruption by its fsck
> alone.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks. Please send the 0/N (cover letter) mail even for
2-patch series.
