Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34624 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaJQICj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 04:02:39 -0400
Date: Fri, 17 Oct 2014 16:02:03 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141017080202.GA3604@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20141016091726.GA582640@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141016091726.GA582640@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2014 at 11:17:26AM +0200, Tomasz Torcz wrote:
> Hi,
> 
>   Recently I've observed some corruptions to systemd's journal
> files which are somewhat puzzling. This is especially worrying
> as this is btrfs raid1 setup and I expected auto-healing.
> 
>   System details: 3.17.0-301.fc21.x86_64
> btrfs: raid1 over 2x dm-crypted 6TB HDDs.
> mount opts: rw,relatime,seclabel,compress=lzo,space_cache
> 
>   Broken files are in /var/log/journal directory. This directory
> is set NOCOW with chattr, all the files within too.
> 
> Example of broken file:
> system@0005057fe87730cf-6d3d85ed59bd70ae.journal~
> 
> When read with dd_rescue, there are many I/O errors
> reported, the summary looks like that (x = error):
> >-..-..xxxxxxxxx---x.-..-..-...-..-..-...-< 100%
> 
>   Reads with cat, hexdump fails with:
> read(4, 0x1001000, 65536)               = -1 EIO (Input/output error)
> 
>   But btrfs dev stat reports no errors!
> $ btrfs dev stat .
> [/dev/dm-0].write_io_errs   0
> [/dev/dm-0].read_io_errs    0
> [/dev/dm-0].flush_io_errs   0
> [/dev/dm-0].corruption_errs 0
> [/dev/dm-0].generation_errs 0
> [/dev/dm-1].write_io_errs   0
> [/dev/dm-1].read_io_errs    0
> [/dev/dm-1].flush_io_errs   0
> [/dev/dm-1].corruption_errs 0
> [/dev/dm-1].generation_errs 0
> 
>   There are no hardware errors in dmesg.
> 
>   This is perplexing.  How to find out what is causing the
> brokeness and howto avoid it in the future?

Does scrub work for you?

thanks,
-liubo

> 
> -- 
> Tomasz   .. oo o.   oo o. .o   .o o. o. oo o.   ..
> Torcz    .. .o .o   .o .o oo   oo .o .. .. oo   oo
> o.o.o.   .o .. o.   o. o. o.   o. o. oo .. ..   o.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
