Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7033917BED0
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253341; cv=pass; b=VXaWuO13kjT00myGW+2pA6ix2SNoi6oTCpLH3srkQKZEFzMaX9N95ZXLLmLid8OpG7jbLk0JlKgshgQvLiwHFkY5aH9DVTIZnJxNID8iA4MTZGV56rqG1aB1Mff7R3QzACxZs8zyspSVl/W0Pnd7AR5agH7HT1JpnsxQL/oL/2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253341; c=relaxed/simple;
	bh=pq8pfjZf3EgKXa4ltsbxCVTTOJSs9OkX7MXELMB4xI4=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WFnBrohBHayKNryD3EfVBf0gULBUMvRAN/UoFyXzbpFAJoWXV0oN3EMHjVq/ydLKRiM0euptFTxGRnjTYNM+MkZhegjauH6qcMdF5JVSaqMeo/a+503JJmm3GGO6IgaZYFfembU/aaMzC9DifiR5oh40oCJ+ZE8GfQo2dgmw6i4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8lLACPE; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8lLACPE"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ac8a2ac52bso9100017b3.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 09:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792253338; cv=none;
        d=google.com; s=arc-20260327;
        b=s4a2pOLkzDGDc7hlfZYgV3ghYlY86+QH12Mk0fJTgl241IMyabhGuJvcAajBem8X+2
         jQv8pG6EbzJg/tOgLq/wEuebfCOly9rpHhevrl8ZjANnN7sMJbVF13v5RhiWhEzYvFdg
         HsPXDtUorqGMXr8IRnvLHbMLQ1Lwnp9MKX9AvunJ4sVuoh8VFSLxW9x4qoAg+aCZc1l4
         meLWjVwsxoFmEuDMPPeq6SbImln29MG0FDhZBxIeAXF7/OQfljvl2RpDJ2JFSEOogmF5
         +bD/F6LRnZ4gY4Fuh4AQkNJ9wZ2ApMwrY+zTvOLAkQX2ZMVZ5cGyQC1kgd7fwCITzGbm
         r4Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=ss97Z7rvdi1w6mj6w6fglh0Nz6ttXNJkIMGOjoDZ8gk=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=sy2IU5Por5WzHOvzKJ92LGVr4QYnmhZUh9slL2IXtAXbR0X2fhQkn8aEsuTXG4AGqa
         xEJuOut1Ul+gtg3U2kAlKm9BW0CJ0sMc51GQ5hPvHxPou4LzrS7BTE5Vlafwxev0vKm5
         PPryYNjhvZcIcVmFaSSDyEoiDwWqTEhTT2lDWokkCwtTvUy2hTgznQ/ImfgMsHm14a2v
         +zrgcuNMpMLhjWkhXzbWKUbXP5kIgMM7sjzS838kitZ2Tpypb9b6v6//RXFV9MJs3Ao9
         Zm1QYC3jgGdI1075v91KYhvfr8XalH3WUcF6b0KvNsZmNgYeOVy86ky6Inpoyt15pZkJ
         rkOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792253338; x=1792858138; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ss97Z7rvdi1w6mj6w6fglh0Nz6ttXNJkIMGOjoDZ8gk=;
        b=k8lLACPEU1MxGM87uHyBIZ8FaZyzYcDHLrCzzGWBVRe9f66WipVKK8Y1VJoaeILqII
         2dvNQv8biBIayQD89p5Ezef4I7ndVI7JMlRn7dsljQEZbfreyDt+uXG6CoueLCxmugRj
         gpxYEEE7yHU+HwbYkYWfraYvEEEBfcfsqf7ST1okIifxuc3tOQo2Hr4c7g6ak8kGKJ5/
         TpGzxV8aTxJCPeMW0jEPutmh+GAQsbgBx7KLr4EK6SOWGNNkIKdhQaaG3NNF5ar681bZ
         948aS+jzmHDND+A2hyilW2bdKquVS60kPAslhJW25EQEjbKnAxjOg+EREHrx3CYBdluM
         MNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792253338; x=1792858138;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ss97Z7rvdi1w6mj6w6fglh0Nz6ttXNJkIMGOjoDZ8gk=;
        b=1l59a5VH5Tk3bHSxt4vmerLMugjpPeX15+X6ZCH+o3kDI2f8WktRidPOowf3bm+ywi
         mKfqc2US/3pqoevKt0uoe4dCUcNM02D91vdQqva+T9gz+c7mLw05po74aAZqeNhxC/1l
         Q3gOccJ+qhz8IohnKQHtbNCZYj/pX0NVNh6W8FhanrGB1yck3l3eGggCf/hy1iYdZgyi
         VN0qnkE2x8FcDon5aNmmvxBV4VE3aYkJZFwS3l9XxDGSeaEvoJ882uPhrEkWjH6MaBDv
         dEEguDA3ZGLigP+MgPjfmdM3XYgjxPr5J+cM6s0v1cUiajgSjlCpvQWCP/KwD+v9MLdT
         M4Ng==
