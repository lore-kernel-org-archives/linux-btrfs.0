From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Mon, 15 Feb 2010 17:31:35 -0500
Message-ID: <4B79CB47.2020607@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B77521F.2060105@gmail.com> <4B79C44B.7020006@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: rk <rkasl@computer.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B79C44B.7020006@computer.org>
List-ID: <linux-btrfs.vger.kernel.org>

rk wrote:
> http://www.osnews.com/story/22872/Linux_Not_Fully_Prepared_for_4096-Byte_Sector_Hard_Drives

Yes, partition alignment to the 4k drive block is critical,
but that is not an direct IO issue, it is mkfs.btrfs and
just as important for cache IO.

And in any case, many people will use 512 byte block
drives for many years to come.  The switch to 4k will
be gradual.

jim
