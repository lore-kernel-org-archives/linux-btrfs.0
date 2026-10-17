Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7693515E3
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792249910; cv=pass; b=NmD+2swjOmdH7JersKx+gpT/FggphGu6jOpxF8SQ9SMExgfe2KQ94DCX9P4WSv3xWjDuq+zBVYfBBsky0JblZrrwYMEVeuh4MME/0jW/JIq9fSbcKNLpt0pTNavuvF9DNPWNvVl9zNqQigjuvbX2MYJ+WEkbpUp8S0hqywTJ9Ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792249910; c=relaxed/simple;
	bh=kUgaJfcHUaw2Mf3AOiCBqxnuSIsGPJ6SCkYqaF4W5+g=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAsU9XqPSmZ4RALBIHmshow6jlF8hk0uVevF5r0MPtbwjWw3ln5cU5ZzyQBiu4oqaKD21RKUJIZEjVjgYNz+oEB3Ykdl2hX/JdlFMxjyhCS+tR+CXRTunvn36cV1PJ5uuyA5mfyHpSJBSoDI6lahHlaEq0uyIwRWgDkMv/27xHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qsfQfOX1; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qsfQfOX1"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8ab37e44643so5218887b3.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 08:11:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792249906; cv=none;
        d=google.com; s=arc-20260327;
        b=KHVcJHXN77dkLzKxo7FLwryhOF6dE4tsaJEtdE5fmdN/ARzW0hPSyymG5caHNEmQ9v
         YyTm6fJ9KKxIWIiU55XN8zhObTSe9ouBARY2eCRa6mfpP+lb4Jo52CGFaH75+DynFulI
         FkRHvIc8t2qdIODq+eysOQMmVehkLiAL17yNKHb38j/hHRD6AFsO2Ibix1f1t6DQFjmI
         Ms19bRRmWD2jFGF+6EJozdQukxw9q069i1XrYFF6LVdxkWYH5jledX8OqbOtapI5eKBW
         9j7cI7ZW6SIQBAnDu+AJs0gyRD9mRuaEgvM2x4F5cUUf7+4lmanI4Q+fwHMkJ5/NKy9A
         +2Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=HWjAnv7MWZyeb3beN0apStuHjz7AMGisi1kBhY8x2ck=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=cymmtpfF5kw861ZNr8PRRJJDVgAhsiCQvhTpZf8uneiYMwFh5PVuNpj7GOI42cRh9e
         xTSCV48s0H432zGnLSy0sNTu3BLdwV8je7C5LiGB9nBBcj26aa83acmmUu9ctBx1raHi
         uF5cn1vWj75hYaPIxR8EyWojQVD3T4V6OBz1R7AgBoonY5VOGo8whleem8hk1C+DtiiA
         ootCf7fp/E8m7BIiXIUn+5X4eyNByixMIY1xoySfw8WmdbbfwlDyO8h52nKuPHGoGSh7
         n7K+Bkscqg6BqxUKx2kJ8zfRH032++InGEyl24UadDsYNEV3FQhL4jCKBXp1raKhAoOj
         +eBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792249906; x=1792854706; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HWjAnv7MWZyeb3beN0apStuHjz7AMGisi1kBhY8x2ck=;
        b=qsfQfOX1cczkIvDoJJabPXqJyPSQDeZaIrfiJUl2gdlFYi33QsfRrCinXFHsG6HU5Q
         14QrMVu0UGz0JSDdsXGoyj/GAS9Bv89MOzVnbKDN/EiI7aStdtJ294dX4QqDaMZslJzc
         747iIzpxJBnDe2PvvGtFt7ULNy06ddbU8SI/PnHWy9SbVh9Z1RUIofKcWwGkdJFdF3Tz
         acoKBrX8Y4gQI1gK5B+31q0Bt9hJ8jxlJFPkXNnjMzN8SME6T3Vg7xWbuJn8/UTi2J6E
         xmbDSu8gP0FD4swtK6peR9QccFP7ZgjivLLPzJstZamcm6NC5dkHADUoEZjB5tGYD+PG
         b/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792249906; x=1792854706;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HWjAnv7MWZyeb3beN0apStuHjz7AMGisi1kBhY8x2ck=;
        b=uZ6tUXSvflQChX7LCjf9feW4RXtC8NOu/1+E9UnLbhJOmI4Rn7c2CYPvHXKhZd3ghS
         rcUpc/XUEqxk2TsPT8iD87ZFnGOGjp9mRJP8Kwc4VnshoOUhKePhdZZv6JMYmmZHoI5T
         Ng4il+3ZmK8vJJlBF1tCcns/va+03aZXMjupbLILr7Q+fyp5Oac9eY+NIxz70u53b/No
         QLmLnFWvl8UpXx6iw6Zn1hYmocREwsB9ls4+BiYLSiWRzcamERw05W1mmvY1CIeLqzue
         e1by9HKVoq6RBtSKojOr3l+QUbFr1TuGVt5CGh2hebKi/s0VTJWYdQiGleHCyslEjdhc
         fXKQ==
