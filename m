Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22307 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750813AbaJ1Bkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 21:40:41 -0400
Message-ID: <544EF415.6090308@cn.fujitsu.com>
Date: Tue, 28 Oct 2014 09:40:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Ansgar Hockmann-Stolle <Ansgar.Hockmann-Stolle@uni-osnabrueck.de>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs unmountable: read block failed check_tree_block; Couldn't
 read tree root
References: <544E4747.2000008@uni-osnabrueck.de> <544ECF24.7030504@uni-osnabrueck.de> <544EEBBF.5080208@cn.fujitsu.com>
In-Reply-To: <544EEBBF.5080208@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: btrfs unmountable: read block failed check_tree_block; 
Couldn't read tree root
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: Ansgar Hockmann-Stolle <Ansgar.Hockmann-Stolle@uni-osnabrueck.de>, 
<linux-btrfs@vger.kernel.org>
Date: 2014年10月28日 09:05
>
> -------- Original Message --------
> Subject: Re: btrfs unmountable: read block failed check_tree_block; 
> Couldn't read tree root
> From: Ansgar Hockmann-Stolle <Ansgar.Hockmann-Stolle@uni-osnabrueck.de>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2014年10月28日 07:03
>> Am 27.10.14 um 14:23 schrieb Ansgar Hockmann-Stolle:
>>> Hi!
>>>
>>> My btrfs system partition went readonly. After reboot it doesnt mount
>>> anymore. System was openSUSE 13.1 Tumbleweed (kernel 3.17.??). Now I'm
>>> on openSUSE 13.2-RC1 rescue (kernel 3.16.3). I dumped (dd) the whole 
>>> 250
>>> GB SSD to some USB file and tried some btrfs tools on another copy per
>>> loopback device. But everything failed with:
>>>
>>> kernel: BTRFS: failed to read tree root on dm-2
>>>
>>> See http://pastebin.com/raw.php?i=dPnU6nzg.
>>>
>>> Any hints where to go from here?
>>
>> After an offlist hint (thanks Tom!) I compiled the latest btrfs-progs 
>> 3.17 and tried some more ...
>>
>> linux:~/bin # ./btrfs --version
>> Btrfs v3.17
>> linux:~/bin # ./btrfs-find-root /dev/sda3
>> Super think's the tree root is at 1015238656, chunk root 20971520
>> Well block 239718400 seems great, but generation doesn't match, 
>> have=661931, want=663595 level 0
>> Well block 239722496 seems great, but generation doesn't match, 
>> have=661931, want=663595 level 0
>> Well block 320098304 seems great, but generation doesn't match, 
>> have=662233, want=663595 level 0
>> Well block 879341568 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 879345664 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 879382528 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 879398912 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 879403008 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 879423488 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 879435776 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 880095232 seems great, but generation doesn't match, 
>> have=663227, want=663595 level 0
>> Well block 881504256 seems great, but generation doesn't match, 
>> have=663228, want=663595 level 0
>> Well block 881512448 seems great, but generation doesn't match, 
>> have=663228, want=663595 level 0
>> Well block 936271872 seems great, but generation doesn't match, 
>> have=663397, want=663595 level 0
>> Well block 1004490752 seems great, but generation doesn't match, 
>> have=663571, want=663595 level 0
>> Well block 1007804416 seems great, but generation doesn't match, 
>> have=663572, want=663595 level 0
>> Well block 1012031488 seems great, but generation doesn't match, 
>> have=663575, want=663595 level 0
>> Well block 1012396032 seems great, but generation doesn't match, 
>> have=663575, want=663595 level 0
>> Well block 1012633600 seems great, but generation doesn't match, 
>> have=663586, want=663595 level 0
>> Well block 1012871168 seems great, but generation doesn't match, 
>> have=663585, want=663595 level 0
>> Well block 1015201792 seems great, but generation doesn't match, 
>> have=663588, want=663595 level 0
>> Well block 1015836672 seems great, but generation doesn't match, 
>> have=663596, want=663595 level 1
>> Well block 44132536320 seems great, but generation doesn't match, 
>> have=658774, want=663595 level 0
>> Well block 44178280448 seems great, but generation doesn't match, 
>> have=658774, want=663595 level 0
>> Well block 87443644416 seems great, but generation doesn't match, 
>> have=661349, want=663595 level 0
>> Well block 87514079232 seems great, but generation doesn't match, 
>> have=651051, want=663595 level 0
>> Well block 87517679616 seems great, but generation doesn't match, 
>> have=661349, want=663595 level 0
>> Well block 98697822208 seems great, but generation doesn't match, 
>> have=643548, want=663595 level 0
>> Well block 103285026816 seems great, but generation doesn't match, 
>> have=661672, want=663595 level 0
>> Well block 103309553664 seems great, but generation doesn't match, 
>> have=661674, want=663595 level 0
>> Well block 103523430400 seems great, but generation doesn't match, 
>> have=661767, want=663595 level 0
>> No more metdata to scan, exiting
>>
>> This line I found interesting because "have" is "want + 1":
>> Well block 1015836672 seems great, but generation doesn't match, 
>> have=663596, want=663595 level 1
>>
>> And here the tail of "btrfs rescue chunk-recover" (full output at 
>> http://pastebin.com/raw.php?i=1D5VgDxv)
>>
>> [..]
>> Total Chunks:    234
>>   Heathy:    231
>>   Bad:    3
>>
>> Orphan Block Groups:
>>
>> Orphan Device Extents:
>> Couldn't map the block 1015238656
>> btrfs: volumes.c:1140: btrfs_num_copies: Assertion `!(ce->start > 
>> logical || ce->start + ce->size < logical)' failed.
>> Aborted
>>
After looking into the 3 bad chunks, it turns out that the logical 
1015238656 is covered by the bad chunk:

   Chunk: start = 29360128, len = 1073741824, type = 24, num_stripes = 2
       Stripes list:
       [ 0] Stripe: devid = 1, offset = 37748736
       [ 1] Stripe: devid = 1, offset = 1111490560
       No block group.
       Device extent list:
           [ 0]Device extent: devid = 1, start = 1111490560, len = 1073741824, chunk offset = 29360128
           [ 1]Device extent: devid = 1, start = 37748736, len = 1073741824, chunk offset = 29360128

Which means these bad chunks are in fact good chunks.
However current chunk-recovery can't rebuild block group
since it doesn't know how to rebuild the 'used' member.

So these needed chunks can't be rebuilt.

I'll try to implement the block group rebuild function,
but it may take some time.

Thanks,
Qu


> First, I think the assertion could be dealt with.
>
> Second, much like the other one who encounters chunk tree corruption,
> the chunk-recovery did quite well and salvaged most of the chunks.
> However the codes is somewhat too strict to rebuild the chunk tree
> if there is *ANY* orphan chunk.
>
> I prefer to make chunk-rescue less strict to rebuild chunk.
> Maybe it would help on your case but it may takes some time.
>
> Thanks,
> Qu
>>
>> Sadly "btrfs check --repair" keep up refusing to do its job.
>>
>> linux:~ # btrfs check --repair /dev/sda3
>> enabling repair mode
>> Check tree block failed, want=1015238656, have=0
>> Check tree block failed, want=1015238656, have=0
>> Check tree block failed, want=1015238656, have=0
>> Check tree block failed, want=1015238656, have=0
>> Check tree block failed, want=1015238656, have=0
>> read block failed check_tree_block
>> Couldn't read tree root
>> Checking filesystem on /dev/sda3
>> UUID: 1af256b5-b1ad-443b-aeee-a6853e70b7e2
>> Critical roots corrupted, unable to fsck the FS
>> Segmentation fault
>>
>> Any more hints?
>>
>> Ciao
>>     Ansgar
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

