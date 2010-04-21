From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: Restoring BTRFS partition
Date: Wed, 21 Apr 2010 10:49:25 +0800
Message-ID: <20100421024925.GA2252@laptop.oracle.com>
References: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
 <20100420155538.GB3634@laptop.oracle.com>
 <20100420165049.GA6352@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100420165049.GA6352@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On 10-04-20 12:50, Sean Bartell wrote:
> On Tue, Apr 20, 2010 at 11:55:38PM +0800, Wengang Wang wrote:
> > I guess the reason is that the 300M file btrfs and the one on your
> > partition have different block size. Thus 65k zeros on your file image
> > doesn't mean 65k on the partition. So maybe you will try with blocks
> > instead of bytes.
> 
> Actually, the block size doesn't matter for this--the superblock is
> always at 0x10000. Alli, I think you'll have to upload the start of the
> partition so someone can take a look at it.

I see.
Thanks all for my knowledge!

regards,
wengang.
