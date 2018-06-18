Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54453 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755301AbeFRLJH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:09:07 -0400
Date: Mon, 18 Jun 2018 13:06:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: sync log after logging new name
Message-ID: <20180618110616.GI24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180611182428.18102-1-fdmanana@kernel.org>
 <20180615155428.GG24375@twin.jikos.cz>
 <CAL3q7H641LmbUYgg_0n+1rS6KRScgZh9UjMSauCVCMNLJPnVdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H641LmbUYgg_0n+1rS6KRScgZh9UjMSauCVCMNLJPnVdw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2018 at 05:19:07PM +0100, Filipe Manana wrote:
> On Fri, Jun 15, 2018 at 4:54 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Mon, Jun 11, 2018 at 07:24:28PM +0100, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >> Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
> >> Reported-by: Vijay Chidambaram <vvijay03@gmail.com>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >
> > There are some warnings and possible lock up caused by this patch, the
> > 1/2 alone is ok but 1/2 + 2/2 leads to the following warnings. I checked
> > twice, the patch base was the pull request ie. without any other 4.18
> > stuff.
> 
> Are you sure it's this patch?
> On top of for-4.18 it didn't cause any problems here, plus the trace
> below has nothing to do with renames, hard links or fsync at all -
> everything seems stuck on waiting for IO from dev replace.

It was a false alert, sorry. Strange that the warnings appeared only in
the VM running both patches and not otherwise.

Though the test did not directly use rename, the possible error scenario
I had in mind was some leftover from locking, error handling or state
that blocked umount of 011.
