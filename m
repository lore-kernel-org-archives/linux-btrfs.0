Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46533 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751991AbdGSQsM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 12:48:12 -0400
Date: Wed, 19 Jul 2017 18:46:55 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix dir item validation when replaying xattr
 deletes
Message-ID: <20170719164655.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170718193402.11810-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170718193402.11810-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 18, 2017 at 08:34:02PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were passing an incorrect slot number to the function that validates
> directory items when we are replaying xattr deletes from a log tree. The
> correct slot is stored at variable 'i' and not at 'path->slots[0]', so
> the call to the validation function was only correct for the first
> iteration of the loop, when 'i == path->slots[0]'.
> After this fix, the fstest generic/066 passes again.

Thanks. Fixing this was last on my list of known issue caused by some of
the new 4.13 patches.

Reviewed-by: David Sterba <dsterba@suse.com>
