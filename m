Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:51207 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751356AbdBOSZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 13:25:00 -0500
Reply-To: kreijack@inwind.it
Subject: Re: How to dump/find parity of RAID-5 file?
References: <20170203104406.GA3670@giis.co.in>
 <15ae32eb-195a-712c-2746-cf7528b728a2@inwind.it>
 <20170214200929.GB24702@giis.co.in>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <bfe89355-f549-7bda-ff0c-428c8b4ca4ed@inwind.it>
Date: Wed, 15 Feb 2017 19:24:55 +0100
MIME-Version: 1.0
In-Reply-To: <20170214200929.GB24702@giis.co.in>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-14 21:09, Lakshmipathi.G wrote:
> On Mon, Feb 06, 2017 at 09:40:47PM +0100, Goffredo Baroncelli wrote:
>>
>> IIRC, the parity is spread across the disk stripes of the chunk.
>>
>> So first you have to find the logical-offset [LO] where the the file begins. Then you have to map this offset to the chunk which holds the data. The chunk has the following info:
>> - chunk start [CS], chunk length [CL]
>> - for each stripe:
>> 	where the stripe starts
>>
>> If you subtract the chunk-start from the logical-offset [ CO == LO-CS], you will find the offset where the data belongs in the chunk.
>>
>> As stated above, the PARITY is spread across the chunk stripes. So (supposing that the stripe size is 64K, the raid level is 5, the disks are three), 
>>
>> - the first 64k of stripe 0, is data [0..64K)
>> - the first 64k of stripe 1, is data [64..128K)
>> - the first 64k of stripe 2 is parity, 
>>
>> - the 2nd 64k of stripe 0 is parity, 
>> - the 2nd 64k of stripe 1, is data [128..196K)
>> - the 2nd 64k of stripe 2, is data [192..256K)
>>
>> - the 3rd 64k of stripe 0, is data [256..320K)
>> - the 3rd 64k of stripe 1 is parity, 
>> - the 3rd 64k of stripe 2, is data [320..384K)
>> and so on,
>>
>> To find the data, You have to compare the CO to the data [...) range.
>>
>> If you look to an my old patch (unfinished :-( ), you can find some example to dump the different stripe
>>
>> [BTRFS-PROGS][PATCH][V2] Add two new commands: 'btrfs insp physical-find' and 'btrfs insp physical-dump'
>>
>>
> Sorry for the delay, I was offline. Thanks for the details. I can understood "partiy spread across the chunk stripes" part.
> But unable to figure-out the first part regarding calculations.
> 
> Raid5 With 3-devices each 512MB. Create single 128KB file("print 'Ab'+'a'*65534+'aB'+'b'*65533"). 'debug-tree' shows chunk tree as:
> 
> 	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 145096704) itemoff 15557 itemsize 144
> 		length 134217728 owner 2 stripe_len 65536 type DATA|RAID5
> 		io_align 65536 io_width 65536 sector_size 4096
> 		num_stripes 3 sub_stripes 0
> 			stripe 0 devid 3 offset 63111168
> 			dev_uuid 9a2a18f1-6193-44b9-aafc-23d161d66110
> 			stripe 1 devid 2 offset 63111168
> 			dev_uuid e45ab907-c3a8-4dff-af9f-2ae5fd38ffd6
> 			stripe 2 devid 1 offset 83034112
> 			dev_uuid 428c04d9-37da-454a-b7b2-f6fe88580de2
> and fs-tree shows:
> 	item 13 key (145227776 EXTENT_ITEM 131072) itemoff 15788 itemsize 53
> 		extent refs 1 gen 7 flags DATA
> 		extent data backref root 5 objectid 257 offset 0 count 1
> 
>>From above, I assume: 
> LO=145227776  CS=145096704 and CL=134217728
> CO=145227776 - 145096704  => CO = 131072
> 
> Quite confused from here :s  I'll look into your patches to understand more. I hope sometime in future we will 
> have your finished patches :) 'physical-find' and 'physical-find' commands will be really useful for debugging/testing and 
> learning purposes. thanks.

The chunk-tree maps the logical address [145096704...145096704+134217728) [size=128MB] to the physical ones 
	devid3 : [63111168..63111168+67108864) [size=64MB]
	devid1 : [63111168..63111168+67108864) [size=64MB]
	devid2 : [83034112..83034112+67108864) [size=64MB]

So because the logical address is divided in pieces of 64k, interleaved by the parity, we know that:
* first 128kb
logical address [145096704      ..145096704+64k)   -> devid1, [63111168    ..63111168+64k)
logical address [145096704+64k  ..145096704+2x64k) -> devid2, [83034112    ..83034112+64k)
                parity:                            -> devid3, [63111168    ..63111168+64k)
* second 128kb
logical address [145096704+2x64k..145096704+3x64k) -> devid2, [83034112+64k..83034112+2x64k)
logical address [145096704+3x64k..145096704+4x64k) -> devid3, [63111168+64k..63111168+2x64k)
                parity:                            -> devid1, [63111168+64k..63111168+2x64k)
And so on...

(NB: 145096704+2x64k == 145227776)

The fs-tree, maps the file content [0..131072) [size=128k] to the logical address [145227776..145227776+131072) [size=128k]

So the file content is stored starting from the disk devid2, at 83034112+64k=83099648 (first 64k). The second 64k is placed in disk devid3 at 63111168+64k=63176704; the parity is stored at disk1, 63111168+64k = 63176704


BR
G.Baroncelli

> 
> Cheers.
> Lakshmipathi.G
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
