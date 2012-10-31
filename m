Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12208 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab2JaBfk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 21:35:40 -0400
Message-ID: <1351647337.31033.13.camel@yhuang-dev>
Subject: Re: [PATCH 2/9] uuid: use random32_get_bytes()
From: Huang Ying <ying.huang@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Date: Wed, 31 Oct 2012 09:35:37 +0800
In-Reply-To: <20121030044818.GA5972@thunk.org>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
	 <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
	 <20121029205200.GD7098@thunk.org> <1351561798.7817.352.camel@yhuang-dev>
	 <20121030044818.GA5972@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-10-30 at 00:48 -0400, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 09:49:58AM +0800, Huang Ying wrote:
> > The uuid_le/be_gen() in lib/uuid.c has set UUID variants to be DCE,
> > that is done in __uuid_gen_common() with "b[8] = (b[8] & 0x3F) | 0x80".
> 
> Oh, I see, I missed that.
> 
> > To deal with random number generation issue, how about use
> > get_random_bytes() in __uuid_gen_common()?
> 
> We already have generate_random_uuid() in drivers/char/random.c, and
> no users for lib/uuid.c's equivalent uuid_be_gen().  So here's a
> counter-proposal, why don't we drop lib/uuid.c, and include in
> drivers/char/random.c:
> 
> /*
>  * Generate random GUID
>  *
>  * GUID's is like UUID's, but they uses the non-standard little-endian
>  * layout, compared to what is defined in RFC-4112; it is primarily
>  * used by the EFI specification.
>  */
> void generate_random_guid(unsigned char uuid_out[16])
> {
> 	get_random_bytes(uuid_out, 16);
> 	/* Set UUID version to 4 --- truly random generation */
> 	uuid_out[7] = (uuid_out[7] & 0x0F) | 0x40;
> 	/* Set the UUID variant to DCE */
> 	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
> }
> EXPORT_SYMBOL(generate_random_guid);
> 
> I really don't think it's worth it to have a __uuid_gen_common once we
> are using get_random_bytes(), since there isn't much code to be
> factored out, and it's simpler just to have two functions in one place.

The intention of lib/uuid.c is to unify various UUID related code, and
put them in same place.  In addition to UUID generation, it provide some
other utility and may provide/collect more in the future.  So do you
think it is a good idea to put generate_rand_uuid/guid into lib/uuid.c
and maybe change the name/prototype to make it consistent with other
uuid definitions?

> Using UUID vs. GUID I think makes things much clearer, since the EFI
> specification talks about GUID's, not UUID's, and that way we don't
> have to worry about people getting confused about whether they should
> be using the little-endian versus big-endian variant.  (And I'd love
> to ask to whoever wrote the EFI specification what on *Earth* were
> they thinking when they decided to diverge from the rest of the
> world....)

I think that is a good idea.  From Wikipedia, GUID is in native byte
order, while UUID is in internet byte order.

Best Regards,
Huang Ying


