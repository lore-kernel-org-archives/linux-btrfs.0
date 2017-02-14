Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:49562
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbdBNUKo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 15:10:44 -0500
Date: Wed, 15 Feb 2017 01:39:29 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Goffredo Baroncelli <kreijack@inwind.it>, linux-btrfs@vger.kernel.org
Subject: Re: How to dump/find parity of RAID-5 file?
Message-ID: <20170214200929.GB24702@giis.co.in>
References: <20170203104406.GA3670@giis.co.in>
 <15ae32eb-195a-712c-2746-cf7528b728a2@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <15ae32eb-195a-712c-2746-cf7528b728a2@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2017 at 09:40:47PM +0100, Goffredo Baroncelli wrote:
> 
> IIRC, the parity is spread across the disk stripes of the chunk.
> 
> So first you have to find the logical-offset [LO] where the the file begins. Then you have to map this offset to the chunk which holds the data. The chunk has the following info:
> - chunk start [CS], chunk length [CL]
> - for each stripe:
> 	where the stripe starts
> 
> If you subtract the chunk-start from the logical-offset [ CO == LO-CS], you will find the offset where the data belongs in the chunk.
> 
> As stated above, the PARITY is spread across the chunk stripes. So (supposing that the stripe size is 64K, the raid level is 5, the disks are three), 
> 
> - the first 64k of stripe 0, is data [0..64K)
> - the first 64k of stripe 1, is data [64..128K)
> - the first 64k of stripe 2 is parity, 
> 
> - the 2nd 64k of stripe 0 is parity, 
> - the 2nd 64k of stripe 1, is data [128..196K)
> - the 2nd 64k of stripe 2, is data [192..256K)
> 
> - the 3rd 64k of stripe 0, is data [256..320K)
> - the 3rd 64k of stripe 1 is parity, 
> - the 3rd 64k of stripe 2, is data [320..384K)
> and so on,
> 
> To find the data, You have to compare the CO to the data [...) range.
> 
> If you look to an my old patch (unfinished :-( ), you can find some example to dump the different stripe
> 
> [BTRFS-PROGS][PATCH][V2] Add two new commands: 'btrfs insp physical-find' and 'btrfs insp physical-dump'
> 
> 
Sorry for the delay, I was offline. Thanks for the details. I can understood "partiy spread across the chunk stripes" part.
But unable to figure-out the first part regarding calculations.

Raid5 With 3-devices each 512MB. Create single 128KB file("print 'Ab'+'a'*65534+'aB'+'b'*65533"). 'debug-tree' shows chunk tree as:

	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 145096704) itemoff 15557 itemsize 144
		length 134217728 owner 2 stripe_len 65536 type DATA|RAID5
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 3 sub_stripes 0
			stripe 0 devid 3 offset 63111168
			dev_uuid 9a2a18f1-6193-44b9-aafc-23d161d66110
			stripe 1 devid 2 offset 63111168
			dev_uuid e45ab907-c3a8-4dff-af9f-2ae5fd38ffd6
			stripe 2 devid 1 offset 83034112
			dev_uuid 428c04d9-37da-454a-b7b2-f6fe88580de2
and fs-tree shows:
	item 13 key (145227776 EXTENT_ITEM 131072) itemoff 15788 itemsize 53
		extent refs 1 gen 7 flags DATA
		extent data backref root 5 objectid 257 offset 0 count 1

>From above, I assume: 
LO=145227776  CS=145096704 and CL=134217728
CO=145227776 - 145096704  => CO = 131072

Quite confused from here :s  I'll look into your patches to understand more. I hope sometime in future we will 
have your finished patches :) 'physical-find' and 'physical-find' commands will be really useful for debugging/testing and 
learning purposes. thanks.

Cheers.
Lakshmipathi.G
