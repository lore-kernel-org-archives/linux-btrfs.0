Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42356 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaAHVXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 16:23:13 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so2274348pdj.40
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jan 2014 13:23:12 -0800 (PST)
Date: Wed, 8 Jan 2014 13:24:29 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Message-ID: <20140108212429.GE7291@kmo-pixel>
References: <CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
 <1389210102.23310.31.camel@ret.masoncoding.com>
 <CAFR8uefXjN_nzHWsTF=-PxNPDMWMj5Hw+ueFYQwa8-qBEGMGTw@mail.gmail.com>
 <1389212231.23310.33.camel@ret.masoncoding.com>
 <CAFR8uec00zThzs5Q21ySG90shQHVxbRZDGrYBPrdn1KbNCQ_vw@mail.gmail.com>
 <1389214325.23310.34.camel@ret.masoncoding.com>
 <CAFR8uefj7=x149nAQOwX5pw-5OCXnS6oYYF8xZkQVrdmPJBD6g@mail.gmail.com>
 <1389215536.23310.37.camel@ret.masoncoding.com>
 <20140108211454.GC7291@kmo-pixel>
 <CAFR8uecBvvxYL8x29Aqq47Lez5vz=wUO5+Ac=SBB+i9mwEXbAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFR8uecBvvxYL8x29Aqq47Lez5vz=wUO5+Ac=SBB+i9mwEXbAg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 01:18:46PM -0800, Muthu Kumar wrote:
> On Wed, Jan 8, 2014 at 1:14 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > On Wed, Jan 08, 2014 at 09:11:49PM +0000, Chris Mason wrote:
> >> On Wed, 2014-01-08 at 13:01 -0800, Muthu Kumar wrote:
> >> > On Wed, Jan 8, 2014 at 12:51 PM, Chris Mason <clm@fb.com> wrote:
> >> > > On Wed, 2014-01-08 at 12:40 -0800, Muthu Kumar wrote:
> >> > >> On Wed, Jan 8, 2014 at 12:16 PM, Chris Mason <clm@fb.com> wrote:
> >> > >> > On Wed, 2014-01-08 at 11:54 -0800, Muthu Kumar wrote:
> >> > >> >> Chris,
> >> > >> >>
> >> > >> >> [    8.336061] WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio_endio+0xbe/0x100()
> >> > >> >> [    8.336062] bio_endio: bio for (unknown) without endio
> >> > >> >>
> >> > >> >> This is my recent change to avoid memory leak in bio_endio. But I
> >> > >> >> think the problem is higher up, most likely bio_endio is called twice
> >> > >> >> on the same bio (which was freed before).
> >> > >> >>
> >> > >> >
> >> > >> > I think these are just two separate problems.  Lets ignore the WARN_ON
> >> > >> > for now.
> >> > >> >
> >> > >>
> >> > >> Not really... the BUG that is triggered:
> >> > >>
> >> > >> kernel BUG at fs/bio.c:523!
> >> > >>
> >> > >> It is in bio_put() (added to bio_endio() as part of recent change)
> >> > >> which gets an already freed bio.
> >> > >>
> >> > >
> >> > > Oh! I see.  Let me try with that one reverted.  Thanks!
> >> > >
> >> > > -chris
> >> > >
> >> >
> >> > But, like I said, problem is in different place. I am running a "dd"
> >> > on ext4 fs for a while now, but didn't hit the problem. Any idea to
> >> > repro locally? I would also suggest running just the for-3.1/core to
> >> > isolate the issue.
> >>
> >> Just reverting that change fixes it for me.  Jens mentioned it was
> >> broken for on-stack bios.
> >
> > On-stack bios? I don't recall ever coming across such a thing, who what
> > where why?
> >
> > i would expect on stack bios to work though, i'm really curious how it
> > was broken
> 
> New change added a bio_put() which might not work if the bio is on stack.
> 
> I don't remember seeing a on-stack-bio either, any help to jog my memory?

That's code that logically belongs in bio_chain_endio(), it's just a
hack to avoid blowing the stack since the kernel is compiled with
-fno-sibling-call-optimization when you enable frame pointers (otherwise
would optimize those tail calls to jumps and we'd have no stack blowing
issues).
