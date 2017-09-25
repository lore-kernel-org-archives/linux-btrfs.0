Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55565 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934361AbdIYOoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:44:09 -0400
Date: Mon, 25 Sep 2017 16:42:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH][v2] btrfs: change how we decide to commit transactions
 during flushing
Message-ID: <20170925144235.GH31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503432039-7666-1-git-send-email-jbacik@fb.com>
 <703e4090-1bd7-afd7-ecb6-a4f07047d823@suse.com>
 <cfc2e650-b161-1cc2-1b8b-831f1acf282c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cfc2e650-b161-1cc2-1b8b-831f1acf282c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 11:32:21AM +0300, Nikolay Borisov wrote:
> 
> 
> On 24.08.2017 17:43, Nikolay Borisov wrote:
> > 
> > 
> > On 22.08.2017 23:00, josef@toxicpanda.com wrote:
> >> From: Josef Bacik <jbacik@fb.com>
> >>
> >> Nikolay reported that generic/273 was failing currently with ENOSPC.
> >> Turns out this is because we get to the point where the outstanding
> >> reservations are greater than the pinned space on the fs.  This is a
> >> mistake, previously we used the current reservation amount in
> >> may_commit_transaction, not the entire outstanding reservation amount.
> >> Fix this to find the minimum byte size needed to make progress in
> >> flushing, and pass that into may_commit_transaction.  From there we can
> >> make a smarter decision on whether to commit the transaction or not.
> >> This fixes the failure in generic/273.
> >>
> >> Reported-by: Nikolay Borisov <nborisov@suse.com>
> >> Signed-off-by: Josef Bacik <jbacik@fb.com>
> > 
> > Reviewed-and-tested-by: Nikolay Borisov <nborisov@suse.com>
> 
> 
> For this commit we might also add:
> 
> Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc infrastructure")
> Cc: stable@vger.kernel.org # 4.8

JFI, tags added plus some additional explanation from N.
