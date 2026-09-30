Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374FB535FBC
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804998; cv=none; b=WnmiBS1hZ0pjBCLh8Cf9fekJBYX5hrZI8tbdB6iFwaDFaVFVfWc8M4/AAWPrzEZM+xPhuSMOfE3NxSNUOWRAU/rTo2VqV6LeogIVB/gKE/+Bo3Fq2F/cBFz/t361XRKxZpa8qzw8A3w8VUzvMKBKVfYGm+lUlr5GHSCJybWKzUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804998; c=relaxed/simple;
	bh=p5X+yusvD8XIxUpKNAsOOLzYKJV664obkfiPxBliCX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qc+RIlXpJdH59mrGfS3ONF6iZNdi1E9Ep5egXvAgWqpDzztw37xPo87t7ZI16+CvM71oAHChsuxZcKs4Ic3e5X1TxqubEg0NHUA9wi0D3LeWPaS7FpVAqFAJ9EaMBkUThDGieHPBhl8h3pCI6jRrx4+N/NiWyrtFrqmsXTOVFOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=lVvsnmjc; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="lVvsnmjc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790804993; x=1791409793; i=quwenruo.btrfs@gmx.com;
	bh=EpDzEsti/9RkMpV8Fzjn+l74t/w6uVyXKyCkx1bxKXI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lVvsnmjcPUIMTz13xEapqr8yZhD7qpqAX+3OQuvtBvi74Y/4rl1ZABFjcdyGRwOq
	 L482Rqpsi1dENdnKU/YqQd/uExsLumOZOU9sZd3GUU3VqlguJvjBSEEUISkl8K58w
	 6UHa/xXfUFAuEyZHdzERvxixtDjIb8Yx1dZuIJyO+M5MYOmqAXb/djATGE6aAhrSo
	 BJubPTi/i+N5Zr7yjCOb7YFmjQ6luJjwnA6o8UvvjLkzOk+kEQgxOHkS9L+iJNcgQ
	 SnhDezYqemxcIoZZl5WXYzO7URhRQWRASWXgdjLj92uXRRuc7e5dLbi0hOhD4a7xm
	 CPdHXjuOz8oxiOie6A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N4QsY-1wl3Be1QdK-016Yii; Wed, 30
 Sep 2026 23:49:53 +0200
Message-ID: <9a46521c-8bb0-403e-b587-d8088020a0ea@gmx.com>
Date: Thu, 1 Oct 2026 07:19:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] qgroup: btrfs_remove_qgroup() can leave an in-memory
 qgroup, without on-disk items, every later rescan gets cancelled
To: c.f.a@posteo.de, linux-btrfs@vger.kernel.org
References: <14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9sNwY1h99hwpESYVuVeGtI3EKs+dQczn4WsmTwUzvywKI6huAm1
 /r/DMk5fUVy4oML25OPgfYZm51/vioMfB1+waZ6fbxRKi63/D31c6Ee9TxpfP16++tbjEhF
 RIkV/jiL9W06B5LJbeycpRWXbkrzlKo71BlOjbisLYtAoOaNK/fOLqgSisGDEplNfQHiZDq
 e6wip094RGv/YGBv+HA0A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:52O9T6Eq5h4=;vOxSWYiHjXXi05vm2FuRZjEkBSv
 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
 G2l2WW9w==



=E5=9C=A8 2026/9/30 18:52, c.f.a@posteo.de =E5=86=99=E9=81=93:
> Hi,
>=20
[...]
>=20
> Analysis
> --------
> btrfs_remove_qgroup() (qgroup.c:1806) does, in this order:
>=20
>  =C2=A0 1839=C2=A0 del_qgroup_item()=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0- deletes the INFO and LIMIT items
>  =C2=A0 1843=C2=A0 loop over qgroup->groups:
>  =C2=A0 1846=C2=A0 =C2=A0 __del_qgroup_relation()
>  =C2=A0 1848=C2=A0 =C2=A0 if (ret) goto out;
>  =C2=A0 1889=C2=A0 del_qgroup_rb()=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0- only reached on success
>  =C2=A0 1897=C2=A0 btrfs_sysfs_del_one_qgroup()
>=20
> __del_qgroup_relation() (qgroup.c:1628) returns the result of
> quick_update_accounting() (qgroup.c:1674) when the relation was found.
> quick_update_accounting() (qgroup.c:1540) starts with ret =3D 1 and only
> clears it when the member's excl =3D=3D rfer (1549); otherwise it sets
> BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT and returns 1. So 1 means "needs a
> rescan", not failure, but btrfs_remove_qgroup() treats it as an error an=
d
> bails out after the items have already been deleted. The transaction is
> not aborted (btrfs_ioctl_qgroup_create() just ends it, ioctl.c:3737ff), =
so
> the item deletion is committed while the struct btrfs_qgroup stays in th=
e
> rbtree and in sysfs. Its relation to the parent is already gone from the
> rbtree (del_relation_rb() at 1673), which is why a later destroy succeed=
s
> in removing it but reports -ENOENT from __del_qgroup_relation().

