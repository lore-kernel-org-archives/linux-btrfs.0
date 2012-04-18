From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH v3] btrfs: fix early abort in 'remount'
Date: Wed, 18 Apr 2012 18:28:27 -0400
Message-ID: <4F8F400B.7000800@suse.com>
References: <1334788058-435-1-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334788058-435-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/18/2012 06:27 PM, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Cc: Jeff Mahoney <jeffm@suse.com> Cc: Chris Mason
> <chris.mason@oracle.com> Reviewed-by: Josef Bacik
> <josef@redhat.com> Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>

Acked-by: Jeff Mahoney <jeffm@suse.com>

> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org> --- v1->v2:
> fixed indentation of 'if (cond) {' suggested by Liu Bo v2->v3:
> added 'Reviewed-by' fs/btrfs/super.c |    6 ++++-- 1 files changed,
> 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c index
> 8d5d380..2f28fc0 100644 --- a/fs/btrfs/super.c +++
> b/fs/btrfs/super.c @@ -1148,13 +1148,15 @@ static int
> btrfs_remount(struct super_block *sb, int *flags, char *data) if
> (ret) goto restore; } else { -		if (fs_info->fs_devices->rw_devices
> == 0) +		if (fs_info->fs_devices->rw_devices == 0) { ret =
> -EACCES; goto restore; +		}
> 
> -		if (btrfs_super_log_root(fs_info->super_copy) != 0) +		if
> (btrfs_super_log_root(fs_info->super_copy) != 0) { ret = -EINVAL; 
> goto restore; +		}
> 
> ret = btrfs_cleanup_fs_roots(fs_info); if (ret)


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPj0ALAAoJEB57S2MheeWyaAIP/itnoIX+TMcaNDakuduzN1V3
HQWG6z8fwN9Vj+U2KR0u3/zFWe/MJLY20Ec0FQznATYrBcg1as5Y/21kX0uopWVa
RDCmuAVna0rCBuMigG/Kum7cwM4tl3QllFczJF2ZkgrKkildPbfM4s6oscCNiAeo
Pg4yCMIB0z3ZJxYoVJSDxyuxapmhVMFqLgVZ/Idznh+YbLMa8XwQ0gnEkG92ZHeh
28JJKNOU+/UbUkv5OoRvHH596UZbF4WpFX76+1idEU9fSPCMPKlH5ABGSqcywG9K
rWDswD68Gw3JWX/XJCvHcN5h70zdYbZ16mUzUfKG4a4y5WuHIEe0PVC4z3fMIsyw
1hsJJro/x7lvgOYxZ+RBLXF1ghnzmYlYZRARh67jZwGffWeXgW2ubJrApy1/+qm8
Ohe/MOq4qFDBt8JXHaAU8rgffBNABvsqqg/riNsxwx7bVEBY6Mre40zUiKWL78vF
zsY8lsIFF+TCo3rKdlA7gpxWH4eubd/NmNIOYQUlWhEVmCAlITih/8IJ+gDDDjCb
oWygf25ARKqhfOYu5Fa37jaWL4Uov7FProXGNXSZmfebNmteJFtg1GstWnfpa/Z4
65ucrMAyDHxEmdqHtKocYYamA9wmm9vVk7L86gsq0RSNtrK3RX9kH8F9FYsBHrLF
G1xlB7mdweo4eG8c+DYN
=CjpG
-----END PGP SIGNATURE-----
