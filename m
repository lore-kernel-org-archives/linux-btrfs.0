From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs support for efficient SSD operation (data blocks alignment)
Date: Fri, 10 Feb 2012 19:18:57 +0100
Message-ID: <201202101918.57855.Martin@lichtvoll.de>
References: <jgui4j$th5$1@dough.gmane.org> (sfid-20120208_204940_752385_3F40C11C)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jgui4j$th5$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

Am Mittwoch, 8. Februar 2012 schrieb Martin:
> My understanding is that for x86 architecture systems, btrfs only
> allows a sector size of 4kB for a HDD/SSD. That is fine for the
> present HDDs assuming the partitions are aligned to a 4kB boundary fo=
r
> that device.
>=20
> However for SSDs...
>=20
> I'm using for example a 60GByte SSD that has:
>=20
>     8kB page size;
>     16kB logical to physical mapping chunk size;
>     2MB erase block size;
>     64MB cache.
>=20
> And the sector size reported to Linux 3.0 is the default 512 bytes!
>=20
>=20
> My first thought is to try formatting with a sector size of 16kB to
> align with the SSD logical mapping chunk size. This is to avoid SSD
> write amplification. Also, the data transfer performance for that
> device is near maximum for writes with a blocksize of 16kB and above.
> Yet, btrfs supports a 4kByte page/sector size only at present...

Thing is as far as I know the better SSDs and even the dumber ones have=
=20
quite some intelligence in the firmware. And at least for me its not cl=
ear=20
what the firmware of my Intel SSD 320 all does on its own and whether a=
ny=20
of my optimization attempts even matter.

So I am not sure, whether just thinking about one write operation of sa=
y 4=20
KB or 2 KB singularily even may sense. I bet often several processes wr=
ite=20
data at once. So there is more amount of data to write.

What now is not clear to me whether the SSD will combine several write=20
requests into a single mapping chunk or erase block or combine them int=
o=20
the already erased space of an erase block. I would bet at least the=20
better SSDs would do it. So even when from the OS point of view, in a=20
simplistic example, one write of 1 MB goes to LBA 40000 and one write o=
f 1=20
MB to LBA 80000 the SSD might still just use a single erase block and=20
combine the writes next to each other. As far as I understand SSDs do C=
OW=20
to spread writes evenly across erase blocks. As far as I furtherly=20
understand from a seek time point of view the exact location where to p=
ut=20
a write request does not matter at all. So for me for an SSD firmware i=
t=20
looks perfectly sane to combine writes as they see fit. And SSDs that c=
arry=20
condensators, like above mentioned Intel SSD, may even cache writes for=
 a=20
while to wait for further requests.

The article on write amplication on wikipedia gives me a glimpse of the=
=20
complexity involved=B9. Yes, I set stripe-width as well on my Ext4=20
filesystem, but frankly said I am not even sure whether this has any=20
positive effect except of maybe sparing the SSD controller firmware som=
e=20
reshuffling work.

So from my current point of view most of what you wrote IMHO is more=20
important for really dumb flash. Like as I understood some kernel=20
developers really like to see so that most of the logic could be put in=
to=20
the kernel and be easily modifyable: JBOF - just a bunch of flash cells=
=20
with an interface to access them directly. But for now AFAIK most consu=
mer=20
grade SSDs just provide a SATA interface and hide the internals. So an=20
optimization for one kind or one brand of SSDs may not be suitable for=20
another one.

There are PCI express models but these probably aren=B4t dumb either. A=
nd=20
then there is the idea of auto commit memory (ACM) by Fusion-IO which j=
ust=20
makes a part of the virtual address space persistent.

So its a question on where to put the intelligence. For current SSDs is=
=20
seems the intelligence is really near the storage medium and then IMHO =
it=20
makes sense to even reduce the intelligence on the Linux side.

[1] http://en.wikipedia.org/wiki/Write_amplification

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
