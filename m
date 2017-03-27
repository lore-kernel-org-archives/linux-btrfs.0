Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbdC0RUQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:20:16 -0400
Date: Mon, 27 Mar 2017 19:18:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Denis Kirjanov <dkirjanov@cloudlinux.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: __link_block_group uses GFP_KERNEL
Message-ID: <20170327171817.GN4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
 <a43bf7e1-36fe-cb49-d0ba-697ddaf1a14e@suse.com>
 <CABxMtgdx_aC53bL0XAZaTCX=8P6=J_+Z5jyUSS1GyES_5zw_qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABxMtgdx_aC53bL0XAZaTCX=8P6=J_+Z5jyUSS1GyES_5zw_qA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 25, 2017 at 09:48:28AM +0300, Denis Kirjanov wrote:
> On 3/25/17, Jeff Mahoney <jeffm@suse.com> wrote:
> > On 3/24/17 5:02 AM, Denis Kirjanov wrote:
> >> Hi guys,
> >>
> >> Looks like that current code does GFP_KERNEL allocation inside
> >> __link_block_group.
> >> the function invokes kobject_add and internally creates sysfs files
> >> with the GFP_KERNEL flag set.
> >
> > Yep, that's a bug.
> >
> >> But since do_chunk_alloc executes insides the btrfs transaction it's
> >> not allowed to sleep.
> >
> > It's allowed to sleep but isn't allowed to do reclaim that involves file
> > system writeback.  Michal Hocko's allocation context idea would fix
> > this, but it's not there yet, so we'll need to defer the kobject_add
> > until we can use GFP_KERNEL.
> 
> Ok, I see. Can you point out to the initial patchset?

https://lwn.net/Articles/716323/

Fixing this properly is a lot of work so we might need to add a
temporary workaround, as Jeff suggests, to move calling into sysfs to a
later time.
