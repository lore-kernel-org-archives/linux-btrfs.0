Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbbJWPYw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 11:24:52 -0400
Subject: Re: [RFC PATCH 2/3] btrfs-progs: kernel based default features for
 mkfs
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <1445417149-804-2-git-send-email-anand.jain@oracle.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <562A5140.20306@suse.com>
Date: Fri, 23 Oct 2015 11:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <1445417149-804-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/21/15 4:45 AM, Anand Jain wrote:
> mkfs from latest btrfs-progs will enable latest default features, 
> and if the kernel is down-rev and does not support a latest
> default feature then mount fails, as expected.
> 
> This patch disables default features based on the running kernel.

I like the idea generally based on comments further in the thread, but
what I don't like is:

1) It's silent.
2) There's no way to override it.

If we're going to change the defaults at runtime, we should tell the
user what has changed and why.  Otherwise, an identical mkfs.btrfs
binary will behave differently on different systems without feedback
and that violates the principle of least surprise.  If they want to do
what Qu suggests later in the thread, where the device is being
prepared for use on a newer kernel, it should be possible to force it.
 The normal -f should be fine there.

- -Jeff

> Signed-off-by: Anand Jain <anand.jain@oracle.com> --- mkfs.c | 5
> ++++- 1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs.c b/mkfs.c index a5802f7..2b9d734 100644 ---
> a/mkfs.c +++ b/mkfs.c @@ -1357,10 +1357,13 @@ int main(int ac, char
> **av) int dev_cnt = 0; int saved_optind; char
> fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 }; -	u64 features =
> BTRFS_MKFS_DEFAULT_FEATURES; +	u64 features; struct mkfs_allocation
> allocation = { 0 }; struct btrfs_mkfs_config mkfs_cfg;
> 
> +	features = btrfs_features_allowed_by_kernel(); +	features &=
> BTRFS_MKFS_DEFAULT_FEATURES; + while(1) { int c; static const
> struct option long_options[] = {
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJWKlE/AAoJEB57S2MheeWy2mAP/33RvA9174u0PRmh+RBorZDC
p3nDFFxS7pI5u7rSkFqUvbsKy9AoblUvgMYS8pDNkFokDML2hbH3HaYWFEmqvMch
mp9DQ+wKz5hI5fYt/wgDdtVO6X0E3TCm2Cj1Uw4fl7E0bMzgNgio8tnOoGTrHGa5
YkZ96L9UWzEScv9EtesO3DLbUC+O3pokyHsHCdBRVgEwLcLB1AtmPrQmhc2a1+M4
sfzElmbo9Rld/xmtI4ecHl1sWbpfrYcKimzV32Jdv/SNhEyPuFOcN6/GUDOrGE7o
Vs87+HtuXUr+CbFUM9r9wB1Nqj4yYJ78LnBfepBMjY9vWyAgPR49WFPRA/uhkvu/
uOd4DNgUbLktakztsMb1GRiS/6AEj6s8mHFzkOrS5b9E/RbwegWgcnpnWCveFcDO
Nsfa6Mg99X7ojuXeMi8c00Jins70uSnh/dLOtP5JYkxTAf8v5znbouYYawBZLHAi
P0KbIpQFmW+Qm9is1CDVZktnj79BFMcd+twMFQu/m9jhYdLUFqeEFCJ+sxCGcmoM
n18ayAzbvCQCYz5dBOk2EQPgQoQKJGEOdc4IY0GdRcOwNcbw2hWbwbfGjLAKpLrA
PVC8YmRsyT1CotXBXJEpn7jYFR2fnDOyO/5jq1JRDa6Mxeq3dECIRWof3pwQLnpI
boQXIGHUlVWltF+hla3C
=TG+F
-----END PGP SIGNATURE-----
