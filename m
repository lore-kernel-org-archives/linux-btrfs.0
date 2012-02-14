From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Tue, 14 Feb 2012 16:18:43 +0200
Message-ID: <20120214141843.GA1987@zambezi.lan>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
 <CALJXSJpjmb2F=fg_KML_W61gRPfiFH8Drz-H+uukn9d4owdwTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: =?utf-8?B?SsOpcsO0bWU=?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJpjmb2F=fg_KML_W61gRPfiFH8Drz-H+uukn9d4owdwTg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2012 at 09:31:09PM -0500, J=C3=A9r=C3=B4me Poulin wrote=
:
> On Fri, Jan 6, 2012 at 9:30 AM, Ilya Dryomov <idryomov@gmail.com> wro=
te:
> > This is a respin of restriper patch series which adds an initial
> > implementation of restriper (it's a clever name for relocation fram=
ework
> > that allows to do selective profile changing and selective balancin=
g
> > with some goodies like pausing/resuming and reporting progress to t=
he
> > user). =C2=A0See userspace cover patch for usage examples.
>=20
> I just tried merging this on my kernel 3.2.1 and it seems to work
> nicely. I compiled your btrfs-progs, made an LVM snapshot and launche=
d
> a balance on my 300 GB filesystem converted from ext4. It worked for
> converting my metadata from single to dup, however, it didn't succeed
> converting my system from single to dup.
>=20
> Here is the command I used:
> root /usr/src/kernel/btrfs-progs # ./btrfs balance start -f -v
> -sconvert=3Ddup -mconvert=3Ddup /mnt/btrfs/
> Dumping filters: flags 0xe, state 0x0, force is on
>   METADATA (flags 0x100): converting, target=3D32, soft is off
>   SYSTEM (flags 0x100): converting, target=3D32, soft is off
> Done, had to relocate 28 out of 220 chunks
>=20
> Then tried:
> root /usr/src/kernel/btrfs-progs # ./btrfs balance start -f -v
> -sconvert=3Ddup /mnt/btrfs/
> Dumping filters: flags 0xa, state 0x0, force is on
>   SYSTEM (flags 0x100): converting, target=3D32, soft is off
> Done, had to relocate 0 out of 239 chunks

Yeah, that's known.  The old balancing code wasn't allowed to relocate
chunk 0 and always skipped it.  I decided to keep that limitation, it
will be lifted (or otherwise fixed) shortly.

Just to be sure, could you please paste the output of
`btrfs-debug-tree -d <your device>' somewhere ?

Thanks,

		Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
