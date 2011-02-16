From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: Building btrfs as a dkms module on Debian
Date: Wed, 16 Feb 2011 10:51:43 +0800
Message-ID: <4D5B3BBF.6020702@cn.fujitsu.com>
References: <20110215163519.d9c7f40f.wavexx@users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Yuri D'Elia" <wavexx@users.sf.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110215163519.d9c7f40f.wavexx@users.sf.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2011 11:35 PM, Yuri D'Elia wrote:
> Hi everyone. I was trying to test a more recent version of btrfs on m=
y current kernel (2.6.37) using dkms, without success.
>=20
> I followed these instructions:
>=20
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>=20
> - cloned the repo
> - symlinked to /usr/src/btrfs-git
> - patched version.sh:
>=20
> Please note version.sh requires bash (better to change the shebang or=
 fix the script).
> Even with the patch, version.sh run on a shallow repository generates=
 a "-dirty" version. I assume this is OK, even though there are no loca=
l changes.
>=20
> - run version.sh
> - dkms add -m btrfs -v git
> - dkms build -m btrfs -v git fails with:
>=20
> /var/lib/dkms/btrfs/git/build/extent-tree.c: In function =E2=80=98btr=
fs_issue_discard=E2=80=99:
> /var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: =E2=80=98BLK=
DEV_IFL_WAIT=E2=80=99 undeclared (first use in this function)
> /var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: (Each undecl=
ared identifier is reported only once
> /var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: for each fun=
ction it appears in.)
> /var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: =E2=80=98BLK=
DEV_IFL_BARRIER=E2=80=99 undeclared (first use in this function)
>=20
> I assume BLKDEV_IFL_WAIT/BARRIER was added in later kernels?
> Is there a way to make it build btrfs for 2.6.37?

in commit fbd9b09a177a481eda256447c881f014f29034fe:
include/linux/blkdev.h:

#define BLKDEV_IFL_WAIT         (1 << BLKDEV_WAIT)
#define BLKDEV_IFL_BARRIER      (1 << BLKDEV_BARRIER)
#define BLKDEV_IFL_SECURE       (1 << BLKDEV_SECURE)

Maybe this is helpful.:)

thanks,
liubo

>=20
> Thanks
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
