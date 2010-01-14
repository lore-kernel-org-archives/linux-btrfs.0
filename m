From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: btrfs fallocate woes
Date: Thu, 14 Jan 2010 23:56:36 +0530
Message-ID: <87y6k0lezn.fsf@linux.vnet.ibm.com>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
	<aday6k0lhpx.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roland Dreier <rdreier@cisco.com>, Paul Komkoff <i@stingr.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <aday6k0lhpx.fsf@roland-alpha.cisco.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Jan 2010 09:27:38 -0800, Roland Dreier <rdreier@cisco.com> wrote:
> 
>  > if you run it on ext4, it will create a 4-byte file with "test" in it.
>  > On btrfs, however, the file size would be 4096, and the remaining
>  > space will be filled with zeroes.
> 
> My fallocate man page says:
> 
>        Because allocation is done in block size chunks, fallocate() may
>        allocate a larger range than that which was specified.
> 

But with zero as the mode value it should not have updated 
i_size. Looking at the latest linus tree it seems to be doing the right
thing

-aneesh
