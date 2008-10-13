From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data-deduplication?
Date: Mon, 13 Oct 2008 07:02:14 -0400
Message-ID: <1223895734.7032.1.camel@think.oraclecorp.com>
References: <20081012020629.GA14615@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Ray Van Dolson <rayvd@bludgeon.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081012020629.GA14615@bludgeon.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-10-11 at 19:06 -0700, Ray Van Dolson wrote:
> I recall their being a thread here a number of months back regarding
> data-deduplication support for bttfs.
> 
> Did anyone end up picking that up and giving a go at it?  Block level
> data dedup would be *awesome* in a Linux filesystem.  It does wonders
> for storing virtual machines w/ NetApp and WAFL, and even ZFS doesn't
> have this feature yet (although I've read discussions on them looking
> to add it).
> 

So far nobody has grabbed this one, but I've had more requests (no
shocker there, the kvm people are interested in it too).  It probably
won't make 1.0 but the disk format will be able to support it.

-chris


