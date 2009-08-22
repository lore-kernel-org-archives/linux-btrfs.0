From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID[56] with arbitrary numbers of "parity" stripes.
Date: Sat, 22 Aug 2009 18:31:16 +0200
Message-ID: <FB53229A-142C-40B1-B946-0AC496D7A2A5@karlsbakk.net>
References: <1249502665.23206.5.camel@macbook.infradead.org> <84fb38e30908220834pab3f891we9ca7114a16988c0@mail.gmail.com>
Reply-To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <84fb38e30908220834pab3f891we9ca7114a16988c0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 22. aug.. 2009, at 17.34, tsuraan wrote:

>> We discussed using the top bits of the chunk type field field to =20
>> store a
>> number of redundant disks -- so instead of RAID5, RAID6, etc., we =20
>> end up
>> with a single 'RAID56' flag, and the amount of redundancy is stored
>> elsewhere.
>
> Is there any sort of timeline for RAID5/6 support in btrfs?  I
> currently have 8 drives in a zfs-fuse RAIDZ2 (RAID6) configuration,
> and I'd love to see how btrfs compares to that, once it's ready.


I think someone started doing RAID[56] (see threads "A start at =20
RAID[56] support" and perhaps "Factor out RAID6 algorithms into lib/". =
=20
Seems something is in the works.

By the way - how does FUSE ZFS work? Is it stable? Good performance? =20
We're using ZFS natively on Solaris 10 now, perhaps moving the storage =
=20
to opensolaris soon.

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres =20
intelligibelt. Det er et element=E6rt imperativ for alle pedagoger =E5 =
=20
unng=E5 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de =20
fleste tilfeller eksisterer adekvate og relevante synonymer p=E5 norsk.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
