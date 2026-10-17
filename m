Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1733A1E96
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251919; cv=pass; b=PjF2c2HVfqtqB+KrqZpcCp3E2Deh2XkkuKtC0gL+Ee47iHFTheYlvWWOKTomifsjEODssA+akGV6PuoKESXjyNLiA42nkSe33oZLsFl4i4gdQHWyujZGDcNg0VrY4mxAwsV+cFWFKXRRIyDVR0Xc1FOQs8uPX48mPRje3BHu35U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251919; c=relaxed/simple;
	bh=dBR5g1aJiss0O8hLkhL3MMTzkr9I+7Yc5VO4vmBdGV4=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BmzW/mLPl8xBq5nR0RXLY0qhUXTNAslRLTPrItbTtcrEu2ufkC1nGR6zYRKxAUTXCL/Whqmq723zFBjWye3EIpH2s5vacksudoCC9Ut/HMWriup5Gm3JUfVaoCGqphR9XGMvrkjscxq67ySiDoQWwwGS6Mw8Odb6C7E3FVcbqoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cgXe7Oih; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgXe7Oih"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8ae8607e8afso5422777b3.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 08:45:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792251914; cv=none;
        d=google.com; s=arc-20260327;
        b=MgbXBv3s1RHsVTlTTpR/kC/0ROEm9JSUwTo82wGKcprTAQFh6fIErrzKF5ByTa28eP
         o6+L84zCpt6ELaHCi6dQgIg2l4nKeYuTrO5d8Ue/VqvF8GDJPT0JTNhaMFTFTm8qf02Y
         SCs5S+MZvEVtDh6udhyrITcbxEv5kf3mGjJ0SXIQNv++9DnOYE3+JW3K8JzAJK2EJwrA
         h1JHjGk6raMuZT/5nFvhJdNm5yJcW96Gr0Hfd6XHQOO6LJwhL+3CFaR4TBp2TNWQpBTv
         NJmtJfjuE9i8qqyT8/ytJcBaM+0z4nsErlaZsw7mvIb4hhnQm3CbGNk9SGeypcbRr+WR
         216Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=gZqhmHPSdh03+fIPQAzc3R/J86lw3yIgtMWKR6WGa7M=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=qaeknhsmVeip7C6rWVkFl13t3f/Kh2i3Wb33/5rNwpLUOF5rCTvuU4X/mpXAFCbYLw
         EqEP6ciXzgBbLCN4oTrStVqbvjkkH7lUlwo+1p4FwJjccU1NsHAdyATCaiX0nUkm2tdW
         +b5YCUAR+ZBJiEDQx9e33UbD+ZzyPM4V5BaXmU3wRJVZNtJ1DJw+lRySBBI+JMMO/u6Q
         RKYSaARZEE8VkbeCak9owsrrIuKyrjncdIM7eVApQrh9W2dla7SDWYerA5EiRmg+weop
         nkc7lDy+UOxSyWGW5CfA5tYB/vHSVxVF0FHnoZLiLdEkESXFUfH1JuenFuPZ5cJcyy8K
         7EsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792251914; x=1792856714; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gZqhmHPSdh03+fIPQAzc3R/J86lw3yIgtMWKR6WGa7M=;
        b=cgXe7OihmUY1WP4UWeC9fZvm6ki5MQu/W/7Go1SUU1GM9LPepoYbxolCdU2EtQI8Xj
         fePBTz9RQxgycyQMjAIjz55CudF4Lso0rQB76KIl/WZ7YeAw9e5+KOwY++X0bw8YS4zA
         pI+Bhjf62XgX1Mzc03wC/CubKDuCHUre+1ua2kL227NY5zxYwlo4ifHXmPA+/CXKBF4g
         H3KNye/4Ls53GMPIibiZIiy8sfHcgiO5tmbczDt1DpdK1rEIGK0qvDZrIGPquWOiRpDT
         YpMtW7GsXgWHqZF1xj6bTn+REL0h4jjehqxwbSDLwO4qCzsmwwrry3uOdpBUShJPgbxP
         e8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792251914; x=1792856714;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gZqhmHPSdh03+fIPQAzc3R/J86lw3yIgtMWKR6WGa7M=;
        b=rz7arVcQfUqYuSFuqgKabRGOERcKpH7Z16biHR40y1Sp5T1OXejktUGw0R2YdnZbJb
         WOBslaVD39A8dkUwk4YvA8jE3eFlRZ8IFpJkPJAaMqIm5rcbALdKUcFBIrK2HPkBwAFJ
         YYgWipXmpdV3achYoXPcnmLuxFnVq0crxJ+mKo1pWcgfc80lJcmLwkGSQK9SuemZ+zjP
         Lm35TFaDW9ipGOEInHsugZfLzAS7v5edMzhF6h44GBsGavMnDOZPK6qofjtWS9WE2Ld+
         RUu8wh+R9nIkgy4Blp5IgzqZz/hrHYaLdTFQY+tG9o863eTrOpJJX4nkUqzXsH6RRIe1
         kqKw==
