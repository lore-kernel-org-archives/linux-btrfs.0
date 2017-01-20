Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbdATSVz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 13:21:55 -0500
Date: Fri, 20 Jan 2017 19:21:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: lowmem-check: Fix false alert on dropped
 leaf
Message-ID: <20170120182137.GF11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170118052107.7394-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170118052107.7394-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2017 at 01:21:07PM +0800, Qu Wenruo wrote:
> For btrfs-progs test case 021-partially-dropped-snapshot-case, if the
> first leaf is already dropped, btrfs check low-memory mode will report
> false alert:
> 
> checking fs roots
> checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
> checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
> checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
> checksum verify failed on 29917184 found E4E3BDB6 wanted 00000000
> 
> This is caused by we are calling check_fs_first_inode() function,
> unlike the rest part of check_fs_root_v2(), it doesn't have enough check
> on dropping progress, and caused the false alert.
> 
> Fix it by checking dropping progress before searching slot.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
