Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752991AbdC0MoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 08:44:03 -0400
Date: Mon, 27 Mar 2017 14:26:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris <coderight@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs clean is incomplete
Message-ID: <20170327122656.GC4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPaFLLTyWSkUOFTAhmfYMPEqWfCx7SxVNvhaHw9XwqD=NeGtEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPaFLLTyWSkUOFTAhmfYMPEqWfCx7SxVNvhaHw9XwqD=NeGtEg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 26, 2017 at 09:58:21AM -0400, Chris wrote:
> "make clean-all" leaves generated files under the "kernel-shared" directory.
> 
> This causes problems when trying to build under the same tree when the
> absolute path changes.
> 
> For example if you mount the source tree in one location,
> generate/build, then mount it in a different location, clean-all,
> re-build, and an error appears. "No rule to make target
> '.../kerncompat.h', needed by 'kernel-shared/ulist.o'.  Stop."  This
> happens because the "kernel-shared/ulist.o.d" file was not cleaned and
> lists an incorrect path.

Thanks for the report, Qu sent a patch, now in the devel branch.
