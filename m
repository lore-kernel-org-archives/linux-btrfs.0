Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab3BHOxK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 09:53:10 -0500
Date: Fri, 8 Feb 2013 15:53:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
Message-ID: <20130208145307.GF12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
 <20130208002854.GA1575@twin.jikos.cz>
 <CAKcLGm_z+bMYtBZYvQYRXrPVHxEfrnfaVNPo8=qeKb3JSUOgiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm_z+bMYtBZYvQYRXrPVHxEfrnfaVNPo8=qeKb3JSUOgiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 11:17:46PM -0600, Mitch Harder wrote:
> On Thu, Feb 7, 2013 at 6:28 PM, David Sterba <dave@jikos.cz> wrote:
> > On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
> >> --- a/fs/btrfs/relocation.c
> >> +++ b/fs/btrfs/relocation.c
> >> @@ -144,7 +144,7 @@ struct tree_block {
> >>       unsigned int key_ready:1;
> >>  };
> >>
> >> -#define MAX_EXTENTS 128
> >> +#define MAX_EXTENTS 512
> >
> > Is this really related to compression? IIRC I've seen it only in context
> > of batch work in reloc, but not anywhere near compression. (I may be
> > wrong of course, just checking).
> >
> 
> When you defragment compressed extents, it will run through relocation.
>
> If autodefrag is enabled, I found most everything I touched was
> running through relocation.

AFAIK defragmentation runs through the writeback loop, blocks are marked
dirty, delalloc tries to make them contiguous and then synced back to
disk. Autodefrag uses the same loop, just affects newly written data.

> It has been a while since I looked at the issue, but I think balancing
> your data will also run through relocation.

Balance does go through reloc for sure.

>From the commit that introduces MAX_EXTENTS it's imo quite clear that
it's only a balance speedup:

(0257bb82d21bedff26541bcf12f1461c23f9ed61)
Btrfs: relocate file extents in clusters

The extent relocation code copy file extents one by one when
relocating data block group. This is inefficient if file
extents are small. This patch makes the relocation code copy
file extents in clusters. So we can can make better use of
read-ahead.
---

david
