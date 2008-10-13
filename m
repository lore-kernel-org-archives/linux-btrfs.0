From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Data-deduplication?
Date: Mon, 13 Oct 2008 10:52:29 +0200
Message-ID: <878wssswqa.fsf@basil.nowhere.org>
References: <20081012020629.GA14615@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ray Van Dolson <rayvd@bludgeon.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081012020629.GA14615@bludgeon.org> (Ray Van Dolson's message of "Sat, 11 Oct 2008 19:06:29 -0700")
List-ID: <linux-btrfs.vger.kernel.org>

Ray Van Dolson <rayvd@bludgeon.org> writes:

> I recall their being a thread here a number of months back regarding
> data-deduplication support for bttfs.
>
> Did anyone end up picking that up and giving a go at it?  Block level
> data dedup would be *awesome* in a Linux filesystem.  It does wonders
> for storing virtual machines w/ NetApp and WAFL, and even ZFS doesn't
> have this feature yet (although I've read discussions on them looking
> to add it).

There are some patches to do in QEMU's cow format for KVM. That's
user level only.

-Andi
-- 
ak@linux.intel.com
