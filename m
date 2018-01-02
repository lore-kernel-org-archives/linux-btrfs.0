Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59412 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbeABPyi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 10:54:38 -0500
Date: Tue, 2 Jan 2018 16:52:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: remove unused label 'retry'
Message-ID: <20180102155231.GT3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171222005508.11975-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171222005508.11975-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 22, 2017 at 12:55:08AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Label 'retry' is not used, remove it. Cleans up a clang build
> warning:
> 
> warning: label ‘retry’ defined but not used [-Wunused-label]
> 
> Fixes: b283738ab0ad ("Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, we already have another patch to fix that in for-next.
