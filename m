Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE7835C1BC
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792249435; cv=pass; b=jh0zGH9baQFX/sV5rnZ0sIMB6RZSMQCneF8Qua51g1vamhG8acR/R4z/9vyIgorhuYGD09JbISvjQBwiQxCFHItkaXh+zgtQYIBUEoB5/Ifc5e5wDF7f4hRY3Ix2zDujGwUToQxagHy70wcpfSuNaSxzS1g6gzaFg8MsVRTfhXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792249435; c=relaxed/simple;
	bh=2TPiLMemd5nZWHJFOnZuI1Mv7QhHV+9TaWQXpNedp/4=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbaC45eBT/u3gbHaBH7su07jGxQ09vtW7dwNLXV5oIwGLAf7oN5XNZ/5Apdc5dYXtHVb8NOIO8LQJiNOVVxPU8oHz71ouoyZdRH4fs6JCjhmjqpwAezjfAg5T9oC6TGRjl4ftyOUKw4de6hq+4bTlz0fbv6NzfAWbFw/8XhVPCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HNVHR6dK; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HNVHR6dK"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8ad98c3fb15so6423617b3.2
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 08:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792249431; cv=none;
        d=google.com; s=arc-20260327;
        b=IXGSgM8v/zEwjOR0rrWcG/vzzCyJcQaxHQzLmOT+OBXRE1RkAxPkEYxe/YFBydlurt
         wfHxO3gkAviiYBNNVlRAQowpQABCQrfCWf/XoorltZI2zdv5wtlRui24cSo9a2Gnmier
         N2H/HuQNbfDCn/Pg6gWRzRT895g7nkRSlgbHg7S0lYU448x0dvyScVjZ/f1cs6FY4hbL
         Xp5cmEDCqGToUMhx82aw7J5O7OnshR0JWK+Sy1PqAm5EG3rBzVPR6EYo/ZHgKnxMMu+e
         s6DOF7xz9KCeMMQu4FmH7cHoKO4KYCQoL37tNfoxnyVUbaPIVUmtS2bPcZkEUlN+Zq9w
         dNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=nuMClOp+B5y4NzwOwEQnk3xTwgYgDROqbJuDnxXbdls=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=jvYSiZbWAFcVjGPB7ANxT66j8+jZpN0cvk9qMt4bRbchlG3zU4dFlJ98vdcSmUftzl
         1PX8NLNiBnsoEVHIR6jR0Z6P8tTLQ5HXdq+3fqZTuWUcOzgzh+YWz2y36MGvlmAEXWjI
         TsW7ZrvqW7JfCXkC1cyK1azeww7Jlx9dYdqiA/a7+iekJr07ITpep9wEXYUnI+TxDKA8
         ULYkvztv6EAuc57FSab2fgu6nW9aagGd132hZg7hRebVg/+6klXchKK6yVEstzrnvVLD
         2y62SM9SwqHTxKP91bk7JooTH825j7Wawpg21Nh0t4r5EWJDg4n0fHIEAcSZhII2A4GS
         2vHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792249431; x=1792854231; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nuMClOp+B5y4NzwOwEQnk3xTwgYgDROqbJuDnxXbdls=;
        b=HNVHR6dKuMgsNVmzcXZz3vcya908zrQdmHi1f5whSGrcJyzCctOD0peESwLN5OL7yM
         nW6uJy9kvCjXY4HICjS+zWIXFL5S7dS7GnzU3DK0IDKK8RTkBYimVOf7DW0mV2QOmGdU
         onkDCIElLPJ94Zj2OsGZNk5D/tjORlkqJHnCtudgIGK7VmiGLSUWQMjjkvCZ0UAk2MMN
         aPT8JWDTW2/yPCflh6DOZkrTElHy28coRQ03npNWFJ9JboRhnuUwcdJ7yC2tdvZH7E5W
         IqKbP7XwovqKCKKH2Y66mVzKVkyyW1qap/PE2copKEo4gg/Bayw2q7rRRe3z6XhyG2tY
         fPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792249431; x=1792854231;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nuMClOp+B5y4NzwOwEQnk3xTwgYgDROqbJuDnxXbdls=;
        b=L66jVnEjvr4mv90OoZtDh+QY/wlA6BWRT0xSae2KyPK5MGy3sSmkf0E6SnzJ8q+mqp
         ofBKwPl58GuKRHKRso7D87inKJDUGgOFfsz//bw81+XGaBpUOqPZp9LwLcGtQXqqfmC+
         jOpuLoCDhSBIHJ1qBCzzAyWDKx2WkhZSlMRqDZSBYoR7HiaulZbDO9IV+KYhTYgBgMyN
         T16qyPowkk+O2QHqJW/RWtYxY2A1JKwh/d/0dho97pGPKSCMjod1rONQCubqcV8E3rqN
         iXxATP9FhxoS91QUJyckqOU5d6GsSd3FB0i4jrj2HPb2V/6d2C7a6hasJV9uo+E4Wbrr
         I+iQ==
