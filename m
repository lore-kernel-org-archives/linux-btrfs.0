From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs fallocate woes
Date: Thu, 14 Jan 2010 14:20:35 -0500
Message-ID: <20100114192035.GC23810@think>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
 <aday6k0lhpx.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paul Komkoff <i@stingr.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <aday6k0lhpx.fsf@roland-alpha.cisco.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2010 at 09:27:38AM -0800, Roland Dreier wrote:
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
> so the btrfs behavior seems OK to me.
> 
> You say this is a regression.  What btrfs version behaved differently?

The file size should still be 4 bytes I think, even if we allocate 4096.

-chris

