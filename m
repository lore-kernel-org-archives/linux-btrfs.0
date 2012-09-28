Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:55589 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab2I1QoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 12:44:00 -0400
Message-ID: <5065D3D7.8080101@inwind.it>
Date: Fri, 28 Sep 2012 18:44:07 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: kreijack@libero.it,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu>
In-Reply-To: <20120928091759.6d096016@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2012 05:17 AM, Roman Mamedov wrote:
> On Thu, 27 Sep 2012 23:02:35 +0200
> Goffredo Baroncelli<kreijack@libero.it>  wrote:
>
>> Sorry for the space error:
>> Below a more correct example
>>
>> $ btrfs filesystem disk-free /
>> Summary:
>>      Total:             	        135.00GB
>>      Allocated:             	 10.51GB
>>      Unallocated:            	124.49GB
>>      Free_(Estimated)              86.56GB
>>      Average_disk_efficiency:         62 %
>
> How do you estimate "Free" here? Sorry I didn't check the source code in git,
> but from the "Details" below nothing leads me to believe that this FS is
> doomed to only be able to usefully utilize only ~86GB of the partition, and not
> more.


The estimation is made on the basis of the real allocated space on the 
disk and the available space.

In the example we know that BTRFS allocate:
- 4GB	in Single mode (4GB available, 2.16GB used)
- 16MB  in DUP mode (so  16/2=8MB available, 4kb used)
- 4MB   in Single mode (4MB available)
- 6GB   in DUP mode (6/2=3GB available, 429MB used)
- 8MB   in Single mode (8MB available)


So BTRFS allocated on disk 4GB+16MB+4MB+6GB+8MB = ~10GB, but the space 
availabled (regarding these allocated chunks) is 4GB+8MB+4MB+3GB+8MB = ~7GB.

This means that the ration of space physically allocated on the disk and 
the space available is 7GB/10GB = 0.7 . So on 135GB of disk, only 94GB 
are available.

Yes my previous 0.62 was wrong. The real ratio is 0.7.


> Are you ready to answer the flood of questions from people why their disk is
> only 62% efficient, and how to tune it to 100%? :-)

I don't understand your question: by default BTRFS store all metadata 
DUP-ed, this means that on the disk the space allocated are 2 times the 
space required. Because on BTRFS the metadata are a lot, this means that 
BTRFS is not so efficiency as other file-systems. This is a well know fact.

If you want to use all the space with the maximum efficiency, you could 
format the filesystem with the options "-m single".


>
> Why use underscores instead of spaces?

Simplify the parsing in scripts


>
>>
>> Details:
>>      Chunk-type    Mode       Allocated        Used        Free
>>      ----------    ----       ---------    --------   ---------
>>      Data          Single        4.01GB      2.16GB      1.87GB
>>      System        DUP          16.00MB      4.00KB      7.99MB
>>      System        Single        4.00MB        0.00      4.00MB
>>      Metadata      DUP           6.00GB    429.16MB      2.57GB
>>      Metadata      Single        8.00MB        0.00      8.00MB
>

