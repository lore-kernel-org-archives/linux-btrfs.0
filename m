Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874E6C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 05:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520FD217FA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 05:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfBLFOR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 00:14:17 -0500
Received: from mout.gmx.net ([212.227.15.19]:60775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfBLFOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 00:14:16 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MNIAz-1h0I9p0hYn-006vmo; Tue, 12
 Feb 2019 06:14:09 +0100
Subject: Re: [PATCH v2 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20190111050151.982-1-wqu@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <bd51a34e-0d80-0e89-36cd-6256c77067ab@gmx.com>
Date:   Tue, 12 Feb 2019 13:14:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190111050151.982-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LJ9UnL0qn6DAFhjE1rnPeyP9K9As3mS52"
X-Provags-ID: V03:K1:AXkT5tDEQKmi+1AdirBwBDLwJLm6hDIrJ9U8QNGhjSXf/cS+Wvj
 ee6JcnoXO35ohiK7ULqWjqEdxtKvhAMLZq+c14Vz2TGOD8glC7sdx+/BXaO6SyEHY8WW3JR
 TfbnSwtqXKKVDHlrbbOxbFrO8r4TO3a37e925dNCoyEk+lBKbYOtaHKxNXkDk+sX7I5pyPX
 lV4ZUiPpbaMN3b7aoKtuQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bL4KMc9ePZs=:L8Tem6dUMr8wEKv9BZHV/6
 cGoUga4D6m9RBYs/wiixGbsLWh2JKHPhom4NbC0oPJNtpRdwLS2+NCPGU9bELjmyVecsQaM8W
 MZEecQ8moQiSIr7gOw0j4sTy5ZO6VRwQl3on4UQl/ZlB0eO02koK3ZJyNpI8LFXulbZ9/SjRQ
 E+aLWH9iiYqoKQQn5B4wnzqxzy9vqQgHVIkhsG2ufiLbPBZ3xuPKfVBNyr2vhqKWQLJAlAYad
 xdq54sO3y18bgfaq0T7qRK2kpynuNX/GeDvw20xP91vK+qVzwqyYYpb+KfOKqrChD1TEOYWMA
 RUUeAso6yYISJjMHqov85J/c1wNUvRfStVKCe7aZXHXlj0iGKah4MBUxng0QcGyD4ruIqOQif
 QgW+0Mv5mH3+64amRftmpk1bGDs7fMeNDA56qPVtxMRrJgsxFRgYydexTE/JkmPANozotox9r
 EvgOVi6CmeLv3QhUwjczwjuqzAeH+EPt1/Yb1GKpZht0r2lTs1ZBumDEjKV9Tc3TcSNCVRl7V
 5/Vt5y29Xkq7RyIJsNsi0w16lZqSMzv46sgkHgem4geMitUKJ81pmkfUJQ3GPdlLi9VoeqKkO
 4C2YTPTX9xod/TQsuS+rX7QXoqdrMoT0Iy6shYmoiONoOyTJG7qjCsrJEMOr1q3Pacc4uUqvf
 NiQASBQLYmJv4KZZ6aa1f5hw1zyhySbuSTQQD+JNmhqu1SqIVGTLzlTPRYaFYWoW7WwoQIEAz
 dPfyJpX2F9a7RzjJU2yTesF2DLuSFAApJMPL7x6HkzhNlFB7CN+M//oTzjB87zsDlN5z1gw6S
 27JM2KZDfNE/Mme/sIYAydSHlAFEQ309NdJ7wEJZPgvlSQCiKHmEuwO+P4wJ2uNnI+LfIwm4l
 CqPy9nztqvoIFRTioGctqiwH4g//14yNYQvkaxGFcUnO7gECWLWeH9uAveRsQ9
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LJ9UnL0qn6DAFhjE1rnPeyP9K9As3mS52
Content-Type: multipart/mixed; boundary="QLIxW8TzNEsBG8VbJJIALFeiDYuDWh1wT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <bd51a34e-0d80-0e89-36cd-6256c77067ab@gmx.com>
Subject: Re: [PATCH v2 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
References: <20190111050151.982-1-wqu@suse.com>
In-Reply-To: <20190111050151.982-1-wqu@suse.com>

--QLIxW8TzNEsBG8VbJJIALFeiDYuDWh1wT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/11 =E4=B8=8B=E5=8D=881:01, Qu Wenruo wrote:
[snip]
> +# FS QA Test 179
> +#
> +# Test if btrfs will lockup at subvolume deletion when qgroups are ena=
bled.
> +#
> +# This bug is going to be fixed by a patch for the kernel titled
> +# "btrfs: qgroup: Don't trigger backref walk at delayed ref insert tim=
e".

Although the test case is already merged, btrfs community is going to
use a much better fix than this.

Should I update the patch in this test case after the fix get merged
upstream?

Thanks,
Qu

> +#
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +# default sleep interval
> +sleep_time=3D1
> +
> +# stress test runtime
> +runtime=3D120
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +mkdir -p "$SCRATCH_MNT/snapshots"
> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
> +$BTRFS_UTIL_PROG quota enable "$SCRATCH_MNT" > /dev/null
> +$BTRFS_UTIL_PROG quota rescan -w "$SCRATCH_MNT" > /dev/null
> +
> +fill_workload()
> +{
> +	trap "wait; exit" SIGTERM
> +	local i=3D0
> +	while true; do
> +		_pwrite_byte 0xcd 0 8K "$SCRATCH_MNT/src/large_$i" > /dev/null
> +		_pwrite_byte 0xcd 0 2K "$SCRATCH_MNT/src/inline_$i" > /dev/null
> +
> +		# Randomly remove some files for every 5 loop
> +		if [ $(( $i % 5 )) -eq 0 ]; then
> +			victim=3D$(ls "$SCRATCH_MNT/src" | sort -R | head -n1)
> +			rm "$SCRATCH_MNT/src/$victim"
> +		fi
> +		i=3D$((i + 1))
> +	done
> +}
> +
> +snapshot_workload()
> +{
> +	trap "wait; exit" SIGTERM
> +	local i=3D0
> +	while true; do
> +		sleep $sleep_time
> +		$BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src" \
> +			"$SCRATCH_MNT/snapshots/$i" > /dev/null
> +		i=3D$((i + 1))
> +	done
> +}
> +
> +delete_workload()
> +{
> +	trap "wait; exit" SIGTERM
> +	while true; do
> +		sleep $((sleep_time * 2))
> +		victim=3D$(ls "$SCRATCH_MNT/snapshots" | sort -R | head -n1)
> +		$BTRFS_UTIL_PROG subvolume delete \
> +			"$SCRATCH_MNT/snapshots/$victim" > /dev/null
> +	done
> +}
> +
> +fill_workload &
> +fill_pid=3D$!
> +
> +sleep $((sleep_time * 2))
> +snapshot_workload &
> +snapshot_pid=3D$!
> +delete_workload &
> +delete_pid=3D$!
> +
> +sleep $runtime
> +kill $fill_pid
> +wait $fill_pid
> +kill $snapshot_pid
> +wait $snapshot_pid
> +kill $delete_pid
> +wait $delete_pid
> +
> +# success, all done
> +echo "Silence is golden"
> +
> +status=3D0
> +exit
> diff --git a/tests/btrfs/179.out b/tests/btrfs/179.out
> new file mode 100644
> index 000000000000..cb9eba3d34b1
> --- /dev/null
> +++ b/tests/btrfs/179.out
> @@ -0,0 +1,2 @@
> +QA output created by 179
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 04c0254aa4bf..46dd3c9523c2 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -181,3 +181,4 @@
>  176 auto quick swap volume
>  177 auto quick swap balance
>  178 auto quick send
> +179 auto qgroup dangerous
>=20


--QLIxW8TzNEsBG8VbJJIALFeiDYuDWh1wT--

--LJ9UnL0qn6DAFhjE1rnPeyP9K9As3mS52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxiVhoACgkQwj2R86El
/qhqHQf9GAet+YICcPUI4omZXsV0eRoEQGwUiku2ds371XcGqP5ckaOkH1bBYyLY
D65+wrW1a1HSBlI0poZFc2p8wA/BGcDMOAv+j8Dr67Sx2oSw+kJKNFl958vsQUjz
6TL3tmb461I6U2KEQwbyRBH892f6XXzf/lDa1WEpydKEd5MAygnzwiCH1Q1SQF6L
/jShdnlFMgxXY/wOtAf0K5p1EFecra4tvhQbcRmToGpscsAGrghyf7DB6fpLppFj
HwvFS/OW0P/YgkscQXJMTcKubLBg97G/eoyOfrLBeu/bWRaZjx+9BlyjozALdxwJ
ZGm/YkUuYGj8WK16rclyte5Tbms3Iw==
=dgxw
-----END PGP SIGNATURE-----

--LJ9UnL0qn6DAFhjE1rnPeyP9K9As3mS52--
