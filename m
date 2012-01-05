From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to
 look behind the curtain
Date: Thu, 5 Jan 2012 14:35:00 +0100
Message-ID: <CABVOS0_3O8qZTEOuAvdbsCKfMJNKYS1C0dU2CL5=h5MVSWDe+A@mail.gmail.com>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com>
 <20120105094444.GF27122@carfax.org.uk> <DFD486DD-C324-43EE-82BC-87DDCF432DB6@gmail.com>
 <201201051139.20334.Martin@lichtvoll.de> <82FEA956-FFE4-4A00-B895-AA381A35FEE7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
To: Fabian Zeindl <fabian.zeindl@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <82FEA956-FFE4-4A00-B895-AA381A35FEE7@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 5, 2012 at 13:26, Fabian Zeindl <fabian.zeindl@gmail.com> w=
rote:
>
> On Jan 5, 2012, at 11:39 , Martin Steigerwald wrote:
>> "Allocating as many chunks as can fit across the drives" is also pre=
tty
>> clear to me. So if BTRFS can=C2=B4t allocate a new chunk on two devi=
ces, its
>> full. To me it seems obvious that BTRFS will not break the RAID-1
>> redundancy guarentee unless a drive fails.
>
> So (assuming 1GB chunksize):
>
> if i create a raid-1, btrfs with a 3GB and a 7GB device, it will show=
 me ~10GB free space,
> after saving a 1GB file, i will have 8GB left (-1GB on each device)
> after saving another 1GB, i will have 6GB left (--- " ----)
> after saving another 1GB, it's "suddenly" full?

you have still 4GB free of non RAID-1 (single) space, which is
currently unavailable, but it is planned that BTRFS will support mixed
storage:
some files can be RAID-1, some files can be RAID-0 and rest is basic
(single) storage

>
> Fabian--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
