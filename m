Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752943AbeBLSY7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 13:24:59 -0500
Date: Mon, 12 Feb 2018 19:22:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][btrfs-next] Btrfs: extent map selftest: fix non-ANSI
 btrfs_test_extent_map declaration
Message-ID: <20180212182242.GP3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180208141327.10951-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180208141327.10951-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 08, 2018 at 02:13:27PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The function btrfs_test_extent_map requires a void argument to be ANSI C
> compliant and so it matches the prototype in fs/btrfs/tests/btrfs-tests.h
> 
> Cleans up sparse warning:
> fs/btrfs/tests/extent-map-tests.c:346:27: warning: non-ANSI function
> declaration of function 'btrfs_test_extent_map'
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

FYI, the first patch fixing the warning has been added to for-next
already.
