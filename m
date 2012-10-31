Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37055 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834Ab2JaDG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 23:06:29 -0400
Message-ID: <1351652782.31033.19.camel@yhuang-dev>
Subject: Re: [PATCH 2/9] uuid: use random32_get_bytes()
From: Huang Ying <ying.huang@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Date: Wed, 31 Oct 2012 11:06:22 +0800
In-Reply-To: <20121031023808.GB9475@thunk.org>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
	 <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
	 <20121029205200.GD7098@thunk.org> <1351561798.7817.352.camel@yhuang-dev>
	 <20121030044818.GA5972@thunk.org> <1351647337.31033.13.camel@yhuang-dev>
	 <20121031023808.GB9475@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-10-30 at 22:38 -0400, Theodore Ts'o wrote:
> On Wed, Oct 31, 2012 at 09:35:37AM +0800, Huang Ying wrote:
> > 
> > The intention of lib/uuid.c is to unify various UUID related code, and
> > put them in same place.  In addition to UUID generation, it provide some
> > other utility and may provide/collect more in the future.  So do you
> > think it is a good idea to put generate_rand_uuid/guid into lib/uuid.c
> > and maybe change the name/prototype to make it consistent with other
> > uuid definitions?
> 
> I had trouble understanding why lib/uuid.c existed, since the only
> thing I saw was the uuid generation function.  After some more
> looking, I see you also created inline functions which wrapped
> memcmp().
> 
> The problem I have with your abstractions is that it just makes life
> more complicated for the callers.  All of the current places which use
> generate_random_uuid() merely want to fill in a unsigned char array.
> This includes btrfs, by the way, which is already using
> generate_random_uuid in some places, and I'm not sure why they are
> using uuid_le_gen(), since there doesn't seem to be any need for a
> little-endian uuid/guid here (it's just used as unique bag of bits
> which is 16 bytes long), and using uuid_le_gen() means extra memory
> has to be allocated on the stack, and then an extra memory copy is
> required.  Contrast (in fs/btrfs/root-tree.c):
> 
> 	   uuid_le uuid;
> 	   ...
> 		uuid_le_gen(&uuid);
> 		memcpy(item->uuid, uuid.b, BTRFS_UUID_SIZE);
> 
> versus, simply doing (fs/btrfs/volumes.c):
> 
> 	generate_random_uuid(fs_devices->fsid);
> 
> see which one is easier?  And after the uuid is generated, none of the
> current callers ever do any manipulation of the uuid, so there's no
> real point to play fancy typedef games; it just adds more work for no
> real gain.

If we use uuid_le when we define the data structure, life will be eaiser

struct btrfs_root_item {
	...
	uuid_le uuid;
	...
};

Then it is quite easy to use it.

uuid_le_gen(&item->uuid);

That is the intended usage model.

UUID_LE() macro definition has some user.  It makes it easier to
construct UUID/GUID defined in some specs.

> > > Using UUID vs. GUID I think makes things much clearer, since the EFI
> > > specification talks about GUID's, not UUID's, and that way we don't
> > > have to worry about people getting confused about whether they should
> > > be using the little-endian versus big-endian variant.  (And I'd love
> > > to ask to whoever wrote the EFI specification what on *Earth* were
> > > they thinking when they decided to diverge from the rest of the
> > > world....)
> > 
> > I think that is a good idea.  From Wikipedia, GUID is in native byte
> > order, while UUID is in internet byte order.
> 
> Well, technially GUID is "intel/little-endian byte order".  If someone
> tried to implement the GPT on a big-endian system, such as PowerPC,
> they would still have to use the little-endian byte order, even though
> it's not the native byte order for that architecture.  Otherwise
> devices wouldn't be portable between those systems.  (This is why I
> think the GUID was such a bad idea; everyone basically treats them as
> 16 byte octet strings, so this whole idea of "native byte order" just
> to save a few byte swaps at UUID generation time was really, IMHO, a
> very bad idea.)

Yes.  Explicit byte order is better.

Best Regards,
Huang Ying


