From: David Pottage <david@electric-spoon.com>
Subject: Re: Shrinking virtual disk with btrfs on it
Date: Fri, 21 Jan 2011 19:43:47 +0000
Message-ID: <4D39E1F3.5070903@electric-spoon.com>
References: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Rodney Beede <mailinglist@rodneybeede.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 21/01/11 17:20, Rodney Beede wrote:
> Any tools to go about zeroing about the free space on a btrfs file
> system so I can shrink the VMware vmdk virtual disk?
>
> I ran the VMware command, but the dynamic disk is still really big.  I
> presume it is due to free space that isn't zeroed out.
Does btrfs issue TRIM commands to the underlying (virtual) block device?

I guess not yet, as otherwise you would not see this problem, as your
virtual storage device should catch them and discard the corresponding
virtual storage blocks.

-- 
David Pottage

