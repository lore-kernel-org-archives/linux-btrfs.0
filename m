Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752043AbcH2Q3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 12:29:19 -0400
Date: Mon, 29 Aug 2016 18:28:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix chunk num_stripes FPE error found by fuzzed image
Message-ID: <20160829162800.GX16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 29, 2016 at 04:08:58PM +0800, Qu Wenruo wrote:
> This patchset will fix chunk num_stripes FPE error, by introducing another 2
> layers of check.
> 
> 1) Check key type validation against leaf owner(for original mode)
>    This will prevent invalid key, like CHUNK_ITEM key in root tree, to be
>    passed to later check.
> 
>    For original mode, it uses leaf's owner as standard.
>    For low memory mode, it will use root->objectid(while not in devel
>    branch yet)
> 
>    This is an extra early check layer, which could benefit other part.
> 
> 2) Check chunk item again before processing it
>    This is the root fix, as final defense for chunk item.
>    This check itself can already fix the problem.
>    But 1) can give more info on which is really going wrong in the fs.
> 
> Thanks for Lukas for his fuzzed images and report.

Thans for the testing and fixes. Can you please also add the images to
tests/fuzz-tests/images ?

