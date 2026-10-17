Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F87D280331
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792250222; cv=pass; b=mfRx+3U8yt4vEU6bQhunx5ARewXdHuqzNGJedpHlqZgeQBbpcOLVgDWHB9gUc0jmsPt1CeIDwUk5nIlgXnrZNA2HvdYRuf7wmQZ2XKsOxqiTBJcwriDPX4wQiktXLz3+ZI1b5sIn8+kAWJcC/TDU7jSue2N0tzu3YNDAhvteYGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792250222; c=relaxed/simple;
	bh=01THM3+R6BxI/jk+9mZIWhWydv1M6f8O0tzPvUs0x4w=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VsUTepSKrQFI/BwEaSGanblGHlcPLx3zzF+CJNZyipoWbjTzxTQF+TzWW1uptsB7Ag4e2mBBPwmw4Yva81mH7EhzRRUaTp1BwThpFaVSpWSMVKbJ7klvHIUWdexvLzN6AJz9kR+eP1MfI6lsdE5XWwzpjBxExKfec1wH7f0i4+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sX6Wa2iB; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sX6Wa2iB"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67992884b02so457470d50.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 08:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792250217; cv=none;
        d=google.com; s=arc-20260327;
        b=au8Z7rrRlsXj4pZ6rbouPMTEYUFdLvw2r9cROuVnhnDhzk0xm8zYmbi6d2OX/l/tlw
         lVnns36ErPeAMVaW0frzvFfeTDI7hIFsPFvujPX7iCsQA5infUUiucumZtc6Unab+HR5
         4dFYsigvUZSSDAdl000n6to8p9/zfMyyAHjomkyfB7DhewOxaDPTZ9xdZ1L8cG8QPe0q
         egk6PsUfSxqHVx4zflBDiR+jZuBCZkktzYebg36picNWUozbn3F89BLhT4nwz1uurBKA
         ubIsk1GhVac7iD5UbnvpmV4sFc8ae//7uN7Vtp9v+dO4RhTh4O4xJb8//d02UYxnjQlm
         mAsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=g8GqO/wyWKJ8wEPWKHfwNhqNYNcZyWJoiS5jnxgQoGM=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=nfQZdjfw+9lxbqgkSK6qiSD6Z3OOP75pvSPYVkt6gfI3CoRwK9in3dY3zpxoQDyv5n
         45/+ae43ygY2rLuH2S1JiH5sWJRtm04Gdc1Fy7/T52Bxco2X2IoH77tDEyM4Ri5WzFuu
         cgTQdMuvhXagWx5ADg6cZqyHDLSaGpc128bOZg1aqm/YSg6Pv676ZMwffSORB9vo5+6M
         M+hdteAgOIrdOZFwGezrYqyoQ5Ou+3ShdpEYo1JUcYLYkTNa1llv1BxlbI0VcHRDvi1z
         pngC0HjNxRe9qWFhMNgyQKBxhnNHo9RywBAAKdCOvV+pz/TY0lxVEh9u4kWUhoCHDYZp
         cQRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792250217; x=1792855017; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g8GqO/wyWKJ8wEPWKHfwNhqNYNcZyWJoiS5jnxgQoGM=;
        b=sX6Wa2iBZ1FxyRZJoRw3PZYibLixzoCQR3RUqojYRWk4luqnfCQO2EszjzfzOBecbD
         NuTrolbT6z4fihoWG5g6EhqTnjOr4L0eKATkeN6i/P+hHcPuaVDdKZwa1L1+XMhbU3NX
         bdGiWIJsa84RudsYCfYWc6or7jnXdxORHz+thfojnw6XTkvKeDOGZfw9bN6UPZ3en4TF
         6+qwez+AyTny8s+Evgf/AGXbJZSP9bRB7mlrBS8DaWq5Y8LTDFV2RLj7JzKJtmeI/UDF
         Hit+9eVmF+2O+HSOZ3gsXFGvVcdH9Wvf3bRClAATdJ3KKbnzOloh9rG5M+p7MwWxOM2b
         w7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792250217; x=1792855017;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g8GqO/wyWKJ8wEPWKHfwNhqNYNcZyWJoiS5jnxgQoGM=;
        b=i6CUZbUounU1NOFKGEaeSJnKHs2ObeBf7PwUP4kzbFVCSRUI+BzrfJ7uC5kl7+9mjt
         APht1y6j1SYOosVOwHEj1ViOPZa3YdGrsXlw7pYtvXv1g/JbNj5Y7Hkg+Fgk4ST0QGY1
         XiBZf3d6Q5hdPN2CbVOlVfLlk8gYN7ZbeH/yopVscYEfsjKrfd/BX+qe3jp8Tl0ank0S
         P8UoTiCYNi15A8kBItg01JEHFWBXJOnx7sbVzo0rKLr3UO3QcPO/wy0eIlYJN3vO8pH+
         9PJsI2SWJhfP6IxSJd7K5dW2stOw01ZuEVgXMa/fZlpUmjqJk4fuZbO6NK7xr8/Mep6N
         1ZIQ==
