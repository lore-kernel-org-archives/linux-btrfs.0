Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bird.oak.relay.mailchannels.net ([23.83.215.17]:10970 "EHLO
	bird.oak.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbcBIOp1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 09:45:27 -0500
Subject: Re: USB memory sticks wear & speed: btrfs vs f2fs?
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
References: <n9chle$q0h$1@ger.gmane.org>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <56B9F2E2.8010808@swiftspirit.co.za>
Date: Tue, 9 Feb 2016 16:08:34 +0200
MIME-Version: 1.0
In-Reply-To: <n9chle$q0h$1@ger.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/9/2016 1:13 PM, Martin wrote:
> How does btrfs compare to f2fs for use on (128GByte) USB memory sticks?
>
> Particularly for wearing out certain storage blocks?
>
> Does btrfs heavily use particular storage blocks that will prematurely
> "wear out"?
>
> (That is, could the whole 128GBytes be lost due to one 4kByte block
> having been re-written excessively too many times due to a fixed
> repeatedly used filesystem block?)
>
> Any other comparisons/thoughts for btrfs vs f2fs?
Copy-on-write (CoW) designs tend naturally to work well with flash 
media. F2fs is *specifically* designed to work well with flash, whereas 
for btrfs it is a natural consequence of the copy-on-write design. With 
both filesystems, if you randomly generate a 1GB file and delete it 1000 
times, onto a 1TB flash, you are *very* likely to get exactly one write 
to *every* block on the flash (possibly two writes to <1% of the blocks) 
rather than, as would be the case with non-CoW filesystems, 1000 writes 
to a small chunk of blocks.

I haven't found much reference or comparison information online wrt wear 
leveling - mostly performance benchmarks that don't really address your 
request. Personally I will likely never bother with f2fs unless I 
somehow end up working on a project requiring relatively small storage 
in Flash (as that is what f2fs was designed for).

If someone can provide or link to some proper comparison data, that 
would be nice. :)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

