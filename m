From: "Providence M. SALUMU" <providence.salumu@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1657!
Date: Sun, 31 Jul 2011 23:47:27 +0200
Message-ID: <CAHzCyiSpJ3LZkmh1H3chdkEGpqxBACnjREcnNySreMpEsnLQQw@mail.gmail.com>
References: <CAHzCyiQs27_fX1ifnMEO=8asYZbYot794m5cFBByOnpADFAVyg@mail.gmail.com>
	<20110731105459.GA28326@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	"Providence M. SALUMU" <providence.salumu@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110731105459.GA28326@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Thanks a lot for this tip, it worked!!!!!

2011/7/31 Hugo Mills <hugo@carfax.org.uk>:
> On Sun, Jul 31, 2011 at 10:01:50AM +0200, Providence M. SALUMU wrote:
>> A few days back, I had a hard reset of my computer while syncing my
>> data with rsync -avz. I am using btrfs as the rootfs, and since then=
 I
>> can't mount my filesystem anymore. mount -t btrfs segfaults!
>> Btrfs version in use and dmesg traces follow...
>>
>> Can someone help figure out what is wrong?
> [snip]
>> Call Trace:
>> [<ffffffffa0536f70>] ? walk_down_log_tree+0x204/0x3eb [btrfs]
>> [<ffffffffa053721f>] ? walk_log_tree+0xc8/0x213 [btrfs]
>> [<ffffffffa05382b4>] ? btrfs_recover_log_trees+0x1d3/0x2e0 [btrfs]
>
> =C2=A0 This looks like a corrupt log tree. Fortunately, we have a too=
l
> that will deal with this: grab a copy of the btrfs-progs sources,
> build btrfs-zero-log, and run that on your filesystem. That _should_
> get you to the point of being able to mount it.
>
> =C2=A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 =C2=A0 =C2=A0 --- He's playing Schubert. =C2=A0I think Schuber=
t is losing. ---
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFONTSCIKyzvlFcI40RAkXqAJ9OoO5P3PgMRK/uZcCDJdXwPXJfpACeNe9T
> U6iFEa2JiAYoroJ7nOYTPCY=3D
> =3DRVpO
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
