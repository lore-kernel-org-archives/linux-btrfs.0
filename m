Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41947 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbeCNPpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:45:12 -0400
Date: Wed, 14 Mar 2018 16:42:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] Btrfs: drop a VLA in btrfs_check_super_csum()
Message-ID: <20180314154248.GL32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520970622-19535-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520970622-19535-1-git-send-email-s.mesoraca16@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 08:50:22PM +0100, Salvatore Mesoraca wrote:
> Avoid a VLA[1] by using a real constant expression instead of a variable.
> The compiler should be able to optimize the original code and avoid using
> an actual VLA. Anyway this change is useful because it will avoid a false
> positive with -Wvla, it might also help the compiler generating better
> code.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

We already have a patch for that from a few days ago, but thanks anyway.

https://patchwork.kernel.org/patch/10277901/
