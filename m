From: Hubert Kario <kario@wit.edu.pl>
Subject: Re: btrfs-progs: integration branch updated
Date: Fri, 1 Jul 2011 09:35:26 +0200
Message-ID: <201107010935.26784.kario@wit.edu.pl>
References: <20110630211902.GC4352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630211902.GC4352@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 30 of June 2011 23:19:02 Hugo Mills wrote:
>    After a reorganisation of patches, and sending a bunch of them to
> Chris, I've also updated the integration branch to match that. It's
> available from:
>=20
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> integration-20110630
>=20
>    The shortlog of 17 patches in this branch beyond the ones I've sen=
t
> to Chris is below.
>=20
>    Hugo.

Is there a reason why my patch for compilation errors=20
(http://www.spinics.net/lists/linux-btrfs/msg10965.html)
isn't integrated? Without it, I can't compile btrfs-progs with new gcc=20
(4.6.0 20110429):

volumes.c: In function =E2=80=98btrfs_alloc_data_chunk=E2=80=99:
volumes.c:891:6: error: variable =E2=80=98physical=E2=80=99 set but not=
 used [-Werror=3Dunused-but-set-variable]
cc1: all warnings being treated as errors

Regards,
Hubert
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
