From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel bug in file-item.c
Date: Wed, 29 Apr 2009 14:30:41 -0400
Message-ID: <1241029841.20099.53.camel@think.oraclecorp.com>
References: <49F73F69.4010205@oel.state.nj.us>
	 <1240946633.15136.55.camel@think.oraclecorp.com>
	 <49F87A7F.7090804@oel.state.nj.us>
	 <1241027618.20099.48.camel@think.oraclecorp.com>
	 <49F89AB4.2090001@oel.state.nj.us>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: mroconnor@oel.state.nj.us
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F89AB4.2090001@oel.state.nj.us>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-29 at 14:21 -0400, Marc R. O'Connor wrote:
> 
> Chris Mason wrote:
> > On Wed, 2009-04-29 at 12:04 -0400, Marc R. O'Connor wrote:
> >> -----BEGIN PGP SIGNED MESSAGE-----
> >> Hash: SHA1
> >>
> >> full file-item.c attached
> >>
> >> Chris Mason wrote:
> >>> On Tue, 2009-04-28 at 13:39 -0400, Marc R. O'Connor wrote:
> >>>> I have had two 'kernel bug' issues today both referencing file-item.c.
> >>>> The first oops happened when i was cp'ing from and external HD(ext3) to
> >>>> and ext3 partition. The second happened during boot up. I have attached
> >>>> them both.
> >>>>
> >>>> Im using btrfs that was merged into my kernel yesterday.
> >>>>
> >>>> plain text document attachment (btrfs_bug_1)
> >>>> Apr 28 10:55:10 cosmo2 ------------[ cut here ]------------
> >>>> Apr 28 10:55:10 cosmo2 kernel BUG at fs/btrfs/file-item.c:494!
> >>> Well, I think I see the bug.  It looks like we want to do
> >>>
> >>> -        if (key->offset < bytenr && csum_end <= end_byte) {
> >>> +        if (key->offset <= bytenr && csum_end <= end_byte) {
> >>>
> >>> in truncate_one_csum.  But I need to test that here for a bit and send
> >>> you a patch.
> > 
> > Ok, line 494 is actually this one ;)
> > 
> >                 key->offset = end_byte;
> >                 ret = btrfs_set_item_key_safe(trans, root, path, key);
> >                 BUG_ON(ret); <---- 494
> > 
> > Which means we're finding things out of order in the btree leaf.
> > 
> > Could you please run btrfsck on this filesystem?
> > 

> I have done that on all btrfs partitions I have and btrfsck did not
> return anything odd.
> 

In that case, the bad ordering is being introduced at run time.  Could
you please run memtest86 on the box?

-chris


