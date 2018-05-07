Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45559 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbeEGO5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 10:57:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 56CE0AE91
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 14:57:05 +0000 (UTC)
Date: Mon, 7 May 2018 16:54:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove devid parameter from btrfs_rmap_block
Message-ID: <20180507145425.GA6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525420385-19112-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525420385-19112-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2018 at 10:53:05AM +0300, Nikolay Borisov wrote:
> This function is used in only one place and devid argument is always
> passed 0. So just remove it, similarly to how it was removed in the
> userspace code.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