X-Gm-Message-State: AFq9FYJPBsh7JW/0ZA3odHdEUXMvAfPOM3mxmttwup7+dWzDBMnhCyHM
	7E+BZHeLulzbXzGcut3gHX4CH4YuLDRN01MkcSU+lY/63qcjjj5JepFJQB+vQqRlOUKrJKRSQdY
	oGqx7nWFAIMqAAlrG9dVwSsNLgFfazlV5bQ==
X-Gm-Gg: AYBFou3EaEClKwFK3aBRURYCIeObGx9lnNz9sjzjoK9+zLlaL87ii2rsq5DZ/IGM8WI
	mZgEBYf2eWyBGyqrVhz6Uu5iQEQjUjMB+5mtBKCXNCiwHJOrJy4RdLHq94pWXbkMwr8a4I8OCFD
	7wgBUxCot1mN24YLy+KD09Z/r4eK5f75pjf/3Cg9iDWhNPJzbVx/yxhbHOyTm2ABCwDlTkhv/ed
	wmhp2k0QZJuHjAPu6DvRhXRl0k9i4WqxdtBm7IQqmTyuf/angHTCKV7zTmPw0gA2xnR1CXH//N3
	DM+xAbQSoqn7Hn56KInfFY+LzFz1I14DF1vAZywVw/om+q/Amz3J
X-Received: by 2002:a05:690c:7441:b0:89a:63bc:8e0 with SMTP id
 00721157ae682-8b0f220eda4mr10352997b3.106.1792250217043; Sat, 17 Oct 2026
 08:16:57 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:16:55 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:16:55 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 11:16:55 -0400
X-Gm-Features: AclHuK_c9rJU_akzrvav0mnmFh5ccaCF2gNcnLUAmeBAHI9k6MQYw4bjn2opKmQ
Message-ID: <CAFBxzAD2iyjUfvPTvjZEL+t-dQJ8m0-JvrAc4YujQinuYzDrQw@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Correction and final real-hour differential results.

I found that an earlier QEMU helper ignored its hour argument, so
those runs did not establish successive-hour behavior as I had stated.
I corrected the helper to set guest time to 01:00 before tracker setup
and then 02:00, 03:00, and 04:00 for the next three snapshot rounds,
and reran the comparison.

The corrected test passed with both the host-version Snapper 0.10.6
backport and upstream-based Snapper 0.13.2. With the stock Debian
7.1.13 Btrfs module, after settling initial tracker setup, each of the
02:00, 03:00, and 04:00 root/home rounds emitted two "qgroup marked
inconsistent, qgroup inherit needs a rescan" warnings and completed
two scans (six snapshot-triggered scans total). With the candidate
module, the same real-hour rounds started no further scans and emitted
no such warnings. Used-space listing, 1 MiB SPACE_LIMIT timeline
cleanup, and an explicit post-cleanup full-rescan counter comparison
passed with both modules and both Snapper versions.

This strengthens the case for the candidate as a rescan-avoidance
optimization for the exact qgroup hierarchy, while retaining the
earlier conclusion: stock accounting matches the full-rescan results,
so this is not a demonstrated counter-corruption bug. The kernel patch
remains RFC pending an upstream-version build and review.