X-Gm-Message-State: AFq9FYJ5tjBu+eK3762Am/Z5bpwSfC6v/vYVZKBiyz7t++Dakpv662Vd
	ZU8h+uw9xYN3LGrs5YFCpGEEJ9PXarcZ/IlnWw59beR+OMrjHvJfApqeG7cu915iBNfKNMTmkfQ
	G/cBYr0pdprNyWHV5qIRtll1aMOYz9Gqc4Q==
X-Gm-Gg: AYBFou2E8+wi9VknK1OZD0QkRQjl/sRNZ0LJXRZn4KwerQT/TgHE+oOllwP0K95yqRp
	H35BAbEjplbM6JHQiajKk6UUS1pFgHGNHu1aIzT2r5I68qfSlmwXt3wtBa7HyeVDLHpjIuqJYN9
	DRinm/wawRQgOPgA7Mfg65YJOJfd0bQ1jyPnPenScWlEs9w1rImk2M/i95R7pRc/gRK1LpT7KKn
	n28ccu39Yl8p0qZEK5au6Yp51dQAb+iiQnaIQBcTncZojZEUKgqucPuMEqUCRNVXUHSwuYBsdz3
	g51zL8/zHtwFIOaOnnC+yUhNRGuvR9iOpVAxR8VhtKAhZVyxAwTOadivay/Q1X0=
X-Received: by 2002:a05:690c:6604:b0:8b0:d42c:54e9 with SMTP id
 00721157ae682-8b0f21aeb92mr10543137b3.34.1792251914050; Sat, 17 Oct 2026
 08:45:14 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:45:13 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:45:13 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 11:45:13 -0400
X-Gm-Features: AclHuK9SHS6kzwixD_MfDZCZ_o4GZS6M8mU2EGznjBuAeIAkbo5RxeVcp61zF9w
Message-ID: <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Scope correction to the RFC candidate before any formal patch submission.

The earlier candidate also relaxed the existing fast path for the
unrelated case where the source already has the target qgroup as its
parent. I have restored the previous guard there: if parent->excl !=3D
parent->rfer, that case still requests a rescan. The new optimization
is limited to the separate tracker case (source's sole parent is the
tracker; target qgroup's sole parent is that tracker; tracker has
exactly source and target as members). Other layouts retain their
prior fallback behavior.

I rebuilt the narrowed module for the currently used Debian
7.1.13+deb13-amd64 kernel and reran the corrected real-hour QEMU
workloads. Snapper 0.10.6 and 0.13.2 both pass 01:00-04:00 snapshot
rounds, quota-aware cleanup, and full-rescan counter comparison with
the narrowed candidate. I also tested the preserved same-parent
boundary using an outside snapshot that shares extents: qgroup 1/100
had referenced=3D8,404,992 and exclusive=3D16,384; creating an inherited
snapshot emitted "qgroup inherit needs a rescan", completed one scan,
and a subsequent full rescan left counters unchanged.

The exact narrowed source change is pushed at
https://github.com/rebroad/linux/commit/f06fc2e5cdc8. The patch
remains an optimization for avoiding repeated scans in the proven
tracker hierarchy; I still have no evidence that stock accounting is
incorrect. The upstream v7.3-rc7 build and maintainer review remain
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