Thanks for the report, I'll fix it soon by not treating >0 as an error.

And also changes those older direct INCONSISTENT bit setting to the=20
newer helpers.

Thanks,
Qu

>=20
> The same happens if __del_qgroup_relation() returns -ENOENT because
> neither relation item exists and the relation was not found.
>=20
> Once the stale qgroup gets dirtied (a rescan zeroes and dirties all
> qgroups in qgroup_rescan_zero_tracking(), qgroup.c:4028),
> btrfs_run_qgroups() fails in update_qgroup_info_item() and
> update_qgroup_limit_item() with -ENOENT (qgroup.c:3144-3151) and calls
> qgroup_mark_inconsistent(), which sets
> BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN (qgroup.c:391-393), so
> rescan_should_stop() (qgroup.c:3839) stops the rescan worker. Because th=
e
> qgroups are already inconsistent at that point, qgroup_mark_inconsistent=
()
> does not print its reason, which makes this hard to diagnose: the only
> visible message is "qgroup scan paused".
>=20
> How it gets triggered
> ---------------------
> Any removal of a level-0 qgroup that is a member of a higher-level qgrou=
p
> while the member's rfer !=3D excl. One path that needs no user action:
> btrfs_drop_snapshot() calls btrfs_qgroup_cleanup_dropped_subvolume()
> (extent-tree.c:6498), which commits and then calls btrfs_remove_qgroup()=
.
> If the qgroups are inconsistent at that time, the dropped subvolume's
> numbers are stale and non-zero, quick_update_accounting() returns 1, and
> the caller only warns on ret < 0, so the stale qgroup appears silently.
>=20
> With snapper this is easy to hit: creating a snapshot into a group
> qgroup marks the qgroups inconsistent as soon as the group shares any
> extent with a subvolume outside it ("qgroup inherit needs a rescan"), an=
d
> snapper's cleanup then deletes old snapshots before a rescan has run. On
> my machine the first occurrence was exactly that sequence (snapshot at
> 14:00 marked the qgroups inconsistent, snapper-cleanup at 14:35 deleted
> snapshots, every rescan afterwards was cancelled).
>=20
> Rescans are being cancelled the same way again since this morning, after
> snapper-cleanup deleted four snapshots at 06:59 (followed by its usual
> 'btrfs qgroup clear-stale'). As far as I can tell the qgroups were
> consistent at that time, so this would be a different trigger. I have
> not traced this occurrence yet; sysfs shows three level-0 qgroups with
> rfer =3D excl =3D 0 as candidates.
>=20
> Reproducer
> ----------
> The script below (loop device, needs root) follows the snapper pattern:
> create a snapshot with '-i 1/100' from a subvolume outside 1/100, which
> goes through qgroup_mark_inconsistent() ("qgroup inherit needs a rescan"=
)
> and thereby stops accounting, then delete that snapshot, wait for the
> drop and run a rescan.
>=20
> Note that making the qgroups inconsistent via 'qgroup assign --no-rescan=
'
> instead does not reproduce it: quick_update_accounting() only sets
> BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT, accounting continues, the dropped
> snapshot's numbers reach zero and the removal succeeds.
>=20
> Output on 7.2.7 (trimmed):
>=20
>  =C2=A0 =3D=3D setup: subvolume a, snapshot s created into parent qgroup=
 1/100
