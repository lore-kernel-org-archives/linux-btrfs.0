Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2J3BuB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 21:50:01 -0400
Message-ID: <1351561798.7817.352.camel@yhuang-dev>
Subject: Re: [PATCH 2/9] uuid: use random32_get_bytes()
From: Huang Ying <ying.huang@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Date: Tue, 30 Oct 2012 09:49:58 +0800
In-Reply-To: <20121029205200.GD7098@thunk.org>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
	 <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
	 <20121029205200.GD7098@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-10-29 at 16:52 -0400, Theodore Ts'o wrote:
> On Sun, Oct 28, 2012 at 04:18:59PM +0900, Akinobu Mita wrote:
> > Use random32_get_bytes() to generate 16 bytes of pseudo-random bytes.
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Since your patch is going to allow users to set the random seed, it
> means that what had previously been a bad security bug has just become
> a grievous security bug.  If you are going to be generating UUID's
> they _must_ use a truly random random generator, since the whole point
> of uuid's is that they be unique.  If someone can trivially set the
> random seed of a prng, and thus cause the uuid generator to generate,
> well, non-unique UUID's, the results can range anywhere from
> confusion, to file system corruption and data loss.
> 
> Fortunately, there is only one user of lib/uuid.c, and that's the
> btrfs file system.
> 
> Chris and the Btrfs folks --- my recommendation would be to ditch the
> use of uuid_be_gen, "git rm lib/uuid.c" with extreme prejudice, and
> use generate_random_uuid() which was coded over a decade ago in
> drivers/char/random.c.  Not only does this properly use the kernel
> random number generator, but it also creates a UUID with the correct
> format.  (It's not enough to set the UUID version to 4; you also need
> to set the UUID variant to be DCE if you want to be properly compliant
> with RFC 4122 --- see section 4.1.1.)

The uuid_le/be_gen() in lib/uuid.c has set UUID variants to be DCE,
that is done in __uuid_gen_common() with "b[8] = (b[8] & 0x3F) | 0x80".

To deal with random number generation issue, how about use
get_random_bytes() in __uuid_gen_common()?

> The btrfs file system doesn't generate uuid's in any critical fast
> paths as near as I can determine, so it should be perfectly safe to
> use uuid_generate() --- I also would drop the whole distinction
> between little-endian and big-endian uuid's, BTW.  RFC 4122 is quite
> explicit about how uuid's should be encoded, and it's in internet byte
> order.  This is what OSF/DCE uses, and it's what the rest of the world
> (Microsoft, SAP AG, Apple, GNOME, KDE) uses as well.

uuid_be complies RFC4122, it uses internet byte order.  But EFI uses
little endian.

Best Regards,
Huang Ying


