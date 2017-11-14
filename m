Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752752AbdKNOwV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 09:52:21 -0500
Date: Tue, 14 Nov 2017 15:50:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, torvalds@linux-foundation.org, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs changes for 4.15
Message-ID: <20171114145026.GE28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1510586794.git.dsterba@suse.com>
 <abc907f7-b4de-c999-95cd-b241589a5305@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <abc907f7-b4de-c999-95cd-b241589a5305@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 07:39:11AM +0800, Qu Wenruo wrote:
> > - extend mount options to specify zlib compression level, -o compress=zlib:9
> 
> However the support for it has a big problem, it will cause wild memory
> access for "-o compress" mount option.
> 
> Kernel ASAN can detect it easily and we already have user report about
> it. Btrfs/026 could also easily trigger it.
> 
> The fixing patch is submitted some days ago:
> https://patchwork.kernel.org/patch/10042553/
> 
> And the default compression level when not specified is zero, which
> means no compression but directly memory copy.

This fix will go in next pull request. Thanks.
