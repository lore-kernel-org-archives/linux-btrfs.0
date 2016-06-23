Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:38818 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752278AbcFWTcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 15:32:55 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Adventures in btrfs raid5 disk recovery
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu> <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
Date: Thu, 23 Jun 2016 21:32:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160622203504.GQ15597@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-22 22:35, Zygo Blaxell wrote:
>> I do not know the exact nature of the Btrfs raid56 write hole. Maybe a
>> > dev or someone who knows can explain it.
> If you have 3 raid5 devices, they might be laid out on disk like this
> (e.g. with a 16K stripe width):
> 
> 	Address:  0..16K        16..32K         32..64K
>         Disk 1: [0..16K]        [32..64K]       [PARITY]
>         Disk 2: [16..32K]       [PARITY]        [80..96K]
>         Disk 3: [PARITY]        [64..80K]       [96..112K]
> 
> btrfs logical address ranges are inside [].  Disk physical address ranges
> are shown at the top of each column.  (I've simplified the mapping here;
> pretend all the addresses are relative to the start of a block group).
> 
> If we want to write a 32K extent at logical address 0, we'd write all
> three disks in one column (disk1 gets 0..16K, disk2 gets 16..32K, disk3
> gets parity for the other two disks).  The parity will be temporarily
> invalid for the time between the first disk write and the last disk write.
> In non-degraded mode the parity isn't necessary, but in degraded mode
> the entire column cannot be reconstructed because of invalid parity.
> 
> To see why this could be a problem, suppose btrfs writes a 4K extent at
> logical address 32K.  This requires updating (at least) disk 1 (where the
> logical address 32K resides) and disk 2 (the parity for this column).
> This means any data that existed at logical addresses 36K..80K (or at
> least 32..36K and 64..68K) has its parity temporarily invalidated between
> the write to the first and last disks.  If there were metadata pointing
> to other blocks in this column, the metadata temporarily points to
> damaged data during the write.  If there is no data in other blocks in
> this column then it doesn't matter that the parity doesn't match--the
> content of the reconstructed unallocated blocks would be undefined
> even in the success cases.
[...]

Sorry, but I can follow you.

RAID5 protect you in case of a failure (or a missing write) of a *single* disk.

The raid write hole happens when a stripe is not completely written on the platters: the parity and the related data mismatch. In this case a "simple" raid5 may return wrong data if the parity is used to compute the data. But this happens because a "simple" raid5 is unable to detected if the returned data is right or none.

The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the checksum. 

BTRFS is able to discard the wrong data: i.e. in case of a 3 disks raid5, the right data may be extracted from the data1+data2 or if the checksum doesn't match from data1+parity or if the checksum doesn't match from data2+parity. 
NOTE1: the real difference between the BTRFS (and ZFS) raid and the "simple" raid5 is that the latter doesn't try another pair of disks.
NOTE2: this works if only one write is corrupted. If more writes (== more disks) are involved, you got checksum mismatch. If more than one write are corrupted, raid5 is unable to protect you. 

In case of "degraded mode", you don't have any redundancy. So if a stripe of a degraded filesystem is not fully written to the disk, is like a block not fully written to the disk. And you have checksums mismatch. But this is not what is called raid write hole.


On 2016-06-22 22:35, Zygo Blaxell wrote:
> If in the future btrfs allocates physical block 2412725692 to
> a different file, up to 3 other blocks in this file (most likely
> 2412725689..2412725691) could be lost if a crash or disk I/O error also
> occurs during the same transaction.  btrfs does do this--in fact, the
> _very next block_ allocated by the filesystem is 2412725692:
> 
> 	# head -c 4096 < /dev/urandom >> f; sync; filefrag -v f
> 	Filesystem type is: 9123683e
> 	File size of f is 45056 (11 blocks of 4096 bytes)
> 	 ext:     logical_offset:        physical_offset: length:   expected: flags:
> 	   0:        0..       0: 2412725689..2412725689:      1:            
> 	   1:        1..       1: 2412725690..2412725690:      1:            
> 	   2:        2..       2: 2412725691..2412725691:      1:            
> 	   3:        3..       3: 2412725701..2412725701:      1: 2412725692:
> 	   4:        4..       4: 2412725693..2412725693:      1: 2412725702:
> 	   5:        5..       5: 2412725694..2412725694:      1:            
> 	   6:        6..       6: 2412725695..2412725695:      1:            
> 	   7:        7..       7: 2412725698..2412725698:      1: 2412725696:
> 	   8:        8..       8: 2412725699..2412725699:      1:            
> 	   9:        9..       9: 2412725700..2412725700:      1:            
> 	  10:       10..      10: 2412725692..2412725692:      1: 2412725701: last,eof
> 	f: 5 extents found

You are assuming that if you touch a block, all the blocks of the same stripe spread over the disks are involved. I disagree. The only parts which are involved, are the part of stripe which contains the changed block and the parts which contains the parity.
If both the parts become corrupted, RAID5 is unable to protect you (two failure, when raid 5 has only _one_ redundancy). But if only one of these is corrupted, BTRFS with the help of the checksum is capable to detect which one is corrupted and to return good data (and to rebuild the bad parts).


BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
