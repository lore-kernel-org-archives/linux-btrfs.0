Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47832 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2I1R1A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 13:27:00 -0400
Received: by bkcjk13 with SMTP id jk13so3729043bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 10:26:59 -0700 (PDT)
Message-ID: <5065DDF4.8010907@gmail.com>
Date: Fri, 28 Sep 2012 19:27:16 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        kreijack@libero.it,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu> <20120928085840.GE6136@carfax.org.uk>
In-Reply-To: <20120928085840.GE6136@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

On 09/28/2012 10:58 AM, Hugo Mills wrote:
> On Fri, Sep 28, 2012 at 09:17:59AM +0600, Roman Mamedov wrote:
>> On Thu, 27 Sep 2012 23:02:35 +0200
>> Goffredo Baroncelli<kreijack@libero.it>  wrote:
>>
[...]


>     So that you can use, say, "read" in the shell to extract data from
> each line. To that end, there should be a space between the value and
> the unit throughout.
>
>>> Details:
>>>      Chunk-type    Mode       Allocated        Used        Free
>>>      ----------    ----       ---------    --------   ---------
>
>     Minor thing: The underlines are largely superfluous. Few basic CL
> tools I can think of use them.
Ok

>
>>>      Data          Single        4.01GB      2.16GB      1.87GB
>>>      System        DUP          16.00MB      4.00KB      7.99MB
>>>      System        Single        4.00MB        0.00      4.00MB
>>>      Metadata      DUP           6.00GB    429.16MB      2.57GB
>>>      Metadata      Single        8.00MB        0.00      8.00MB
>
>     I think we need another column here, to indicate how much *actual*
> disk space is used by each row, so adding up that column will give you
> the "Allocated" value in the first clause. I think that's probably the
> biggest cause of confusion. "Raw alloc.", maybe, and use the term
> "raw" somewhere in the first clause to hammer the point home.

I think that there is a little misunderstanding. We are saying the same 
thing. Only I call "allocated" what you call "raw alloc"

>
>     My only concern here is that we're a bit too close to the existing
> solution (albeit merging the two sets of output), which has proven
> itself over time to be somewhat confusing. I think the Alloc_Raw
> column is the minimum necessary to link the two in some easily
> determinable way. Adding totals to Alloc_Raw, and Used (but not Free
> or Alloc) would help, I think. I don't think it's useful to add them
> to the Free or Alloc columns, because those figures change as the FS
> allocates chunks, and we'll end up with people querying the fact that
> the total of Free doesn't add up to any of the figures in the
> summary.
>
>     Say, something like this:
>
> Summary_(Raw):
>    Total:                    135.00 GiB
>    Allocated:            	 10.51 GiB
>    Unallocated:            	124.49 GiB
>    Free_(Estimated):          86.56 GiB
>    Average_disk_efficiency:      62 %
>
> Details:
>    Chunk_type  Mode    Alloc_Raw  Alloc      Used        Free
>    Data        Single   4.01 GiB   4.01 GiB    2.16 GiB  1.87 GiB
>    System      DUP     32.00 MiB  16.00 MiB    4.00 KiB  7.99 MiB
>    System      Single   4.00 MiB   4.00 MiB    0.00 B    4.00 MiB
>    Metadata    DUP     12.00 GiB   6.00 GiB  429.16 MiB  2.57 GiB
>    Metadata    Single   8.00 MiB   8.00 MiB    0.00 B    8.00 MiB
>    Total               16.04 GiB               2.59 GiB
>
>     The other thing is that there should be a switch (or possibly two)
> to give highly machine-readable versions of the output -- no units
> (units as bytes by default, with other units settable by a switch),
> tab-separated, possibly a different option for each of the above
> output clauses.
I fully Agree. But my first concern was about the wording (if fact even 
though we are saying the same thing you didn't understood me).

Let me propose the following:

Summary:
    Disk_size:     	         135.00 GiB
    Disk_allocated:          	  10.51 GiB
    Disk_unallocated:		 124.49 GiB
    Used:			   2.59 GiB
    Free_(Estimated):         	  91.93 GiB
    Average_disk_efficiency:          70 %

Details:
       Chunk-type    Mode     Disk-allocated     Used   Available
       Data          Single        4.01GB      2.16GB      1.87GB
       System        DUP          16.00MB      4.00KB      7.99MB
       System        Single        4.00MB        0.00      4.00MB
       Metadata      DUP           6.00GB    429.16MB      2.57GB
       Metadata      Single        8.00MB        0.00      8.00MB



Where:
   Disk-allocated	-> space used on the disk by the chunk
   Disk-size		-> size of the disk
   Disk-unallocated	-> disk not used in any chunk
   Used 			-> space used by the files/metadata
   Available 		-> space available in the *allocated* chunk
   Free_(Estimated) 	-> Theoretical free space for files (Disk_size
			   * Average_disk_efficiency - Used)





>
>     Ultimately, I think the bikeshed should be turquoise.
? :-)


>
>     Hugo.
>

Ciao
Goffredo
