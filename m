From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 14:01:34 +0100
Message-ID: <201201051401.34609.Martin@lichtvoll.de>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com> <201201051139.20334.Martin@lichtvoll.de> <82FEA956-FFE4-4A00-B895-AA381A35FEE7@gmail.com> (sfid-20120105_135035_574776_CFFB5176)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
To: Fabian Zeindl <fabian.zeindl@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <82FEA956-FFE4-4A00-B895-AA381A35FEE7@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 5. Januar 2012 schrieb Fabian Zeindl:
> On Jan 5, 2012, at 11:39 , Martin Steigerwald wrote:
> > "Allocating as many chunks as can fit across the drives" is also
> > pretty clear to me. So if BTRFS can=B4t allocate a new chunk on two
> > devices, its full. To me it seems obvious that BTRFS will not break
> > the RAID-1 redundancy guarentee unless a drive fails.
>=20
> So (assuming 1GB chunksize):
>=20
> if i create a raid-1, btrfs with a 3GB and a 7GB device, it will show
> me ~10GB free space, after saving a 1GB file, i will have 8GB left
> (-1GB on each device) after saving another 1GB, i will have 6GB left
> (--- " ----)
> after saving another 1GB, it's "suddenly" full?

I would say yes, but suggest that you try this out or wait for confirma=
tion=20
of a BTRFS developer if you can to be sure about this. The other way of=
=20
handling this would be to break the RAID-1 redundancy guarentee and I=20
really hope that BTRFS is not doing this. I am not completely sure toug=
h=20
as I never tested it.

The output of df -h with BTRFS and RAID is bogus anyway.

Just consider df -h with two 10GB disks. df -H will display about 20GB=20
free then. But when you write 100 MB it will show that 200 MB are=20
allocated. So an application that assumes it will be able to write 12 G=
B=20
easily will just fail doing that.

I don=B4t like this either, cause an application that writes something=20
cannot even do a rough estimate. But then an application can never now=20
whether a write will succeed cause another application could also write=
=20
lots of data in the same time.

But even without RAID I cannot get exaxt figures from df. Just consider=
:

merkaba:~> btrfs filesystem show=20
failed to read /dev/sr0
Label: 'debian'  uuid: dd52fea8-f6c3-4a60-bd4a-7650483655e5
        Total devices 1 FS bytes used 11.35GB
        devid    1 size 18.62GB used 18.29GB path /dev/dm-0

Btrfs Btrfs v0.19
merkaba:~> btrfs filesystem df /=20
Data: total=3D14.01GB, used=3D10.55GB
System, DUP: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D2.12GB, used=3D814.32MB
Metadata: total=3D8.00MB, used=3D0.00
merkaba:~> df -hT /             =20
Dateisystem                Typ   Gr=F6=DFe Benutzt Verf. Verw% Eingeh=E4=
ngt auf
/dev/mapper/merkaba-debian btrfs   19G     13G  3,8G   77% /
merkaba:~> df -HT /
Dateisystem                Typ   Gr=F6=DFe Benutzt Verf. Verw% Eingeh=E4=
ngt auf
/dev/mapper/merkaba-debian btrfs   20G     14G  4,1G   77% /
merkaba:~>

So how much space is free?

df just seems to reflect the size of the data, system and metadata b-tr=
ees,=20
not their usage. Cause at least for me 10.55 GB, 4 KB and 814 KB just d=
o=20
not add up to 13 / 14 GB - I am not sure whether btrfs command uses 102=
4=20
or 1000 as base.

So actually in this case I just be able to write more to the filesystem=
=20
than df -hT tells me.

I prefer this over the other way around with RAID-1 where I just can wr=
ite=20
about half of the size that df reports.

So or so the current df output is bogus.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