X-Gm-Message-State: AFq9FYKWvU8mQ7MhMmVaqcfxpU8XtYRAGNLyLpr9nbRRtuzItCDtIc40
	BqZBjUWO4L6YLanCH59mwe4o895sKDV0Q9eofx+qQmfEP+NI5LSYu67IyAE8owRibOhzIB25nep
	iLItOMw57JUzosBmJ0xagJDUVeWK9qHv+ng==
X-Gm-Gg: AYBFou1Gf0NlVtjwHPYe3Rc0BjyU032BdSRGWOsNWK1zJpivDn5QaZ9cnoDQrlOWKjM
	sBe9NnutlXxmgsNhX47ym3mhsuhzFEQgPXwAlJwaQL7OkEoP2ri9olU0eHsZtuTl/ZdJaADIm/g
	aSBcYOOof2mNsMIdPKuCdQk7u+vcrJbHTW8Mzp21eDIermdT6g/Z5lXpYxE7KswRC9VJRPcBoCz
	EA2ZIdw5V1BkJofXTQvwiZNqUKjKv9DLRgZjMxJrIH+wBR8Mle0yeVwayf/Px6P2SWx85qV3Knz
	e68fmPRdabn+Dkp0jhMiyYEb7c7zYFqg548pI2LzvJn1WkcNS37RbjQKzbPBYiQ=
X-Received: by 2002:a05:690c:a610:b0:8b0:a28d:6444 with SMTP id
 00721157ae682-8b0f21b0445mr7327857b3.20.1792249905969; Sat, 17 Oct 2026
 08:11:45 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:11:45 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:11:45 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 11:11:45 -0400
X-Gm-Features: AclHuK8ockfb8gGiXMh4tp0Wgx2AdQUI0x5ZIBQ6JDLn77DXGbAeSq82V63FrvI
Message-ID: <CAFBxzACv34VT2xckTSpJ=1=JjOP-kAtYbKa82S+n=SJ1bxZLYA@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Further differential QEMU results are now available, using the same
rebuilt upstream-based Snapper 0.13.2 (including the clean-query
changes) with either the Debian 7.1.13 stock Btrfs module or the
candidate module.

After settling the initial tracker setup to a clean qgroup status, the
stock-module run created three further hourly root/home snapshot
rounds. Each round produced two kernel warnings, "qgroup marked
inconsistent, qgroup inherit needs a rescan", and two completed qgroup
scans: one per snapshot. With the candidate module, the same
repeated-snapshot workload completed with no additional scan or
inconsistency after tracker setup. In both cases the subsequent
used-space query and SPACE_LIMIT timeline cleanup completed without
launching additional scans, and an explicit full rescan left the
counters unchanged. The candidate run reduced each config from four
snapshots to one and lowered its exclusive usage from 6,750,208 bytes
to 16,384 bytes.

This confirms the trigger: the stock kernel's conservative
quick-inherit fallback for this exact snapshot-only/tracker hierarchy,
not an independent rescan launched by the fixed Snapper quota-query
paths. The fallback is correct in that it requests a full rescan
rather than trusting an unproven incremental update. The candidate is
thus an optimization for this exact layout, not a fix for observed
accounting corruption. The existing full-qgroup and exact-topology
guards leave other layouts on the established fallback. The candidate
has been built and these differential tests run on the Debian 7.1.13
kernel; an upstream v7.3-rc7 build/test and broader review remain
open.

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
