From: Yalonda Gishtaka <yalonda.gishtaka@gmail.com>
Subject: Re: corrupted btrfs volume: parent transid verify failed
Date: Sun, 14 Aug 2011 23:13:33 +0200
Message-ID: <CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
References: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Halp!=A0 I was recently forced to power cycle my desktop PC, and upon
restart, the btrfs /home volume would no longer mount, citing the
error "BUG: scheduling while atomic: mount /5584/0x000000002".=A0 I
retrieved the latest btrfs-progs git repositories from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstabl=
e.git
and http://git.darksatanic.net/repo/btrfs-progs-unstable.git -b
integration-20110805, but when running "sudo ./btrfsck -s 1
/dev/mapper/home" from either repo builds, I receive the error "parent
transid verify failed on 647363842048 wanted 210333 found 210302"
(repeated 3x).=A0 I've also tried the flags -s 0, -s 1, and -s 2, all
with the same results.

I take care to complete a full dd copy of my disk every 2 weeks, but
my previous backup is nearly 2 weeks old and I've put in almost 2
weeks of effort on my masters thesis since then.=A0 I'm quite desperate
to recover this volume.=A0 Any help is appreciated, as I've exhausted
the existing suggestions from the mailing list posts to date.=A0 I've
tried to ask in #btrfs, but suspect that they're all sleepy bearded
people :(

Regards,
-Yalonda
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