On Sat, 17 Oct 2026 10:44:15 -0400, R E Broadley <rebroad@gmail.com> wrote:
> Hello,
>
> I could not find an upstream report for this specific qgroup hierarchy. T=
here is a related quick-inherit optimization for snapshots assigned to the =
same exclusive parent (linux-btrfs, 2024), and mainline now has fixes for f=
ull-vs-simple quota handling and updating ancestor qgroups. This report con=
cerns a different layout.
>
> With full qgroups, Snapper's snapshot-only quota group does not contain t=
he live source subvolume. The source and the new snapshot-only qgroup inste=
ad share a level-2 tracking parent. The tracker has exactly those two child=
ren, and the snapshot-only qgroup has exactly that one parent. On Debian's =
7.1.13+deb13-amd64 Btrfs module, snapshot inheritance for this layout takes=
 the conservative "qgroup inherit needs a rescan" path. The rescan complete=
s and accounting matches a subsequent full rescan; I have not found evidenc=
e of incorrect accounting in the stock kernel.
>
> A candidate quick-inherit extension is included below for discussion. It =
is limited to full qgroups and the exact two-child topology above. It deriv=
es the snapshot qgroup's referenced counters from the tracker, preserves it=
s snapshot-only exclusive counters except for the new root node, and uses t=
he existing iterator to update the tracker and its ancestors. All other lay=
outs retain the rescan fallback.
>
> Evidence so far:
> - A QEMU control using the same Debian kernel image, Snapper 0.10.6 and t=
he stock Btrfs module logged "qgroup inherit needs a rescan" and performed =
one recovery scan.
> - With the candidate Btrfs module and the same source-only tracker workfl=
ow, tracker repair plus snapshot creation did not start a scan or mark qgro=
ups inconsistent.
> - Repeated two-config snapshots and timeline cleanup passed with compress=
ed data and externally shared snapshots on the candidate kernel; a later ex=
plicit full-rescan comparison left counters unchanged.
> - The QEMU behavior tests were run on 7.1.13. I verified that the attache=
d diff applies cleanly to current upstream v7.3-rc7, but have not built or =
run the tests on that version. Quota-limit enforcement coverage is also sti=
ll outstanding.
>
> The stock kernel's fallback appears conservative and correct. The propose=
d change is an optimization to avoid repeated rescans while preserving the =
snapshot-only quota scope, not a fix for demonstrated counter corruption. P=
lease review whether the tracker conditions and counter derivation are suff=
icient, and whether this belongs as a kernel quick-inherit optimization. I =
will send a formal patch revision after review and the remaining quota-limi=
t coverage.
>
> This is an RFC discussion; the diff has no Signed-off-by line.
>
> ---
> Candidate diff against upstream/master:
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index f68b696b4bf7..300607c10a6a 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3263,9 +3263,10 @@ static int qgroup_auto_inherit(struct btrfs_fs_inf=
o *fs_info,
>  }
>
>  /*
> - * Check if we can skip rescan when inheriting qgroups.  If @src has a s=
ingle
> - * @parent, and that @parent is owning all its bytes exclusively, we can=
 skip
> - * the full rescan, by just adding nodesize to the @parent's excl/rfer.
> + * Check if we can skip rescan when inheriting qgroups.  This is possibl=
e when
> + * the source already belongs to the target parent, or when a tracking p=
arent
> + * contains only the source and target parent and lets us derive the tar=
get's
> + * counters exactly.
>   *
>   * Return <0 for fatal errors (like srcid/parentid has no qgroup).
>   * Return 0 if a quick inherit is done.
> @@ -3276,11 +3277,17 @@ static int qgroup_snapshot_quick_inherit(struct b=
trfs_fs_info *fs_info,
>  {
>  	struct btrfs_qgroup *src;
>  	struct btrfs_qgroup *parent;
> +	struct btrfs_qgroup *tracker;
>  	struct btrfs_qgroup *qgroup;
>  	struct btrfs_qgroup_list *list;
>  	LIST_HEAD(qgroup_list);
>  	const u32 nodesize =3D fs_info->nodesize;
> +	u64 new_excl;
> +	u64 new_excl_cmpr;
>  	int nr_parents =3D 0;
> +	int nr_members =3D 0;
> +	bool tracker_has_src =3D false;
> +	bool tracker_has_parent =3D false;
>
>  	if (btrfs_qgroup_mode(fs_info) !=3D BTRFS_QGROUP_MODE_FULL)
>  		return 0;
> @@ -3299,27 +3306,67 @@ static int qgroup_snapshot_quick_inherit(struct b=
trfs_fs_info *fs_info,
>  	if (list_empty(&src->groups))
>  		return 1;
>
> -	list_for_each_entry(list, &src->groups, next_group) {
> -		/* The parent is not the same, quick update is not possible. */
> -		if (list->group->qgroupid !=3D parentid)
> -			return 1;
> +	list_for_each_entry(list, &src->groups, next_group)
>  		nr_parents++;
> +	if (nr_parents !=3D 1)
> +		return 1;
> +	tracker =3D list_first_entry(&src->groups, struct btrfs_qgroup_list,
> +				   next_group)->group;
> +
> +	if (tracker =3D=3D parent) {
>  		/*
> -		 * More than one parent qgroup, we can't be sure about accounting
> -		 * consistency.
> +		 * The parent already contains the source.  The snapshot only adds
> +		 * its new root node to the parent, even when some source extents
> +		 * are also referenced outside the parent.
>  		 */
> -		if (nr_parents > 1)
> +		qgroup_iterator_add(&qgroup_list, parent);
> +	} else {
> +		/*
> +		 * A tracking qgroup can account for a snapshot-only parent when it
> +		 * contains exactly that parent and the source.  Before the snapshot,
> +		 * the union of those groups is the same set of extents as the
> +		 * snapshot parent will contain afterwards, except that the source
> +		 * root is replaced by the new snapshot root.  The source's exclusive
> +		 * extents are the part of the tracker that must not be charged to
> +		 * the snapshot-only parent.
> +		 */
> +		if (!list_is_singular(&parent->groups) ||
> +		    list_first_entry(&parent->groups, struct btrfs_qgroup_list,
> +				     next_group)->group !=3D tracker)
>  			return 1;
> -	}
>
> -	/*
> -	 * The parent is not exclusively owning all its bytes.  We're not sure
> -	 * if the source has any bytes not fully owned by the parent.
> -	 */
> -	if (parent->excl !=3D parent->rfer)
> -		return 1;
> +		list_for_each_entry(list, &tracker->members, next_member) {
> +			nr_members++;
> +			if (list->member =3D=3D src)
> +				tracker_has_src =3D true;
> +			else if (list->member =3D=3D parent)
> +				tracker_has_parent =3D true;
> +			else
> +				return 1;
> +		}
> +		if (nr_members !=3D 2 || !tracker_has_src || !tracker_has_parent ||
> +		    tracker->rfer > U64_MAX - nodesize ||
> +		    tracker->rfer_cmpr > U64_MAX - nodesize ||
> +		    parent->excl > U64_MAX - nodesize ||
> +		    parent->excl_cmpr > U64_MAX - nodesize)
> +			return 1;
> +
> +		/*
> +		 * The source remains outside the snapshot-only parent after the
> +		 * snapshot is created.  Its data is therefore not exclusive to the
> +		 * snapshot parent, including extents already shared with snapshots.
> +		 * Keep the existing exclusive count and add only the new root node.
> +		 */
> +		new_excl =3D parent->excl + nodesize;
> +		new_excl_cmpr =3D parent->excl_cmpr + nodesize;
> +		parent->rfer =3D tracker->rfer;
> +		parent->rfer_cmpr =3D tracker->rfer_cmpr;
> +		parent->excl =3D new_excl;
> +		parent->excl_cmpr =3D new_excl_cmpr;
> +		qgroup_dirty(fs_info, parent);
> +		qgroup_iterator_add(&qgroup_list, tracker);
> +	}
>
> -	qgroup_iterator_add(&qgroup_list, parent);
>  	list_for_each_entry(qgroup, &qgroup_list, iterator) {
>  		qgroup->rfer +=3D nodesize;
>  		qgroup->rfer_cmpr +=3D nodesize;
