From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs and 1 billion small files
Date: Tue, 08 May 2012 17:51:05 +0100
Message-ID: <jobitp$lju$1@dough.gmane.org>
References: <1913174825.1910.1336382310577.JavaMail.root@zimbra.interconnessioni.it> <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it> <20120508123153.GS11876@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120508123153.GS11876@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/05/12 13:31, Chris Mason wrote:

[...]
> A few people have already mentioned how btrfs will pack these small
> files into metadata blocks.  If you're running btrfs on a single disk,

[...]
> But the cost is increased CPU usage.  Btrfs hits memmove and memcpy
> pretty hard when you're using larger blocks.
> 
> I suggest using a 16K or 32K block size.  You can go up to 64K, it may
> work well if you have beefy CPUs.  Example for 16K:
> 
> mkfs.btrfs -l 16K -n 16K /dev/xxx

Is that still with "-s 4K" ?


Might that help SSDs that work in 16kByte chunks?

And why are memmove and memcpy more heavily used?

Does that suggest better optimisation of the (meta)data, or just a
greater housekeeping overhead to shuffle data to new offsets?


Regards,
Martin


