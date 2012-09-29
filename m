Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2I2Luv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 07:50:51 -0400
Received: by bkcjk13 with SMTP id jk13so4083647bkc.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 04:50:49 -0700 (PDT)
Message-ID: <5066E0AA.6070200@gmail.com>
Date: Sat, 29 Sep 2012 13:51:06 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>
CC: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        linux-btrfs@vger.kernel.org, Wade Cline <clinew@linux.vnet.ibm.com>
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu> <20120928085840.GE6136@carfax.org.uk> <5065DDF4.8010907@gmail.com> <20120928201332.GF6136@carfax.org.uk> <5066A11C.5080106@gmail.com> <20120929115951.a8w7v1rgqosk4css@imp.inserm.fr>
In-Reply-To: <20120929115951.a8w7v1rgqosk4css@imp.inserm.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sébastien,

On 09/29/2012 11:59 AM, Sébastien Maury wrote:
> Hi,
>
> First of all, i've to say that i'm not a linux specialist, so that means
> my point of view is balanced between a linux admin and a user.
> I may also say "stupid" things, so pleas excuse me in advance :p
>
> The first difference between the original command and the discussed one
> is on the value for the DUP parts (one has to be multiplied by 2,
> whereas the other is already multiplied by 2).
> I think this should be indicated somewhere in order to avoid confusion.
> This has been pointed already, but whatever the output is, it is
> essential to know if the value is raw or not, if it has to be multiplied
> or divided.




> Also, i do agree with Hugo concerning the output to make it easier to
> parse through scripting.
> The units should also be settable in order to have the same units for
> all values.

I have added a "-k" switch, so the output is in KiB unit (I tried bytes 
but so the line will became very long: 1<<64 is about 20 digits in 
decimal form)

> Basically, this new output is more explicit for me and remove a bit of
> confusion.

Great I reached my 1st goal !

>
> Although, the part "Average_disk_efficiency" seems confusing as i'm not
> sure the term "efficiency" is correct in that part.
> That makes me ask some questions : why this much allocated ? when will
> it allocate more ? how much might be allocated ? ...
> So, this percentage doesn't indicate an efficient usage of disk space or
> not ... for me, it indicates that it needed to allocated that (depending
> on the chunk size).
> In this example there's indeed 30% of the allocation that is unused, but
> it will be used as data will grow on the disk.

The 30% of the disk is/will be used for redundancy purpose. Moreover 
there are the chunk that are "pre-allocated" area, which could influence 
the free space estimation...

