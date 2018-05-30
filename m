Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35395 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932099AbeE3QL2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 12:11:28 -0400
Date: Wed, 30 May 2018 18:08:43 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        David Sterba <dsterba@suse.com>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Remove VLA usage
Message-ID: <20180530160843.GG3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180529234459.GA15302@beast>
 <20180530151455.GE3539@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180530151455.GE3539@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2018 at 05:14:56PM +0200, David Sterba wrote:
> On Tue, May 29, 2018 at 04:44:59PM -0700, Kees Cook wrote:
> > In the quest to remove all stack VLA usage from the kernel[1], this
> > allocates the working buffers during regular init, instead of using stack
> > space. This refactors the allocation code a bit to make it easier
> > to review.
> > 
> > [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

For the record, so this was the last use of VLA in fs/btrfs/ .
