Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758503AbeD1RNP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 13:13:15 -0400
Date: Sat, 28 Apr 2018 19:10:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Noah Massey <noah.massey@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
Message-ID: <20180428171039.GK21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426192351.473-1-jeffm@suse.com>
 <20180427155608.GC21272@twin.jikos.cz>
 <CADfjVrh0NozrDu=tzAS+pgksrZOzt2QxXYV_vOOo8csXpzkf-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADfjVrh0NozrDu=tzAS+pgksrZOzt2QxXYV_vOOo8csXpzkf-Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 03:28:44PM -0400, Noah Massey wrote:
> On Fri, Apr 27, 2018 at 11:56 AM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Apr 26, 2018 at 03:23:49PM -0400, jeffm@suse.com wrote:
> >> From: Jeff Mahoney <jeffm@suse.com>
> >>
> >> Commit d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
...
> >>
> >> Fixes: d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
> >> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> >
> > I've added this to misc-next as I'd like to push it to the next rc. The
> > Fixes is fixed.
> >
> 
> I don't see it pushed to misc-next yet, but based on f89fbcd776, could
> you update the reference in the first line of the commit to match the
> Fixes line?

Fixed, thanks for the notice.
