From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: corrupted btrfs volume: parent transid verify failed
Date: Mon, 15 Aug 2011 04:40:19 +0700
Message-ID: <CAG1y0seN15Yz0O3Dt+oPs5Se4vuzwVWt74pxAGNx5h2yCLko6w@mail.gmail.com>
References: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
	<CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 15, 2011 at 4:13 AM, Yalonda Gishtaka
<yalonda.gishtaka@gmail.com> wrote:
> Halp!=A0 I was recently forced to power cycle my desktop PC, and upon
> restart, the btrfs /home volume would no longer mount, citing the
> error "BUG: scheduling while atomic: mount /5584/0x000000002".=A0 I
> retrieved the latest btrfs-progs git repositories from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unsta=
ble.git
> and http://git.darksatanic.net/repo/btrfs-progs-unstable.git -b
> integration-20110805, but when running "sudo ./btrfsck -s 1
> /dev/mapper/home" from either repo builds, I receive the error "paren=
t
> transid verify failed on 647363842048 wanted 210333 found 210302"
> (repeated 3x).=A0 I've also tried the flags -s 0, -s 1, and -s 2, all
> with the same results.

Is there something in the log about replaying log? If yes, try btrfs-ze=
ro-log
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
