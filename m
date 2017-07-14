Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51623 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753626AbdGNMq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 08:46:28 -0400
Date: Fri, 14 Jul 2017 14:45:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix write corruption due to bio cloning on raid5/6
Message-ID: <20170714124509.GH2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170713140954.2243-1-fdmanana@kernel.org>
 <20170713163619.GB12913@lim.localdomain>
 <20170713223859.GC6181@lim.localdomain>
 <CAL3q7H5YegTE=EmP4N431pe5YsNGoHjCPbKW92KJ13E4XxTHNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5YegTE=EmP4N431pe5YsNGoHjCPbKW92KJ13E4XxTHNg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 10:04:34AM +0100, Filipe Manana wrote:
> On Thu, Jul 13, 2017 at 11:38 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Thu, Jul 13, 2017 at 09:36:19AM -0700, Liu Bo wrote:
> >> On Thu, Jul 13, 2017 at 03:09:54PM +0100, fdmanana@kernel.org wrote:
> >> > @@ -1423,11 +1430,14 @@ static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
> >> >   */
> >> >  static void set_bio_pages_uptodate(struct bio *bio)
> >> >  {
> >> > -   struct bio_vec *bvec;
> >> > -   int i;
> >> > +   struct bio_vec bvec;
> >> > +   struct bvec_iter iter;
> >> > +
> >> > +   if (bio_flagged(bio, BIO_CLONED))
> >> > +           bio->bi_iter = btrfs_io_bio(bio)->iter;
> >> >
> >
> > It is not necessary to update set_bio_pages_uptodate() because the bio
> > here is for reading pages in RMW and no way it could be a cloned one.
> 
> >From my testing I've never seen this function getting cloned bios as
> well. But I'm afraid we don't have full test coverage and it scares me
> to have code around that can cause silent corruptions or crashes due
> to such subtle details (bi_vcnt can't be used for cloned bios and it's
> not obvious which APIs from the block layer make use of it without
> reading their code). Plus a quick look I had at btrfs_map_bio()
> suggested it can clone bios used for read operations through
> btrfs_submit_bio_hook() for example. So that's why I changed that
> function too to be able to deal both with cloned and non-cloned bios.

I agree with that approach. My first reaction was to switch to
bio_for_each_segment everywhere, but this would increase stack
consumption by 32 bytes, so with the asserts in place I hope we'd catch
potential cloned/bi_vcnt violations. As you point out, the API is not
clear on that.
