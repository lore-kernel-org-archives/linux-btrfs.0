Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbdLETb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 14:31:56 -0500
Date: Tue, 5 Dec 2017 20:29:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
Message-ID: <20171205192957.GX3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
 <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
 <20171205180403.GA18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171205180403.GA18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 11:04:03AM -0700, Liu Bo wrote:
> On Tue, Dec 05, 2017 at 04:07:35PM +0800, Qu Wenruo wrote:
> > 
> > 
> > On 2017年12月05日 06:40, Liu Bo wrote:
> > > There is a scenario that can end up with rebuild process failing to
> > > return good content, i.e.
> > > suppose that all disks can be read without problems and if the content
> > > that was read out doesn't match its checksum, currently for raid6
> > > btrfs at most retries twice,
> > > 
> > > - the 1st retry is to rebuild with all other stripes, it'll eventually
> > >   be a raid5 xor rebuild,
> > > - if the 1st fails, the 2nd retry will deliberately fail parity p so
> > >   that it will do raid6 style rebuild,
> > > 
> > > however, the chances are that another non-parity stripe content also
> > > has something corrupted, so that the above retries are not able to
> > > return correct content, and users will think of this as data loss.
> > > More seriouly, if the loss happens on some important internal btree
> > > roots, it could refuse to mount.
> > > 
> > > This extends btrfs to do more retries and each retry fails only one
> > > stripe.  Since raid6 can tolerate 2 disk failures, if there is one
> > > more failure besides the failure on which we're recovering, this can
> > > always work.
> > 
> > This should be the correct behavior for RAID6, try all possible
> > combination until all combination is exhausted or correct data can be
> > recovered.
> > 
> > > 
> > > The worst case is to retry as many times as the number of raid6 disks,
> > > but given the fact that such a scenario is really rare in practice,
> > > it's still acceptable.
> > 
> > And even we tried that much times, I don't think it will be a big problem.
> > Since most of the that happens purely in memory, it should be so fast
> > that no obvious impact can be observed.
> >
> 
> It's basically a while loop, so it may cause some delay/hang, anyway,
> it's rare though.
> 
> > While with some small nitpick inlined below, the idea looks pretty good
> > to me.
> > 
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> > 
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > >  fs/btrfs/raid56.c  | 18 ++++++++++++++----
> > >  fs/btrfs/volumes.c |  9 ++++++++-
> > >  2 files changed, 22 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > > index 8d09535..064d5bc 100644
> > > --- a/fs/btrfs/raid56.c
> > > +++ b/fs/btrfs/raid56.c
> > > @@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
> > >  	}
> > >  
> > >  	/*
> > > -	 * reconstruct from the q stripe if they are
> > > -	 * asking for mirror 3
> > > +	 * Loop retry:
> > > +	 * for 'mirror == 2', reconstruct from all other stripes.
> > 
> > What about using macro to makes the reassemble method more human readable?
> > 
> > And for mirror == 2 case, "rebuild from all" do you mean rebuild using
> > all remaining data stripe + P? The word "all" here is a little confusing.
> >
> 
> Thank you for the comments.
> 
> It depends, if all other stripes are good to read, then it'd do
> 'data+p' which is raid5 xor rebuild, if some disks also fail, then
> it'd may do 'data+p+q' or 'data+q'.
> 
> Is it better to say "for mirror == 2, reconstruct from other available
> stripes"?

Yes it is, you can also add the examples from the previous paragraph.
