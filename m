From: David Nicol <davidnicol@gmail.com>
Subject: Re: BTRFS should increase the hard-link in the same directory limit
Date: Tue, 23 Aug 2011 10:29:55 -0500
Message-ID: <CAFwScO95=r8UUzmKRY-umKXBFP-PyPt9oafqMAxqEBR12vAL1w@mail.gmail.com>
References: <874o1aztkm.fsf-genuine-vii@john.fremlin.org> <m3bovio1wp.fsf@jhcloos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, John Fremlin <john@fremlin.org>
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3bovio1wp.fsf@jhcloos.com>
List-ID: <linux-btrfs.vger.kernel.org>

so there are these hundreds of message files, and when one is read, a
new link to The Markfile appears with a similar name as the read file?
Is that right?
if the point is to save inodes by making a directory entry that's a
hardlink to something already existing, why not link to the message
file?

On Sun, Aug 21, 2011 at 5:05 PM, James Cloos <cloos@jhcloos.com> wrote:
>>>>>> "JF" =3D=3D John Fremlin <john@fremlin.org> writes:
>
> JF> instead of creating a separate inode for each marked message, use=
s a
> JF> hardlink to a single markfile. This means that there maybe thousa=
nds
> JF> of hardlinks to the same inode in a single directory.
>
> And that behaviour is not limited to gnus. =C2=A0Many workflows use t=
hat idiom.
>
> -JimC
> --
> James Cloos <cloos@jhcloos.com> =C2=A0 =C2=A0 =C2=A0 =C2=A0 OpenPGP: =
1024D/ED7DAEA6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
"The tools expect that they have full, unlimited control of the hardwar=
e."
=C2=A0-- Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