X-Gm-Message-State: AFq9FYImq6RayN9v3Gi4S3ZdLZOlJYtLWsqoTaMdoUwHkTZmHdYhchQz
	qdUH0wxr/g5zZ/h3sacVwODB0VNjcdnEm9QSYqus7Us4TUUTY1b1A06xA/GiJO+EM5PBHGO7r8e
	1Gv+l74FwJv7FlXuXbFN/PKsX9eKYe11wOQ==
X-Gm-Gg: AYBFou22i68rnitfnyOwRpT6sTpnoI/Pk9AR3/pcdddMnjdL69Bt51dn2r7ePjDT3lt
	/Ao3T+72A6Xb/BoIVMUKOAR/h0eMnDfvnQgmSfhzeOmG8YXHZtMJb41PPe1wy1btbHbU01EvaVF
	YTgQuNmg1M24z5drGJB0wbM5rpBfo5hC+71c8yE26zOq+6Bpwtx4OxQ5AuAJJmvd4TZg+d9RtGk
	IdvaaoOiciWzf7rHLxPGxOuz7O4vo0/WGg9TQwEPxbnDbaYa5mlj8XKKtjL1r3T6w6oZtwrge/M
	Gje2SAwvvlmJS8u63qTUXIWQfK/XBYWKJbCXjRMKoOhJcu+gfezH
X-Received: by 2002:a05:690c:6608:b0:8ae:b617:712d with SMTP id
 00721157ae682-8b0f2119060mr10212347b3.13.1792253338325; Sat, 17 Oct 2026
 09:08:58 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 12:08:56 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 12:08:56 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
 <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 12:08:56 -0400
X-Gm-Features: AclHuK-LyAOqcDDyDu_0me5R7cP4t6BmnZze-DRhMLNRhXAiVSiXbrfbYCJO6cY
Message-ID: <CAFBxzAAAdx1m_BzvsqG1DKLPanr5cDqvoxhzqkVCdpXLpkt5eA@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Additional exact-version QEMU validation is now complete.

I rebuilt the initrd from the current Debian Snapper 0.10.6 branch
(commit 46fcfbea) and the narrowed Btrfs module for the running kernel
release string 7.1.13+deb13-amd64 (kernel change f06fc2e5; packaged
module SHA-256 de0ef9b7a9b0b0ee609fbbae2e234ba940bfcb70f94d4fc903bc48b37005=
9b96).
The Snapper executable and shared library in the guest matched the
current build outputs.

On a fresh Btrfs filesystem, the workload prepared the interrupted
state with only the configured snapshot qgroup attached to the
tracker. The next snapshot repaired the tracker and completed the
required scan. Successive hourly snapshots and timeline cleanup then
completed without qgroup inconsistency warnings or additional scans. A
full rescan after cleanup left the qgroup counters unchanged. The test
finished with SNAPPER-0106-INTEGRATION: PASS.

This adds recovery coverage for the current Debian Snapper candidate
alongside the earlier real-hour and quota-cleanup results. It does not
change the conclusion that the stock kernel's fallback is conservative
and that the kernel patch avoids a demonstrated recurring scan for the
tested topology; no counter corruption has been demonstrated. The
upstream-version kernel build and review remain open.

On Sat, 17 Oct 2026 11:45:13 -0400, R E Broadley <rebroad@gmail.com> wrote:
> Scope correction to the RFC candidate before any formal patch submission.
>
> The earlier candidate also relaxed the existing fast path for the unrelat=
ed case where the source already has the target qgroup as its parent. I hav=
e restored the previous guard there: if parent->excl !=3D parent->rfer, tha=
t case still requests a rescan. The new optimization is limited to the sepa=
rate tracker case (source's sole parent is the tracker; target qgroup's sol=
e parent is that tracker; tracker has exactly source and target as members)=
. Other layouts retain their prior fallback behavior.
>
> I rebuilt the narrowed module for the currently used Debian 7.1.13+deb13-=
amd64 kernel and reran the corrected real-hour QEMU workloads. Snapper 0.10=
.6 and 0.13.2 both pass 01:00-04:00 snapshot rounds, quota-aware cleanup, a=
nd full-rescan counter comparison with the narrowed candidate. I also teste=
d the preserved same-parent boundary using an outside snapshot that shares =
extents: qgroup 1/100 had referenced=3D8,404,992 and exclusive=3D16,384; cr=
eating an inherited snapshot emitted "qgroup inherit needs a rescan", compl=
eted one scan, and a subsequent full rescan left counters unchanged.
>
> The exact narrowed source change is pushed at https://github.com/rebroad/=
linux/commit/f06fc2e5cdc8. The patch remains an optimization for avoiding r=
epeated scans in the proven tracker hierarchy; I still have no evidence tha=
t stock accounting is incorrect. The upstream v7.3-rc7 build and maintainer=
 review remain open.
