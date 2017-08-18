Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45446 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750967AbdHRPWR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 11:22:17 -0400
Date: Fri, 18 Aug 2017 17:20:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [RESEND PATCH] btrfs-progs: Specify C standard to gnu90
 explicitly
Message-ID: <20170818152053.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170815001712.6710-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170815001712.6710-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 15, 2017 at 09:17:12AM +0900, Qu Wenruo wrote:
> Different C compilers have different default language standard.
> This sometimes causes problem on different system.
> 
> For distribution like CentOS/RHEL7, its gcc is still 4.8 and will report
> error for c90 style declaration, while most developers are using newer
> gcc which will just ignore it.
> This makes us hard to detect such language standard problem.
> 
> This patch will specify standard to gnu90 explicitly to avoid such problem.
> Gnu90 is a good mix of c90 while provide a lot of useful gnu extension,
> and is supported by all modern gcc and clang.
> 
> Reported-by: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Applied, thanks.
