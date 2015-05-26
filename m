Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbbEZP0O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 11:26:14 -0400
Date: Tue, 26 May 2015 17:26:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix a bug which makes unfinished fsid
 change unrecoverable.
Message-ID: <20150526152612.GM23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431671795-30516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431671795-30516-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 15, 2015 at 02:36:35PM +0800, Qu Wenruo wrote:
> This bug is found by making break point after change_fsid_prepare() and
> then kill the unfinished change, then try to restore the unfinished fsid
> change.
> 
> If fsid change is canceled, open_ctree will still fail even with
> IGNORE_FSID_MIMATCH open ctree flag, since it can't find device with
> mismatched fsid, making it unable to restoring.
> 
> Now add ignore_fsid_mismatch judgment in btrfs_find_device() to fix the
> bug and allow later restore to work as expected.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