> For me it's similar as a LUN created in thick provisioning ... i might
> not need all the space, but i don't want to be stuck if i'll need it.
> (dunno if i'm clear on that part)
>
> Am i wrong in saying that "Free_(Estimated)" is a false value as the
> snapshots size isn't included ?
> Let's say i've like 10 GB of snapshots ... then
> Free_(Estimated)=Free_(Estimated)-snaps size ? no ?
> Is it possible to include those snaps size somewhere (maybe not to
> include in the summary or details, but to add another section or option
> allowing to have that info) ?

Free_(Estimated) takes in account also the snapshot. The point is 
another one: the user has to know that updating (i.e. changing part of 
file without increasing its size) a snapshoted file requires space. But 
Used part takes in account all the space used. So Free_(Estimated) it is 
accurate.



> Finally, i do agree about the linearly growth as the best model currently.
> For several reasons, some already explained by Hugo, and because as far
> as i understood, there is no "single" way to know very accurately how
> your disk is used. That said, the point is at least to give the most
> accurate data as possible and to be able to interpret them.
> In a production environment, i can't afford to say "sorry, the app is
> crashed because my disk is full". So i need a view on what's happening
> on my disk.
> Even if it lacks perfect accuracy, i can place thresholds to avoid any
> problem (70% of disk full as a warning for example).
>
> So, i would change some terms i guess indicating more precisely the
> "raw" data and the already computed ones.

I would like to uses the "Disk" prefix. "Raw" to me creates more 
confusions. However we should highlight that the disk occupation is 
related to the chunks, which means basically a "pre-allocation" and not 
an "using". For example a my filesystem has:

ghigo@venice:~$ btrfs/btrfs-progs/btrfs fi disk /mnt/old-btrfs/
Summary:
   Path:				/mnt/old-btrfs/
   Disk_size:			    232.11GB
   Disk_allocated:		    150.29GB
   Disk_unallocated:		     81.82GB
   Used:				     19.94GB
   Free_(Estimated):		    201.16GB
   Average_disk_efficiency:	        95 %

Details:
   Chunk-type  Mode        Disk-allocated        Used   Available
   Data        Single            136.01GB     18.84GB    117.17GB
   System      DUP                16.00MB     28.00KB      7.97MB
   System      Single              4.00MB        0.00      4.00MB
   Metadata    DUP                14.25GB      1.10GB      6.03GB
   Metadata    Single              8.00MB        0.00      8.00MB


Note that I have 136GB of chunk, but only 18GB are used.

After a "btrfs balance start" I got a different picture:

Summary:
   Path:				/mnt/old-btrfs/
   Disk_size:			    232.11GB
   Disk_allocated:		     34.13GB
   Disk_unallocated:		    197.98GB
   Used:				     19.94GB
   Free_(Estimated):		    177.74GB
   Average_disk_efficiency:	        85 %

Details:
   Chunk-type  Mode        Disk-allocated        Used   Available
   Data        Single             24.00GB     18.84GB      5.16GB
   System      DUP               128.00MB      4.00KB     64.00MB
   System      Single              4.00MB        0.00      4.00MB
   Metadata    DUP                10.00GB      1.10GB      3.90GB


The allocated chunk decreases, this impacts also on 
Average_disk_efficiency (or data_to_disk_ratio).



> I would also not use the term efficiency as people may wonder at some
> point if they didn't make a mistake using btrfs seeing a % never near
> from 100.
> The "Data_to_disk_ratio" seems preferable for me.

I like your idea; however I would also like the Wade's suggestion to 
show also the max and the min

>
> Cordialement,
>
> Sébastien
>
> Goffredo Baroncelli <kreijack@gmail.com> a écrit :
>
>> On 09/28/2012 10:13 PM, Hugo Mills wrote:
>>>> Summary:
>>>>> Disk_size: 135.00 GiB
>>>>> Disk_allocated: 10.51 GiB
>>>>> Disk_unallocated: 124.49 GiB
>>>>> Used: 2.59 GiB
>>>>> Free_(Estimated): 91.93 GiB
>>>>> Average_disk_efficiency: 70 %
>>>>>
>>>>> Details:
>>>>> Chunk-type Mode Disk-allocated Used Available
>>>>> Data Single 4.01GB 2.16GB 1.87GB
>>>>> System DUP 16.00MB 4.00KB 7.99MB
>>>>> System Single 4.00MB 0.00 4.00MB
>>>>> Metadata DUP 6.00GB 429.16MB 2.57GB
>>>>> Metadata Single 8.00MB 0.00 8.00MB
>>>>>
>>>>>
>>>>>
>>>>> Where:
>>>>> Disk-allocated -> space used on the disk by the chunk
>>>>> Disk-size -> size of the disk
>>>>> Disk-unallocated -> disk not used in any chunk
>>>>> Used -> space used by the files/metadata
>>> The problem here is that if you're using raw storage, the Used
>>> value in the second stanza grows twice as fast as the user expects.
>>
>> This is the misunderstanding whom I talked before.
>>
>> If you give a look at the line "Metadata DUP", you can see that the
>> disk-allocated are about 6GB, instead if you sum Used and Available you
>> got 3GB.
>>
>> I.e. if you create a 1GB file, "Used" ever increased of 1GB, and
>> Available ever decrease 1GB, whichever you are using DUP or Single or
>> RAID*
>>
>>
>> I
>>> think this second stanza should at minimum include the "cooked" values
>>> used in btrfs fi df, because those reflect the user's experience. Then
>>> adding [some of?] the raw values you've got here to help connect the
>>> values to the raw data in the first stanza of output.
>>
>> The only raw values are the one "prefixed" with disk. The other ones
>> are at the net of the DUP/Single/Raid....
>>
>>>
>>> As I said above, it's the connection between "I wrote a 1GiB file
>>> to my filesystem" and "why have my numbers increased/decreased by
>>> 2GiB(*)/1.2GiB(**)?"
>>
>> I repeat, if the chunk is DUP-ed, if you create 1GB file:
>> - Disk-allocate increase 2GB (supposing that all the chunks are full)
>> - Used increase 1GB
>> - Available decrease 1GB
>>
>>
>>>
>>> (*) RAID-1
>>> (**) RAID-5-ish
>>>
>> Ciao
>> Goffredo
>
>
> ----------------------------------------------------------------
> This message was sent using IMP, the Internet Messaging Program.
>
>
>

