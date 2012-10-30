Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58384 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab2J3EsY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 00:48:24 -0400
Date: Tue, 30 Oct 2012 00:48:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Huang Ying <ying.huang@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] uuid: use random32_get_bytes()
Message-ID: <20121030044818.GA5972@thunk.org>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
 <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
 <20121029205200.GD7098@thunk.org>
 <1351561798.7817.352.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351561798.7817.352.camel@yhuang-dev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 30, 2012 at 09:49:58AM +0800, Huang Ying wrote:
> The uuid_le/be_gen() in lib/uuid.c has set UUID variants to be DCE,
> that is done in __uuid_gen_common() with "b[8] = (b[8] & 0x3F) | 0x80".

Oh, I see, I missed that.

> To deal with random number generation issue, how about use
> get_random_bytes() in __uuid_gen_common()?

We already have generate_random_uuid() in drivers/char/random.c, and
no users for lib/uuid.c's equivalent uuid_be_gen().  So here's a
counter-proposal, why don't we drop lib/uuid.c, and include in
drivers/char/random.c:

/*
 * Generate random GUID
 *
 * GUID's is like UUID's, but they uses the non-standard little-endian
 * layout, compared to what is defined in RFC-4112; it is primarily
 * used by the EFI specification.
 */
void generate_random_guid(unsigned char uuid_out[16])
{
	get_random_bytes(uuid_out, 16);
	/* Set UUID version to 4 --- truly random generation */
	uuid_out[7] = (uuid_out[7] & 0x0F) | 0x40;
	/* Set the UUID variant to DCE */
	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
}
EXPORT_SYMBOL(generate_random_guid);

I really don't think it's worth it to have a __uuid_gen_common once we
are using get_random_bytes(), since there isn't much code to be
factored out, and it's simpler just to have two functions in one place.

Using UUID vs. GUID I think makes things much clearer, since the EFI
specification talks about GUID's, not UUID's, and that way we don't
have to worry about people getting confused about whether they should
be using the little-endian versus big-endian variant.  (And I'd love
to ask to whoever wrote the EFI specification what on *Earth* were
they thinking when they decided to diverge from the rest of the
world....)

	      	       	       	       	    - Ted
