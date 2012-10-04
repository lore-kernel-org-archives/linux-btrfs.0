Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:43842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JDBv2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 21:51:28 -0400
Date: Thu, 4 Oct 2012 03:51:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Johannes Stezenbach <js@sig21.net>
Subject: Re: [GIT PULL v2] Update LZO compression
Message-ID: <20121004015122.GK16230@one.firstfloor.org>
References: <5033A78E.3080703@oberhumer.com> <506C14BA.70006@oberhumer.com> <CAFLxGvw3OqOb0UVhjtwC+CD+wtubH-O1FM7=fYFT8ztWPVPd6w@mail.gmail.com> <20121003140136.f2b071df.akpm@linux-foundation.org> <20121003211904.GJ16230@one.firstfloor.org> <20121003143200.69a50aad.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121003143200.69a50aad.akpm@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > > - Post the entire patch series to lkml for review (I'd like a cc please)
> > 
> > Already happened, multiple people reviewed and tested.
> 
> um, I would not consider "Looks ok to me from a quick look." and "I
> couldn't tell from the github view, but I assume you follow standard
> coding style." to indicate a rigorous code review!

Let's put it like this. LZO is mature widely used production software and 
Markus wrote and maintains it.  Essentially this is a release from him.

The main problem before with using his version directly was that it did 
not follow Linux coding standards, but that seems to be fixed now. It's 
also relatively simple and at least I didn't spot anything bad when I looked.

It was runtime tested by several people on different architectures.
If it was fuzzed so we can assume reasonably good security.

-Andi 

-- 
ak@linux.intel.com -- Speaking for myself only.
