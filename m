From: Yuri D'Elia <wavexx@users.sf.net>
Subject: Building btrfs as a dkms module on Debian
Date: Tue, 15 Feb 2011 16:35:19 +0100
Message-ID: <20110215163519.d9c7f40f.wavexx@users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone. I was trying to test a more recent version of btrfs on my =
current kernel (2.6.37) using dkms, without success.

I followed these instructions:

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

- cloned the repo
- symlinked to /usr/src/btrfs-git
- patched version.sh:

Please note version.sh requires bash (better to change the shebang or f=
ix the script).
Even with the patch, version.sh run on a shallow repository generates a=
 "-dirty" version. I assume this is OK, even though there are no local =
changes.

- run version.sh
- dkms add -m btrfs -v git
- dkms build -m btrfs -v git fails with:

/var/lib/dkms/btrfs/git/build/extent-tree.c: In function =E2=80=98btrfs=
_issue_discard=E2=80=99:
/var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: =E2=80=98BLKDE=
V_IFL_WAIT=E2=80=99 undeclared (first use in this function)
/var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: (Each undeclar=
ed identifier is reported only once
/var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: for each funct=
ion it appears in.)
/var/lib/dkms/btrfs/git/build/extent-tree.c:1747: error: =E2=80=98BLKDE=
V_IFL_BARRIER=E2=80=99 undeclared (first use in this function)

I assume BLKDEV_IFL_WAIT/BARRIER was added in later kernels?
Is there a way to make it build btrfs for 2.6.37?

Thanks

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
