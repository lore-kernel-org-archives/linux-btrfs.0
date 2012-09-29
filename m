Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.inserm.fr ([195.98.252.37]:40479 "EHLO smtp.inserm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab2I2J77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 05:59:59 -0400
Message-ID: <20120929115951.a8w7v1rgqosk4css@imp.inserm.fr>
Date: Sat, 29 Sep 2012 11:59:51 +0200
From: =?utf-8?b?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>
To: Goffredo Baroncelli <kreijack@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>
Cc: linux-btrfs@vger.kernel.org, sebastien.maury@inserm.fr
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
	<5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it>
	<20120928091759.6d096016@natsu> <20120928085840.GE6136@carfax.org.uk>
	<5065DDF4.8010907@gmail.com> <20120928201332.GF6136@carfax.org.uk>
	<5066A11C.5080106@gmail.com>
In-Reply-To: <5066A11C.5080106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

First of all, i've to say that i'm not a linux specialist, so that  
means my point of view is balanced between a linux admin and a user.
I may also say "stupid" things, so pleas excuse me in advance :p

The first difference between the original command and the discussed  
one is on the value for the DUP parts (one has to be multiplied by 2,  
whereas the other is already multiplied by 2).
I think this should be indicated somewhere in order to avoid confusion.
This has been pointed already, but whatever the output is, it is  
essential to know if the value is raw or not, if it has to be  
multiplied or divided.

Also, i do agree with Hugo concerning the output to make it easier to  
parse through scripting.
The units should also be settable in order to have the same units for  
all values.

Basically, this new output is more explicit for me and remove a bit of  
confusion.

Although, the part "Average_disk_efficiency" seems confusing as i'm  
not sure the term "efficiency" is correct in that part.
That makes me ask some questions : why this much allocated ? when will  
it allocate more ? how much might be allocated ? ...
So, this percentage doesn't indicate an efficient usage of disk space  
or not ... for me, it indicates that it needed to allocated that  
(depending on the chunk size).
In this example there's indeed 30% of the allocation that is unused,  
but it will be used as data will grow on the disk.
For me it's similar as a LUN created in thick provisioning ... i might  
not need all the space, but i don't want to be stuck if i'll need it.
(dunno if i'm clear on that part)

Am i wrong in saying that "Free_(Estimated)" is a false value as the  
snapshots size isn't included ?
Let's say i've like 10 GB of snapshots ... then  
Free_(Estimated)=Free_(Estimated)-snaps size ? no ?
Is it possible to include those snaps size somewhere (maybe not to  
include in the summary or details, but to add another section or  
option allowing to have that info) ?

Finally, i do agree about the linearly growth as the best model currently.
For several reasons, some already explained by Hugo, and because as  
far as i understood, there is no "single" way to know very accurately  
how your disk is used. That said, the point is at least to give the  
most accurate data as possible and to be able to interpret them.
In a production environment, i can't afford to say "sorry, the app is  
crashed because my disk is full". So i need a view on what's happening  
on my disk.
Even if it lacks perfect accuracy, i can place thresholds to avoid any  
problem (70% of disk full as a warning for example).

So, i would change some terms i guess indicating more precisely the  
"raw" data and the already computed ones.
I would also not use the term efficiency as people may wonder at some  
point if they didn't make a mistake using btrfs seeing a % never near  
from 100.
The "Data_to_disk_ratio" seems preferable for me.

Cordialement,

Sébastien

Goffredo Baroncelli <kreijack@gmail.com> a écrit :

> On 09/28/2012 10:13 PM, Hugo Mills wrote:
>>> Summary:
>>>>      Disk_size:     	         135.00 GiB
>>>>      Disk_allocated:          	  10.51 GiB
>>>>      Disk_unallocated:		 124.49 GiB
>>>>      Used:			   2.59 GiB
>>>>      Free_(Estimated):         	  91.93 GiB
>>>>      Average_disk_efficiency:          70 %
>>>>
>>>>  Details:
>>>>         Chunk-type    Mode     Disk-allocated     Used   Available
>>>>         Data          Single        4.01GB      2.16GB      1.87GB
>>>>         System        DUP          16.00MB      4.00KB      7.99MB
>>>>         System        Single        4.00MB        0.00      4.00MB
>>>>         Metadata      DUP           6.00GB    429.16MB      2.57GB
>>>>         Metadata      Single        8.00MB        0.00      8.00MB
>>>>
>>>>
>>>>
>>>>  Where:
>>>>     Disk-allocated	->  space used on the disk by the chunk
>>>>     Disk-size		->  size of the disk
>>>>     Disk-unallocated	->  disk not used in any chunk
>>>>     Used 			->  space used by the files/metadata
>>    The problem here is that if you're using raw storage, the Used
>> value in the second stanza grows twice as fast as the user expects.
>
> This is the misunderstanding whom I talked before.
>
> If you give a look at the line "Metadata DUP", you can see that the
> disk-allocated are about 6GB, instead if you sum Used and Available you
> got 3GB.
>
> I.e. if you create a 1GB file, "Used" ever increased of 1GB, and
> Available ever decrease 1GB, whichever you are using DUP or Single or
> RAID*
>
>
> I
>> think this second stanza should at minimum include the "cooked" values
>> used in btrfs fi df, because those reflect the user's experience. Then
>> adding [some of?] the raw values you've got here to help connect the
>> values to the raw data in the first stanza of output.
>
> The only raw values are the one "prefixed" with disk. The other ones
> are at the net of the DUP/Single/Raid....
>
>>
>>    As I said above, it's the connection between "I wrote a 1GiB file
>> to my filesystem" and "why have my numbers increased/decreased by
>> 2GiB(*)/1.2GiB(**)?"
>
> I repeat, if the chunk is DUP-ed, if you create 1GB file:
> - Disk-allocate increase 2GB (supposing that all the chunks are full)
> - Used increase 1GB
> - Available decrease 1GB
>
>
>>
>> (*) RAID-1
>> (**) RAID-5-ish
>>
> Ciao
> Goffredo


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


