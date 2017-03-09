Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38145 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752672AbdCIMgx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 07:36:53 -0500
Date: Thu, 9 Mar 2017 13:35:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: remove unused delalloc_end parameter
Message-ID: <20170309123524.GC14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1488843167-8511-1-git-send-email-fdmanana@kernel.org>
 <20170307160517.GW4662@twin.jikos.cz>
 <CAL3q7H6XkdgUqjSUiz4jd4szxXe6UCM3Pm1oqhDmH9d0F9Bdng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6XkdgUqjSUiz4jd4szxXe6UCM3Pm1oqhDmH9d0F9Bdng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 06:35:02PM +0000, Filipe Manana wrote:
> On Tue, Mar 7, 2017 at 4:05 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Mon, Mar 06, 2017 at 11:32:47PM +0000, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> The delalloc_end parameter for extent_clear_unlock_delalloc() is never
> >> used, and only making the code for all callers longer and more complex.
> >> Just remove it.
> >
> > It's been added on purpose
> >
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=dda3245eca18c73413a854a834c41fc770feb0dd
> >
> > "btrfs: expand cow_file_range() to support in-band dedup and
> > subpage-blocksize"
> >
> > so we can merge both mentioned patchsets for testing.
> 
> I definitely missed that. To be honest I was finding it strange that
> none of the usual cleanup fanatics noticed it before.

I was disappointed for a minute that I couldn't remove it, you bet.

> Anyway I'm sending a v2 of the 2nd patch so that it works correctly on
> top of Qu's patchset that I reviewed recently. I've added Qu's patches
> to my 4.11 integration branch just so that I could work on top of
> them, feel free to pick stuff from there if convenient or ignore
> otherwise.

Let's keep it in your branch then.
