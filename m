Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([213.209.14.36]:57892 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752683AbeDQTUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 15:20:45 -0400
Reply-To: kreijack@inwind.it
Subject: Re: How to dump/find parity of RAID-5 file?
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>, linux-btrfs@vger.kernel.org
References: <20170203104406.GA3670@giis.co.in>
 <15ae32eb-195a-712c-2746-cf7528b728a2@inwind.it>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <7a80857f-ec57-1dbf-37b3-da1a151f72fd@inwind.it>
Date: Tue, 17 Apr 2018 21:20:42 +0200
MIME-Version: 1.0
In-Reply-To: <15ae32eb-195a-712c-2746-cf7528b728a2@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2017 09:40 PM, Goffredo Baroncelli wrote:
> On 2017-02-03 11:44, Lakshmipathi.G wrote:
>> Hi.
>>
>> Came across this thread https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg55161.html 
>> Exploring possibility of adding test-scripts around these area using dump-tree & corrupt-block.But
>> unable to figure-out how to get parity of file or find its location.  dump-tree output gave,
>>
>>     item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 145096704) itemoff 15557 itemsize 144
>>         length 134217728 owner 2 stripe_len 65536 type DATA|RAID5
>>         io_align 65536 io_width 65536 sector_size 4096
>>         num_stripes 3 sub_stripes 0
>>             stripe 0 devid 3 offset 63111168                 # Is this parity?Seems empty?
>>             dev_uuid f62df114-186c-4e48-8152-9ed15aa078b4
>>             stripe 1 devid 2 offset 63111168                 # Contains file data-stripe-1
>>             dev_uuid c0aeaab0-e57e-4f7a-9356-db1878876d9f
>>             stripe 2 devid 1 offset 83034112                 # Contains file data-stripe-2
>>             dev_uuid 637b3666-9d8f-4ec4-9969-53b0b933b9b1
>> thanks.
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

I was wrong !
- the 3rd 64k of stripe 0, is data [320..384K)
- the 3rd 64k of stripe 1 is parity, 
- the 3rd 64k of stripe 2, is data [256..320K)

Basically stripe 0 and 2 were swapped. The idea is that after parity there is stripe 1, then stripe 2, and so on ....

D    D    D
I    I    I
S    S    S
K    K    K
1    2    3

0    1    P     
P    2    3     
5    P    4     
6    7    P     

Where 
  P = parity
  0...7 are the slices of data

So 'P' parity move from left to right starting from the last disk; the data are in the increasing address from left to right *starting* from parity in a circular buffer.

I am trying to implement raid5/6 in grub, so I went deep in the raid5 layout

BR
G.Baroncelli




> 
> To find the data, You have to compare the CO to the data [...) range.
> 
> If you look to an my old patch (unfinished :-( ), you can find some example to dump the different stripe
> 
> [BTRFS-PROGS][PATCH][V2] Add two new commands: 'btrfs insp physical-find' and 'btrfs insp physical-dump'
> 
> 
> 
> 
> 
> 
>> Cheers.
>> Lakshmipathi.G
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
