Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964888AbcJXPkv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 11:40:51 -0400
Date: Mon, 24 Oct 2016 17:40:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs: fix free space tree bitmaps on big-endian systems
Message-ID: <20161024154047.GC22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161015004633.EE40C660FC3@gitolite.kernel.org>
 <CAMuHMdVQPFaMYHaj7f3uyToH0ReCj0fRkjHCBbHsHZzwsC+3ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMuHMdVQPFaMYHaj7f3uyToH0ReCj0fRkjHCBbHsHZzwsC+3ZA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 09:23:04AM +0200, Geert Uytterhoeven wrote:
> On Sat, Oct 15, 2016 at 2:46 AM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
> > Web:        https://git.kernel.org/torvalds/c/2fe1d55134fce05c17ea118a2e37a4af771887bc
> > Commit:     2fe1d55134fce05c17ea118a2e37a4af771887bc
> 
> 520f16abf003952d in v4.7.10
> 1ff6341b5d92dd6b in v4.8.4
> 
> > Parent:     08895a8b6b06ed2323cd97a36ee40a116b3db8ed
> > Refname:    refs/heads/master
> > Author:     Omar Sandoval <osandov@fb.com>
> > AuthorDate: Thu Sep 22 17:24:20 2016 -0700
> > Committer:  David Sterba <dsterba@suse.com>
> > CommitDate: Mon Oct 3 18:52:14 2016 +0200
> >
> >     Btrfs: fix free space tree bitmaps on big-endian systems
> >
> >     In convert_free_space_to_{bitmaps,extents}(), we buffer the free space
> >     bitmaps in memory and copy them directly to/from the extent buffers with
> >     {read,write}_extent_buffer(). The extent buffer bitmap helpers use byte
> >     granularity, which is equivalent to a little-endian bitmap. This means
> >     that on big-endian systems, the in-memory bitmaps will be written to
> >     disk byte-swapped. To fix this, use byte-granularity for the bitmaps in
> >     memory.
> 
> This change looks overly complex to me, and decreases performance.

We had to make it correct, performance is not an issue at the moment.
