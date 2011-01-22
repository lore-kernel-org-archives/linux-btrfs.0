From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: Shrinking virtual disk with btrfs on it
Date: Sat, 22 Jan 2011 09:28:51 +0100
Message-ID: <20110122082850.GA2921@mother>
References: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
 <4D39E1F3.5070903@electric-spoon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D39E1F3.5070903@electric-spoon.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 21, 2011 at 07:43:47PM +0000, David Pottage wrote:
> On 21/01/11 17:20, Rodney Beede wrote:
> > Any tools to go about zeroing about the free space on a btrfs file
> > system so I can shrink the VMware vmdk virtual disk?
> >
> > I ran the VMware command, but the dynamic disk is still really big.  I
> > presume it is due to free space that isn't zeroed out.
> Does btrfs issue TRIM commands to the underlying (virtual) block device?

  It does when mounted with - o discard.  IIRC, btrfs also supports
FITRIM ioctl (but I'm not 100% sure about this).
 
-- 
Tomasz Torcz               RIP is irrevelant. Spoofing is futile.
xmpp: zdzichubg@chrome.pl     Your routes will be aggreggated. -- Alex Yuriev