X-Gm-Message-State: AFq9FYJpAeHOhFCTpM1aw2/dSVRAHKrUdjSdu47VqfH+29/OY6n2SoO2
	TBc33eKMfZmc2nPjKkit5lE2PMvOzgTI/gip2+tXpECNRIzyFgAut+I/FEtUtacRnjowu4DsqCY
	8Mxj5sCLndFgTbmu9Ji2ATp5+d8SfjOfrAQ==
X-Gm-Gg: AYBFou0UL8LrXkzfrFz8aY1HfnxX9w4ajzDq33+wXbZII2hWUXjaMJiyh/oZrWoe0EQ
	flkL2qSY5N8NG9Z6wSDJyCHOrTJcw+z3ZvVLajHleMfRiYwRpe/YBC4s6PkirIelfFNePSeS4vR
	R3MzkMFQrvZFUlMEj3gQjCb6KgeokM4WmSeIkZO8gmGx9JpWdPpNcWuL+EF0F6FnOk9Rs8jddNG
	RFY0zHxXB4OXcbAlLxTa5lFz0/DCiSEUdzstrAAi6ntJD3LEc3fQeYf8PPOcVnTVHhPkgFLn4SR
	rmeiShhRoVaymwhhHSmDP7QqMzMw+ZW4XZVzP8J3FZqygMapARehDRUW9ZorNPf5
X-Received: by 2002:a05:690c:113:b0:8ac:6e11:3dee with SMTP id
 00721157ae682-8b0f2141a9dmr13174027b3.10.1792249431172; Sat, 17 Oct 2026
 08:03:51 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:03:47 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 11:03:47 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 11:03:47 -0400
X-Gm-Features: AclHuK9kzztvmuSfe-xeTT07uDz-Pjfx_MiuVYIQD8aQ00Nmt5rPa3zL4l7snHY
Message-ID: <CAFBxzADp_V7kAr44Rnjs3B5NopX4ouPS=LcoXFOjkg61d4yHZg@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Follow-up with additional Snapper-side evidence and a clarification of
the scope.

I found two Snapper quota-query paths that could launch full rescans
even when qgroup status was already clean: calculateUsedSpace() and,
in the Debian 0.10.6 line, queryQuotaData(). Switching those paths to
the existing status-aware quota_rescan_if_needed() helper (while
retaining the required sync on the clean path) stopped rescans from
used-space queries and quota-aware timeline cleanup in QEMU. The
0.10.6 quota-limit cleanup test passed with the candidate kernel
module: eligible snapshots were deleted, exclusive usage fell as
expected, no new rescan or inconsistency occurred during cleanup, and
a later full rescan left counters unchanged.

This narrows the claim further: the kernel change is not a
demonstrated fix for incorrect qgroup accounting. On the stock Debian
7.1.13 module, the exact snapshot-only/tracker topology still takes
the conservative rescan fallback at snapshot inheritance; the scan
completes and the resulting counters agree with a full rescan. The
Snapper change removes avoidable scans caused by quota queries, but
does not change that kernel snapshot-inheritance decision. The kernel
candidate is therefore an optional, narrowly scoped optimization to
avoid that remaining snapshot-triggered scan for the exact two-child
tracker topology. Every other layout continues through the existing
fallback.

The earlier RFC already stated that no counter corruption had been
demonstrated. This follow-up supplies the missing Snapper-side result
and clarifies that the proposed kernel patch should be reviewed as a
performance/rescan optimization, not as an accounting correctness
repair. I will keep the patch at RFC status until the upstream-version
build and full quota-limit coverage are complete.

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
