Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46911 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbcKPQSI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 11:18:08 -0500
Date: Wed, 16 Nov 2016 17:18:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>,
        linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Subject: Re: [PATCH] Fs: Btrfs - Improvement in code readability when
Message-ID: <20161116161802.GV12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1478771261-1020-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478771261-1020-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 03:17:41PM +0530, Shailendra Verma wrote:
> From: "Shailendra Verma" <shailendra.v@samsung.com>
> 
> There is no need to call kfree() if memdup_user() fails, as no memory
> was allocated and the error in the error-valued pointer should be returned.
> 
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Queued for 4.10, I've edited the subject line as it's very descriptive.
("btrfs: return early from failed memory allocations in ioctl handlers")
