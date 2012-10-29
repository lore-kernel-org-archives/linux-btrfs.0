Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58328 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2J2UwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 16:52:04 -0400
Date: Mon, 29 Oct 2012 16:52:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ying.huang@intel.com, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] uuid: use random32_get_bytes()
Message-ID: <20121029205200.GD7098@thunk.org>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
 <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 28, 2012 at 04:18:59PM +0900, Akinobu Mita wrote:
> Use random32_get_bytes() to generate 16 bytes of pseudo-random bytes.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Since your patch is going to allow users to set the random seed, it
means that what had previously been a bad security bug has just become
a grievous security bug.  If you are going to be generating UUID's
they _must_ use a truly random random generator, since the whole point
of uuid's is that they be unique.  If someone can trivially set the
random seed of a prng, and thus cause the uuid generator to generate,
well, non-unique UUID's, the results can range anywhere from
confusion, to file system corruption and data loss.

Fortunately, there is only one user of lib/uuid.c, and that's the
btrfs file system.

Chris and the Btrfs folks --- my recommendation would be to ditch the
use of uuid_be_gen, "git rm lib/uuid.c" with extreme prejudice, and
use generate_random_uuid() which was coded over a decade ago in
drivers/char/random.c.  Not only does this properly use the kernel
random number generator, but it also creates a UUID with the correct
format.  (It's not enough to set the UUID version to 4; you also need
to set the UUID variant to be DCE if you want to be properly compliant
with RFC 4122 --- see section 4.1.1.)

The btrfs file system doesn't generate uuid's in any critical fast
paths as near as I can determine, so it should be perfectly safe to
use uuid_generate() --- I also would drop the whole distinction
between little-endian and big-endian uuid's, BTW.  RFC 4122 is quite
explicit about how uuid's should be encoded, and it's in internet byte
order.  This is what OSF/DCE uses, and it's what the rest of the world
(Microsoft, SAP AG, Apple, GNOME, KDE) uses as well.

Regards,

					- Ted