>
> On Sat, 17 Oct 2026 10:44:15 -0400, R E Broadley <rebroad@gmail.com> wrot=
e:
> > Hello,
> >
> > I could not find an upstream report for this specific qgroup hierarchy.=
 There is a related quick-inherit optimization for snapshots assigned to th=
e same exclusive parent (linux-btrfs, 2024), and mainline now has fixes for=
 full-vs-simple quota handling and updating ancestor qgroups. This report c=
oncerns a different layout.
> >
> > With full qgroups, Snapper's snapshot-only quota group does not contain=
 the live source subvolume. The source and the new snapshot-only qgroup ins=
tead share a level-2 tracking parent. The tracker has exactly those two chi=
ldren, and the snapshot-only qgroup has exactly that one parent. On Debian'=
s 7.1.13+deb13-amd64 Btrfs module, snapshot inheritance for this layout tak=
es the conservative "qgroup inherit needs a rescan" path. The rescan comple=
tes and accounting matches a subsequent full rescan; I have not found evide=
nce of incorrect accounting in the stock kernel.
> >
> > A candidate quick-inherit extension is included below for discussion. I=
t is limited to full qgroups and the exact two-child topology above. It der=
ives the snapshot qgroup's referenced counters from the tracker, preserves =
its snapshot-only exclusive counters except for the new root node, and uses=
 the existing iterator to update the tracker and its ancestors. All other l=
ayouts retain the rescan fallback.
> >
> > Evidence so far:
> > - A QEMU control using the same Debian kernel image, Snapper 0.10.6 and=
 the stock Btrfs module logged "qgroup inherit needs a rescan" and performe=
d one recovery scan.
> > - With the candidate Btrfs module and the same source-only tracker work=
flow, tracker repair plus snapshot creation did not start a scan or mark qg=
roups inconsistent.
> > - Repeated two-config snapshots and timeline cleanup passed with compre=
ssed data and externally shared snapshots on the candidate kernel; a later =
explicit full-rescan comparison left counters unchanged.
> > - The QEMU behavior tests were run on 7.1.13. I verified that the attac=
hed diff applies cleanly to current upstream v7.3-rc7, but have not built o=
r run the tests on that version. Quota-limit enforcement coverage is also s=
till outstanding.
> >
> > The stock kernel's fallback appears conservative and correct. The propo=
sed change is an optimization to avoid repeated rescans while preserving th=
e snapshot-only quota scope, not a fix for demonstrated counter corruption.=
 Please review whether the tracker conditions and counter derivation are su=
