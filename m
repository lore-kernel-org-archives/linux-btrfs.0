Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751701AbeE3PRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 11:17:41 -0400
Date: Wed, 30 May 2018 17:14:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Kees Cook <keescook@chromium.org>
Cc: David Sterba <dsterba@suse.com>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Remove VLA usage
Message-ID: <20180530151455.GE3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180529234459.GA15302@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529234459.GA15302@beast>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2018 at 04:44:59PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> allocates the working buffers during regular init, instead of using stack
> space. This refactors the allocation code a bit to make it easier
> to review.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: David Sterba <dsterba@suse.com>

Queued for 4.18, thanks.
