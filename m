From: Yalonda Gishtaka <yalonda.gishtaka@gmail.com>
Subject: Re: corrupted btrfs volume: parent transid verify failed
Date: Mon, 15 Aug 2011 00:05:39 +0200
Message-ID: <CABqt_RMTrFVb8MUds2U2FgbZx=oisL61Sv3moW66f8=jORkMnA@mail.gmail.com>
References: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
	<CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
	<CAG1y0seN15Yz0O3Dt+oPs5Se4vuzwVWt74pxAGNx5h2yCLko6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0seN15Yz0O3Dt+oPs5Se4vuzwVWt74pxAGNx5h2yCLko6w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

=46ajar,

Thank you for the suggestion.  Unfortunately, running "sudo
=2E/btrfs-zero-log /dev/mapper/home" results in the same "parent transi=
d
verify failed on 647363842048 wanted 210333 found 210302" errors,
repeated 3 times.

I am running Arch Linux with the latest 3.0.1 kernel on a x86_64 machin=
e.

Regards,
-Yalonda

On Sun, Aug 14, 2011 at 11:40 PM, Fajar A. Nugraha <list@fajar.net> wro=
te:
> On Mon, Aug 15, 2011 at 4:13 AM, Yalonda Gishtaka
> <yalonda.gishtaka@gmail.com> wrote:
>> Halp!=A0 I was recently forced to power cycle my desktop PC, and upo=
n
>> restart, the btrfs /home volume would no longer mount, citing the
>> error "BUG: scheduling while atomic: mount /5584/0x000000002".=A0 I
>> retrieved the latest btrfs-progs git repositories from
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unst=
able.git
>> and http://git.darksatanic.net/repo/btrfs-progs-unstable.git -b
>> integration-20110805, but when running "sudo ./btrfsck -s 1
>> /dev/mapper/home" from either repo builds, I receive the error "pare=
nt
>> transid verify failed on 647363842048 wanted 210333 found 210302"
>> (repeated 3x).=A0 I've also tried the flags -s 0, -s 1, and -s 2, al=
l
>> with the same results.
>
> Is there something in the log about replaying log? If yes, try btrfs-=
zero-log
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
>
> --
> Fajar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