fficient, and whether this belongs as a kernel quick-inherit optimization. =
I will send a formal patch revision after review and the remaining quota-li=
mit coverage.
> >
> > This is an RFC discussion; the diff has no Signed-off-by line.
> >
> > ---
> > Candidate diff against upstream/master:
> >
> > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > index f68b696b4bf7..300607c10a6a 100644
> > --- a/fs/btrfs/qgroup.c
> > +++ b/fs/btrfs/qgroup.c
> > @@ -3263,9 +3263,10 @@ static int qgroup_auto_inherit(struct btrfs_fs_i=
nfo *fs_info,
> >  }
> >
> >  /*
> > - * Check if we can skip rescan when inheriting qgroups.  If @src has a=
 single
> > - * @parent, and that @parent is owning all its bytes exclusively, we c=
an skip
> > - * the full rescan, by just adding nodesize to the @parent's excl/rfer=
.
> > + * Check if we can skip rescan when inheriting qgroups.  This is possi=
ble when
> > + * the source already belongs to the target parent, or when a tracking=
 parent
> > + * contains only the source and target parent and lets us derive the t=
arget's
> > + * counters exactly.
> >   *
> >   * Return <0 for fatal errors (like srcid/parentid has no qgroup).
> >   * Return 0 if a quick inherit is done.
> > @@ -3276,11 +3277,17 @@ static int qgroup_snapshot_quick_inherit(struct=
 btrfs_fs_info *fs_info,
> >  {
> >  	struct btrfs_qgroup *src;
> >  	struct btrfs_qgroup *parent;
> > +	struct btrfs_qgroup *tracker;
> >  	struct btrfs_qgroup *qgroup;
> >  	struct btrfs_qgroup_list *list;
> >  	LIST_HEAD(qgroup_list);
> >  	const u32 nodesize =3D fs_info->nodesize;
> > +	u64 new_excl;
> > +	u64 new_excl_cmpr;
> >  	int nr_parents =3D 0;
> > +	int nr_members =3D 0;
> > +	bool tracker_has_src =3D false;
> > +	bool tracker_has_parent =3D false;
> >
> >  	if (btrfs_qgroup_mode(fs_info) !=3D BTRFS_QGROUP_MODE_FULL)
> >  		return 0;
> > @@ -3299,27 +3306,67 @@ static int qgroup_snapshot_quick_inherit(struct=
 btrfs_fs_info *fs_info,
> >  	if (list_empty(&src->groups))
> >  		return 1;
> >
> > -	list_for_each_entry(list, &src->groups, next_group) {
> > -		/* The parent is not the same, quick update is not possible. */
> > -		if (list->group->qgroupid !=3D parentid)
> > -			return 1;
> > +	list_for_each_entry(list, &src->groups, next_group)
> >  		nr_parents++;
> > +	if (nr_parents !=3D 1)
> > +		return 1;
> > +	tracker =3D list_first_entry(&src->groups, struct btrfs_qgroup_list,
> > +				   next_group)->group;
> > +
> > +	if (tracker =3D=3D parent) {
> >  		/*
> > -		 * More than one parent qgroup, we can't be sure about accounting
> > -		 * consistency.
> > +		 * The parent already contains the source.  The snapshot only adds
> > +		 * its new root node to the parent, even when some source extents
> > +		 * are also referenced outside the parent.
> >  		 */
> > -		if (nr_parents > 1)
> > +		qgroup_iterator_add(&qgroup_list, parent);
> > +	} else {
> > +		/*
> > +		 * A tracking qgroup can account for a snapshot-only parent when it
> > +		 * contains exactly that parent and the source.  Before the snapshot=
,
> > +		 * the union of those groups is the same set of extents as the
> > +		 * snapshot parent will contain afterwards, except that the source
> > +		 * root is replaced by the new snapshot root.  The source's exclusiv=
e
> > +		 * extents are the part of the tracker that must not be charged to
> > +		 * the snapshot-only parent.
> > +		 */
> > +		if (!list_is_singular(&parent->groups) ||
> > +		    list_first_entry(&parent->groups, struct btrfs_qgroup_list,
> > +				     next_group)->group !=3D tracker)
> >  			return 1;
> > -	}
> >
> > -	/*
> > -	 * The parent is not exclusively owning all its bytes.  We're not sur=
e
> > -	 * if the source has any bytes not fully owned by the parent.
> > -	 */
> > -	if (parent->excl !=3D parent->rfer)
> > -		return 1;
> > +		list_for_each_entry(list, &tracker->members, next_member) {
> > +			nr_members++;
> > +			if (list->member =3D=3D src)
> > +				tracker_has_src =3D true;
> > +			else if (list->member =3D=3D parent)
> > +				tracker_has_parent =3D true;
> > +			else
> > +				return 1;
> > +		}
> > +		if (nr_members !=3D 2 || !tracker_has_src || !tracker_has_parent ||
> > +		    tracker->rfer > U64_MAX - nodesize ||
> > +		    tracker->rfer_cmpr > U64_MAX - nodesize ||
> > +		    parent->excl > U64_MAX - nodesize ||
> > +		    parent->excl_cmpr > U64_MAX - nodesize)
> > +			return 1;
> > +
> > +		/*
> > +		 * The source remains outside the snapshot-only parent after the
> > +		 * snapshot is created.  Its data is therefore not exclusive to the
> > +		 * snapshot parent, including extents already shared with snapshots.
> > +		 * Keep the existing exclusive count and add only the new root node.
> > +		 */
> > +		new_excl =3D parent->excl + nodesize;
> > +		new_excl_cmpr =3D parent->excl_cmpr + nodesize;
> > +		parent->rfer =3D tracker->rfer;
> > +		parent->rfer_cmpr =3D tracker->rfer_cmpr;
> > +		parent->excl =3D new_excl;
> > +		parent->excl_cmpr =3D new_excl_cmpr;
> > +		qgroup_dirty(fs_info, parent);
> > +		qgroup_iterator_add(&qgroup_list, tracker);
> > +	}
> >
> > -	qgroup_iterator_add(&qgroup_list, parent);
> >  	list_for_each_entry(qgroup, &qgroup_list, iterator) {
> >  		qgroup->rfer +=3D nodesize;
> >  		qgroup->rfer_cmpr +=3D nodesize;
