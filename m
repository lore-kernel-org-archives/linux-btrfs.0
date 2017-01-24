Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdAXPSa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 10:18:30 -0500
Date: Tue, 24 Jan 2017 16:18:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Introduce kernel sizes to cleanup large
 intermediate number
Message-ID: <20170124151800.GV11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170124030306.3452-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170124030306.3452-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 11:03:05AM +0800, Qu Wenruo wrote:
> Large numbers like (1024 * 1024 * 1024) may cost reader/reviewer to
> waste one second to convert to 1G.
> 
> Introduce kernel include/linux/sizes.h to replace any intermediate
> number larger than 4096 (not including 4096) to SZ_*.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied thanks. Changes are everywhere but fairly easy to sort out
during merges.
