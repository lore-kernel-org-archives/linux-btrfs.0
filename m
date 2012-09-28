Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48542 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2I1V0I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 17:26:08 -0400
Received: by wibhr7 with SMTP id hr7so320662wib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 14:26:06 -0700 (PDT)
Message-ID: <506615FF.2070106@gmail.com>
Date: Fri, 28 Sep 2012 23:26:23 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu> <20120928085840.GE6136@carfax.org.uk> <5065DDF4.8010907@gmail.com> <20120928201332.GF6136@carfax.org.uk>
In-Reply-To: <20120928201332.GF6136@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2012 10:13 PM, Hugo Mills wrote:
>> Summary:
>> >      Disk_size:     	         135.00 GiB
>> >      Disk_allocated:          	  10.51 GiB
>> >      Disk_unallocated:		 124.49 GiB
>> >      Used:			   2.59 GiB
>> >      Free_(Estimated):         	  91.93 GiB
>> >      Average_disk_efficiency:          70 %
>> >
>> >  Details:
>> >         Chunk-type    Mode     Disk-allocated     Used   Available
>> >         Data          Single        4.01GB      2.16GB      1.87GB
>> >         System        DUP          16.00MB      4.00KB      7.99MB
>> >         System        Single        4.00MB        0.00      4.00MB
>> >         Metadata      DUP           6.00GB    429.16MB      2.57GB
>> >         Metadata      Single        8.00MB        0.00      8.00MB
>> >
>> >
>> >
>> >  Where:
>> >     Disk-allocated	->  space used on the disk by the chunk
>> >     Disk-size		->  size of the disk
>> >     Disk-unallocated	->  disk not used in any chunk
>> >     Used 			->  space used by the files/metadata
>     The problem here is that if you're using raw storage, the Used
> value in the second stanza grows twice as fast as the user expects.

This is the misunderstanding whom I talked before.

If you give a look at the line "Metadata DUP", you can see that the 
disk-allocated are about 6GB, instead if you sum Used and Available you 
got 3GB.

I.e. if you create a 1GB file, "Used" ever increased of 1GB, and 
Available ever decrease 1GB, whichever you are using DUP or Single or RAID*


I
> think this second stanza should at minimum include the "cooked" values
> used in btrfs fi df, because those reflect the user's experience. Then
> adding [some of?] the raw values you've got here to help connect the
> values to the raw data in the first stanza of output.

The only raw values are the one "prefixed" with disk. The other ones are 
at the net of the DUP/Single/Raid....

>
>     As I said above, it's the connection between "I wrote a 1GiB file
> to my filesystem" and "why have my numbers increased/decreased by
> 2GiB(*)/1.2GiB(**)?"

I repeat, if the chunk is DUP-ed, if you create 1GB file:
- Disk-allocate increase 2GB (supposing that all the chunks are full)
- Used increase 1GB
- Available decrease 1GB


>
> (*) RAID-1
> (**) RAID-5-ish
>
Ciao
Goffredo
