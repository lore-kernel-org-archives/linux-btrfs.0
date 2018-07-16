Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728284AbeGPQrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 12:47:12 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F312AD5E
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 16:19:04 +0000 (UTC)
Date: Mon, 16 Jul 2018 18:18:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: tests/fuzz: Use correct suffix for raw image
Message-ID: <20180716161858.GP3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180705054124.12137-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180705054124.12137-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2018 at 01:41:24PM +0800, Qu Wenruo wrote:
> * Please fold this patch into original commit in devel branch *
> 
> It's raw image, so it should be ".raw.xz" not ".img.xz"

Ah right, thanks, commit updated.