>  =C2=A0 snapshot s =3D 0/257, inconsistent =3D 1
>  =C2=A0 BTRFS warning (device loop2): qgroup marked inconsistent, qgroup=
=20
> inherit needs a rescan
>  =C2=A0 Qgroupid=C2=A0 =C2=A0 Referenced=C2=A0 =C2=A0 Exclusive Parent=
=C2=A0 =C2=A0Child=C2=A0 =C2=A0Path
>  =C2=A0 0/256=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A064.02MiB=C2=A0 =C2=A0 =C2=
=A016.00KiB -=C2=A0 =C2=A0 =C2=A0 =C2=A0 -=C2=A0 =C2=A0 =C2=A0 =C2=A0a
>  =C2=A0 0/257=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A064.02MiB=C2=A0 =C2=A0 =C2=
=A016.00KiB 1/100=C2=A0 =C2=A0 -=C2=A0 =C2=A0 =C2=A0 =C2=A0s
>  =C2=A0 1/100=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00B=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00B -=C2=A0 =C2=A0 =C2=A0 =C2=A0 0/257=C2=A0 =C2=A0<0 =
member qgroups>
>=20
>  =C2=A0 =3D=3D delete s and wait until it is dropped
>  =C2=A0 Subvolume id 257 is gone (1/1)
>  =C2=A0 0/257 in sysfs (in memory):=C2=A0 yes
>  =C2=A0 0/257 in quota tree (on disk): no
>=20
>  =C2=A0 =3D=3D destroy 0/257 by hand, rescan again
>  =C2=A0 ERROR: unable to destroy quota group: No such file or directory
>  =C2=A0 0/257 in sysfs: no
>=20
> So after the drop, 0/257 is half-removed exactly as on my real
> filesystem. On this tiny filesystem the rescan itself still finishes
> (presumably because it is done within a single commit); on the real one=
=20
> (~700 GiB,
> ~80 subvolumes) it is cancelled at the first transaction commit every
> time, as described above.
>=20
> Possible fixes
> --------------
> - In btrfs_remove_qgroup(), do not treat a positive return of
>  =C2=A0 __del_qgroup_relation() as an error (the qgroups are already fla=
gged
>  =C2=A0 inconsistent), and tolerate -ENOENT for a relation that no longe=
r
>  =C2=A0 exists; or
> - remove the relations before deleting the INFO/LIMIT items, so that a
>  =C2=A0 failure leaves the qgroup intact instead of half-deleted.
>=20
> Workaround
> ----------
> Destroy the qgroup by hand ('btrfs qgroup destroy 0/<id>', ignoring
> ENOENT) or remount; the stale qgroups can be found by comparing
> /sys/fs/btrfs/<uuid>/qgroups/0_* with 'btrfs subvolume list -a'.
>=20
> Thanks,
> Carl Ahring
>=20
>=20
>=20
> ---8<--- btrfs-qgroup-repro.sh ---8<---
> #!/usr/bin/env bash
> # Reproducer for a half-removed qgroup: deleting a snapshot whose level-=
0
> # qgroup is a member of a parent qgroup while qgroup accounting is off
> # (inconsistent after a snapshot inherit that needs a rescan).
> # Works on a throwaway loop device, touches nothing else. Needs root.
> set -eu
>=20
> img=3D$(mktemp /tmp/qg-repro.XXXXXX.img)
> mnt=3D$(mktemp -d /tmp/qg-repro.XXXXXX)
> truncate -s 2G "$img"
> dev=3D$(losetup -f --show "$img")
> cleanup() { umount "$mnt" 2>/dev/null || true; losetup -d "$dev"; rm -f=
=20
> "$img"; rmdir "$mnt"; }
> trap cleanup EXIT
>=20
> mkfs.btrfs -q -f "$dev"
> mount "$dev" "$mnt"
> uuid=3D$(findmnt -no UUID "$mnt")
> q=3D/sys/fs/btrfs/$uuid/qgroups
> step() { printf '\n=3D=3D %s\n' "$1"; }
>=20
> step "setup: subvolume a, snapshot s created into parent qgroup 1/100"
> btrfs quota enable "$mnt"
> btrfs subvolume create "$mnt/a" >/dev/null
> dd if=3D/dev/urandom of=3D"$mnt/a/f" bs=3D1M count=3D64 status=3Dnone
> sync
> btrfs quota rescan -w "$mnt" >/dev/null
> btrfs qgroup create 1/100 "$mnt"
> # What snapper does with QGROUP=3D1/100. a is not in 1/100, so the kerne=
l
> # cannot inherit quickly and calls qgroup_mark_inconsistent() ("qgroup
> # inherit needs a rescan"), which also sets NO_ACCOUNTING: from now on t=
he
> # numbers of s stay frozen at rfer =3D 64 MiB, excl =3D 16 KiB.
> btrfs subvolume snapshot -i 1/100 "$mnt/a" "$mnt/s" >/dev/null
> sync
> sid=3D$(btrfs inspect-internal rootid "$mnt/s")
> echo "snapshot s =3D 0/$sid, inconsistent =3D $(cat "$q/inconsistent")"
> dmesg | grep -i 'btrfs' | tail -1
> btrfs qgroup show -pc "$mnt"
>=20
> step "delete s and wait until it is dropped"
> btrfs subvolume delete "$mnt/s" >/dev/null
> btrfs subvolume sync "$mnt"
> sleep 2=C2=A0 =C2=A0# btrfs_qgroup_cleanup_dropped_subvolume() runs righ=
t after=20
> the drop
> sync
> echo "0/$sid in sysfs (in memory):=C2=A0 $([ -e "$q/0_$sid" ] && echo ye=
s ||=20
> echo no)"
> echo "0/$sid in quota tree (on disk): $(btrfs qgroup show "$mnt" 2>/dev/=
=20
> null | awk '{print $1}' | grep -qx "0/$sid" && echo yes || echo no)"
>=20
> step "rescan"
> start=3D$(date +%s)
> btrfs quota rescan -w "$mnt" || true
> echo "returned after $(( $(date +%s) - start ))s, inconsistent =3D $(cat=
=20
> "$q/inconsistent")"
> dmesg | grep -i 'btrfs' | tail -4
>=20
> step "destroy 0/$sid by hand, rescan again"
> btrfs qgroup destroy "0/$sid" "$mnt" || true
> echo "0/$sid in sysfs: $([ -e "$q/0_$sid" ] && echo yes || echo no)"
> btrfs quota rescan -w "$mnt" || true
> echo "inconsistent =3D $(cat "$q/inconsistent")"
> dmesg | grep -i 'btrfs' | tail -2

