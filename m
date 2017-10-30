Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbdJ3O7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 10:59:17 -0400
Date: Mon, 30 Oct 2017 15:57:26 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add support for fallocate's zero range
 operation
Message-ID: <20171030145726.GX3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171025125344.2111-1-fdmanana@kernel.org>
 <20171025145908.7311-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171025145908.7311-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 25, 2017 at 03:59:08PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This implements support the zero range operation of fallocate. For now
> at least it's as simple as possible while reusing most of the existing
> fallocate and hole punching infrastructure.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

I'll add this to for-next so we can more testing coverage, review is
open.
