Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934033AbeGDLzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 07:55:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 769D9AD24
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 11:55:09 +0000 (UTC)
Date: Wed, 4 Jul 2018 13:55:05 +0200
From: David Sterba <dsterba@suse.cz>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: add experimental flag for lowmem mode
Message-ID: <20180704115505.GM3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703114237.11053-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703114237.11053-1-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 01:42:37PM +0200, David Disseldorp wrote:
> The experimental flag is already carried in the manpage, but was removed
> from the btrfs check usage message as part of refactoring via
> 87c1bd13c1fca430c3dbf0da62e9aa33bde609c8. Add it back.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
