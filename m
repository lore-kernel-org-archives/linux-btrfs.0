From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs support for efficient SSD operation (data blocks alignment)
Date: Tue, 01 May 2012 18:04:25 +0100
Message-ID: <jnp52p$mrp$1@dough.gmane.org>
References: <jgui4j$th5$1@dough.gmane.org> (sfid-20120208_204940_752385_3F40C11C) <201202101918.57855.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202101918.57855.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Looking at this again from some time ago...

Brief summary:

There is a LOT of nefarious cleverness being attempted by SSD
manufacturers to accommodate a 4kByte block size. Get that wrong, or
just be unsympathetic to that 'cleverness', and you suffer performance
degradation and/or premature device wear.

Is that significant? Very likely it will be for the new three-bit FLASH
devices that have a PE (program-erase) lifespan of only 1000 or so
cycles per cell.

A better question is whether the filesystem can be easily made to be
more sympathetic to all SSDs?


=46rom my investigating, there appears to be a sweet spot for performan=
ce
for writing (aligned) 16kByte blocks.

TRIM and keeping the device non-full also helps greatly.

I suspect that consecutive writes, as is the case for HDDs, also helps
performance to a lesser degree.


The erased state for SSDs appears to be either all 0xFF or all 0x00
(I've got examples of both). Can that be automatically detected and use=
d
by btrfs so as to minimise write cycling the bits for (unused) padded a=
reas?

Are 16kByte blocks/sectors useful to btrfs?

Or rather, can btrfs usefully use 16kByte blocks?

Can that be supported?



=46urther detail...

Some good comments:

On 10/02/12 18:18, Martin Steigerwald wrote:
> Hi Martin,
>=20
> Am Mittwoch, 8. Februar 2012 schrieb Martin:
>> My understanding is that for x86 architecture systems, btrfs only
>> allows a sector size of 4kB for a HDD/SSD. That is fine for the
>> present HDDs assuming the partitions are aligned to a 4kB boundary f=
or
>> that device.
>>
>> However for SSDs...
>>
>> I'm using for example a 60GByte SSD that has:
>>
>>     8kB page size;
>>     16kB logical to physical mapping chunk size;
>>     2MB erase block size;
>>     64MB cache.
>>
>> And the sector size reported to Linux 3.0 is the default 512 bytes!
>>
>>
>> My first thought is to try formatting with a sector size of 16kB to
>> align with the SSD logical mapping chunk size. This is to avoid SSD
>> write amplification. Also, the data transfer performance for that
>> device is near maximum for writes with a blocksize of 16kB and above=
=2E
>> Yet, btrfs supports a 4kByte page/sector size only at present...
>=20
> Thing is as far as I know the better SSDs and even the dumber ones ha=
ve=20
> quite some intelligence in the firmware. And at least for me its not =
clear=20
> what the firmware of my Intel SSD 320 all does on its own and whether=
 any=20
> of my optimization attempts even matter.

[...]

> The article on write amplication on wikipedia gives me a glimpse of t=
he=20
> complexity involved=B9. Yes, I set stripe-width as well on my Ext4=20
> filesystem, but frankly said I am not even sure whether this has any=20
> positive effect except of maybe sparing the SSD controller firmware s=
ome=20
> reshuffling work.
>=20
> So from my current point of view most of what you wrote IMHO is more=20
> important for really dumb flash. ...

[...]

> grade SSDs just provide a SATA interface and hide the internals. So a=
n=20
> optimization for one kind or one brand of SSDs may not be suitable fo=
r=20
> another one.
>=20
> There are PCI express models but these probably aren=B4t dumb either.=
 And=20
> then there is the idea of auto commit memory (ACM) by Fusion-IO which=
 just=20
> makes a part of the virtual address space persistent.
>=20
> So its a question on where to put the intelligence. For current SSDs =
is=20
> seems the intelligence is really near the storage medium and then IMH=
O it=20
> makes sense to even reduce the intelligence on the Linux side.
>=20
> [1] http://en.wikipedia.org/wiki/Write_amplification


As an engineer, I have a deep mistrust of the phrase "Trust me" or of
"Magic" or "Proprietary, secret" or "Proprietary, keep out!".

Anand at Anandtech has produced some good articles on some of what goes
on inside SSDs and some of the consequences. If you want a good long re=
ad:

The SSD Relapse: Understanding and Choosing the Best SSD
http://www.anandtech.com/print/2829

Covers block allocation and write amplification and the effect of free
space on the write amplification factor.


=2E.. The Fastest MLC SSD We've Ever Tested
http://www.anandtech.com/print/2899

Details the Sandforce controller at that time and its use of data
compression on the controller. The latest Sandforce controllers also
utilise data deduplication on the SSD!


OCZ Agility 3 (240GB) Review
http://www.anandtech.com/print/4346

Shows an example set of Performance vs Transfer Size graphs.


=46lashy fists fly as OCZ and DDRdrive row over SSD performance
http://www.theregister.co.uk/2011/01/14/ocz_and_ddrdrive_performance_ro=
w/

Shows an old and unfair comparison highlighting SSD performance
degradation due to write amplification for 4kByte random writes on a
full device.



A bit of a "Joker" in the pack are the SSDs that implement their own
controller-level data compression and data deduplication (all
proprietary and secret...). Ofcourse, that is all useless for encrypted
filesystems... Also, what does the controller based data compression do
for aligning to the underlying device blocks?


What is apparent from all that lot is that 4kBytes is a bit of a
headache for SSDs. Perhaps we should all move to a more sympathetic
aligned 16kBytes or 32kBytes?

What's the latest state of play with btrfs for selecting a sector size
of say 16kBytes?

Regards,
Martin



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
