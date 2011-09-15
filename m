From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Thu, 15 Sep 2011 21:37:24 +0200
Message-ID: <4E7253F4.9020005@gmail.com>
References: <4E64D3D5.7020407@petaramesh.org> <15663472.1RTxtZJx8a@tethys> <CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com> <1411501.d4mgBNBG2i@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Fajar A. Nugraha" <list@fajar.net>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1411501.d4mgBNBG2i@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs since one year now and it's quite fast. I don't feel an=
y=20
differences to other filesystems. Never tried a benchmark but for my=20
daily work it's nice. I also never had any issues with the memory. Imho=
=20
nowadays memory isn't a problem at all in desktop computers. I bought=20
8gb of memory 2 years before because it was so damn cheap. Never used=20
that mutch, but it was almost for free :)

The advantage to ext4 for me is the build in raid1 and the snapshots.=20
I'm using the snapshot feature for my local backups. I like it because=20
it's really easy and uses very few storage. A simple "Snapshot -> Rsync=
=20
to a different disk -> Snapshot" script is the perfect local backup met=
hod.

I really appreciate the work of the developers! Btrfs is great and I'm=20
110% sure it will become better and better over the next month.

Best regards,
=46elix

On 9/7/11 4:15 PM, Sw=E2mi Petaramesh wrote:
> Le Mercredi 7 Septembre 2011 00:11:25 vous avez =E9crit :
>> Reading your post, at this point I'd actually recommend you stick wi=
th
>> ext4.
>
> I actually shifted back from BTRFS to ext4 and fell like having offer=
ed myself
> a brand new computer,  about 20 times faster, me happy ;-)
>
>> Both btrfs and zfs are great, but IMHO btrfs is not ready for
>> daily use by "ordinary" user yet, while zfs is a memory hog
>> (especially for laptops, which is part of the reason why I'm using
>> btrfs instead of zfs on this one).
>
> True, ZFS is excellent but a memory hog (and strongly advises using a=
 64-bit
> OS) but I was surprised to discover that BTRFS was such a memory eate=
r itself,
> with kernel 3.0. My system was swapping like mad !
>
> I use (kernel) ZFS on my 64-bit main machine and I'm plain happy with=
 it, and
> tried ZFS on my 32-bit laptop in the hope to get more performance for=
 less
> memory ; alas I just got a memory-hungry system running damn slow... =
=46or the
> time being I will stick to ZFS for 64-bit machines with>=3D 4GB RAM, =
and to
> ext4 for 32-bit systems with less RAM...
>
> I don't feel that BTRFS gives any advantage in its current state of
> development. Alas.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
