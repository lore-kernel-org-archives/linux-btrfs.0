Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754885AbdKNSz0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 13:55:26 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 035C2AB02
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 18:55:25 +0000 (UTC)
Date: Tue, 14 Nov 2017 19:53:31 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Read before you deploy btrfs + zstd
Message-ID: <20171114185331.GJ28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171113225046.GD28899@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171113225046.GD28899@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 13, 2017 at 11:50:46PM +0100, David Sterba wrote:
> Up to now, there are no bootloaders supporting ZSTD.

I've tried to implement the support to GRUB, still incomplete and hacky
but most of the code is there.  The ZSTD implementation is copied from
kernel. The allocators need to be properly set up, as it needs to use
grub_malloc/grub_free for the workspace thats called from some ZSTD_*
functions.

https://github.com/kdave/grub/tree/btrfs-zstd
