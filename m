Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab3E0PcW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 11:32:22 -0400
Date: Mon, 27 May 2013 17:32:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Add missing free() against
 fs_info->super_copy
Message-ID: <20130527153220.GD28422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1369491399-6769-1-git-send-email-fdmanana@gmail.com>
 <1369491399-6769-2-git-send-email-fdmanana@gmail.com>
 <20130527121247.GC28422@twin.jikos.cz>
 <CAL3q7H7qC6iFZ4TSX5Cr2YuCC+sCKTBqcWt+fNnHWgnHjayBjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7qC6iFZ4TSX5Cr2YuCC+sCKTBqcWt+fNnHWgnHjayBjA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 27, 2013 at 01:31:13PM +0100, Filipe David Manana wrote:
> Right. Just thought it was better to check if the calloc() for fs_info
> succeeded before derreferencing it for free'ing its super_copy member
> (the function's code doesn't check if any of the malloc() / calloc()
> calls returned non-NULL, so it wouldn't be inconsistent with the
> existing code)

Sorry, I've read it too quickly, the check has to be there of course.

> >>       free(fs_info);
> >>       return NULL;
> >
> > otherwise ok. Thanks.
> 
> Thanks for review and advise.
> Do you need more action from my side?

No.

david
