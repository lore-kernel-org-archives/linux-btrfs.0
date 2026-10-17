Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40282248B3
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254098; cv=pass; b=Z3ZQGW13GGXayFa4aW28FRRFkWIrz5nfOd8Q4RHALhTNVMuBpUIpxvI4kk3xhJAqvqKcKKpm2qt7uxrNh27rPOv0K8GY/Q2itXJJt7QI4WeZsbHJetC9FQEnxEuecerk3NeWdt/mvfHCM8b/egbHd79u6igsMzkssB9fIXE68xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254098; c=relaxed/simple;
	bh=FzmApftVEiEcy/BpIeLA56Jr6HIP1fhQj9wEohoTUVg=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qwbT1pL71jz0V1fRf7jR4XrNZi0lZX63bJTkkiFROU/02vapC8JukAVC8ONAHzXlMMl6ADo93rraNMLgt7Y9B1y63/dwpfDkv5m3udUrl2wvMKZpjXBZn2t87qGO99IYz9+El1k++t5VrPnOnZmCNDjUnZp1K683RudqvXnFo2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRydKgws; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRydKgws"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b0c5a64de8so16250397b3.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 09:21:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792254096; cv=none;
        d=google.com; s=arc-20260327;
        b=YZtid4mq572rC3JFWRx6qCU/ACrse8dk3LEA71wU3IumBrwzbUifmFTHtBOSQaH8Y0
         w4oc5EVKN809utgVOszJjk0aeLXM02+opWdV9KckdMQdJH64TMEFUfrpoI6q6fSTIAeu
         PHkQnnforgDnDQ+cC+w+i+F6W5QgxcMfLEJtSLYht6X4C8AWckOIe/ZPMPTvmdP7+PlL
         chgeEPhltkye1Ur/wTSXElYeMSg4hPIntSD589cFOzoLBwDAvKUkD/rLU8jbHuZLmu32
         E5lJ545SitiFDrg4dnhvA8r6mUgoLpxP/3yV3jlgFzqlMWYFntkVL3dm4xwlmPEg3Nvk
         xFQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=USucXjotjx9DPlTBiyaPeLxAb7Rmj+RVSwRj6MSHv1w=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=jx2U/SDkx0e4/UqPRvtuEPkb1qFokCnl28XDiJgbMYlP8SH2rc5dZhSmvMyaZzfVFe
         IuPsGVOgTh4nO73mGeLW4LLdConZ3KgsG3hnrmL/AiA4vqatt8kh6LDyq/Z5f0ecEnEV
         uF1X47QuekJYkNYxohpbjuNxQeZaqHD32e9vfIBZ99zy/Wk1kbIzzj4utS9mYnxVhusL
         kb6kdewXB2/v/5RlRFEzTDijXx+LzNlNUEYutXEkcRoRAFursW9x38Vvakgzn3161gcS
         d0Fe9PUyRtyjiXJrT7NFfDN0GZtB5P0k+qX+yJU4/FRNtgqHHX7sx1pFiHMBii3Nb5Kx
         DG2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792254096; x=1792858896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=USucXjotjx9DPlTBiyaPeLxAb7Rmj+RVSwRj6MSHv1w=;
        b=YRydKgwsT9mZAe9j79zDQjg+VB+tT4Uv0ZcG2gTniBQFYhgubPflKWLYyeXTkEsZKB
         KCqDD2fF+dDmaKQIogC0OMI/Bw1CnuxYbIhiZevtPu/OWKZhXFoijZx5DPNiKPqwaOpc
         PRM3JY+55beaWAVEbLkjYH7g7CSOQkRvNePi/xd+8SJeWk22Y/hUFJ3kyCgJ6OF3FM6X
         n2x6b5yQUA2uuILeRa6aW8LiKlA3yaAn+5d6OCIq0cW/aWN9nIlkYNxd0XxdBr0Hvxn7
         9+yJguDZ58eLGyG8IVW2/Gmrk2a96GJy07ONpjyfNzHQvV4IRf4g0++/iRKuOkAXjEGz
         6CWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792254096; x=1792858896;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=USucXjotjx9DPlTBiyaPeLxAb7Rmj+RVSwRj6MSHv1w=;
        b=nqnVNN0dW4a/4s+yhmC7nxnPOHUQtoUtgES97kflcBjMtIU96FD0AADZCc0XYXlYb1
         wc8llwsGxG66M8L2LinR++l8oNrc40xpOC07XG+/07tnRyJR0BPA1dyd+ii9BI6dlHr9
         EJxG3QlGBabji3UQEhFT62p/a4r4aE93Q7WHxQchVVFxwT5O5r7DUBTsUyBsoEVUbXBw
         kTGpuqjOUphecl4FlhztAg4K0TtnqQd+KP7StptGR/iDp6Jl8/WxZZhdCrT13ncEBaSa
         q2sCmVuAxdtE2oF1kNIGtCIuZPQXco42IKCbaDn7lxIYdmd1nCR7Y0hg995M69RaB8JO
         btsg==
X-Gm-Message-State: AFq9FYLTIGBw/WWD/Z9gFOBmuXF7sbukXnYuxFCPJq0I4qUnvmokjzgF
	U38pOxByS2+6Tgjd7XmnSkxd/H2UQJYg5FtwWB4/7IVI+9Lv+oDjdpu5QsEzzeu7rXd2KnNxNev
	VcixeRSSdGYVBrujjpKufvdR99/J7rcwzvQ==
X-Gm-Gg: AYBFou2a2gOulD0mUHPfPnBuuMUOlDe/R1S+DalxRs9fJouQzWyIZxLcbVDiSK4/Q8o
	DwEWyXyG4P5IzI7N4hgr4UyS/KrFX4qqpKFQfiwHaG8Qpbt4/y2XjIs33Y+Qg7ACwfCrx70fFqW
	OjC2RyzTYhlVopV+thDV9ymnloIc3nKK8v8z80cPRY3yP46WJS38RR4teccHrAKw1LMa1f1RkyZ
	kX61xvEOad9wHq2M3uNI/uMDfPB00IXZTHB1zOWLPsD8tq+ms38mDxAQcsDHS9KOIuD/vM4TOKt
	QyjFuxf3hfm8xRE9AYQnsx/t9dUrfakPMphypdPXMFa1X3/tJgB8
X-Received: by 2002:a05:690c:e1dc:10b0:8ae:68d9:cef4 with SMTP id
 00721157ae682-8b0e2dff670mr13974457b3.28.1792254095736; Sat, 17 Oct 2026
 09:21:35 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 12:21:33 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 12:21:33 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzAAAdx1m_BzvsqG1DKLPanr5cDqvoxhzqkVCdpXLpkt5eA@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
 <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com> <CAFBxzAAAdx1m_BzvsqG1DKLPanr5cDqvoxhzqkVCdpXLpkt5eA@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 12:21:33 -0400
X-Gm-Features: AclHuK8_2xxTkdtmuA0ENaplMvTQte7vtyBK7-y361mNSfWKju8NvacTZX0QOVU
Message-ID: <CAFBxzAC0bjaFaH-i6S0DFFP025o=6V4QVsnBQk92P20XVrvthg@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Upstream compatibility update for the RFC.

The v7.3-rc7 qgroup helper already has the two-argument interface, so
the earlier Debian-based diff did not apply verbatim. I forward-ported
only the helper logic to the v7.3-rc7 source (tag commit
24a19b953e2a3d0ea5a8c4951a0ab8f32720c907). The resulting diff applies
cleanly to that tag and changes only fs/btrfs/qgroup.c.

The Btrfs module target compiled and linked to btrfs.ko with
KBUILD_MODPOST_WARN=3D1. This isolated build tree has neither vmlinux
nor Module.symvers, so modpost reported 636 unresolved kernel symbols
and BTF generation was skipped. This verifies compilation of the
forward-ported source but does not make the module suitable for
loading or establish runtime behavior on v7.3-rc7. Runtime QEMU
coverage remains on the in-use Debian 7.1.13+deb13-amd64 kernel, where
the narrowed module passed the current Snapper 0.10.6
recovery/hourly/cleanup workload.

The RFC remains open for review. I have not treated this limited
module build as a complete upstream build or runtime test.

--- v7.3-rc7 candidate diff ---
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f68b696b4bf7..496f6cee6757 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3263,9 +3263,10 @@ static int qgroup_auto_inherit(struct
btrfs_fs_info *fs_info,
 }

 /*
- * Check if we can skip rescan when inheriting qgroups.  If @src has a sin=
gle
- * @parent, and that @parent is owning all its bytes exclusively, we can s=
kip
- * the full rescan, by just adding nodesize to the @parent's excl/rfer.
+ * Check if we can skip rescan when inheriting qgroups.  This is possible =
when
+ * the source already belongs to the target parent, or when a tracking par=
ent
+ * contains only the source and target parent and lets us derive the targe=
t's
+ * counters exactly.
  *
  * Return <0 for fatal errors (like srcid/parentid has no qgroup).
  * Return 0 if a quick inherit is done.
@@ -3276,11 +3277,17 @@ static int
qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_qgroup *src;
 	struct btrfs_qgroup *parent;
+	struct btrfs_qgroup *tracker;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_list *list;
 	LIST_HEAD(qgroup_list);
 	const u32 nodesize =3D fs_info->nodesize;
+	u64 new_excl;
+	u64 new_excl_cmpr;
 	int nr_parents =3D 0;
+	int nr_members =3D 0;
+	bool tracker_has_src =3D false;
+	bool tracker_has_parent =3D false;

 	if (btrfs_qgroup_mode(fs_info) !=3D BTRFS_QGROUP_MODE_FULL)
 		return 0;
@@ -3299,27 +3306,70 @@ static int
qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 	if (list_empty(&src->groups))
 		return 1;

-	list_for_each_entry(list, &src->groups, next_group) {
-		/* The parent is not the same, quick update is not possible. */
-		if (list->group->qgroupid !=3D parentid)
-			return 1;
+	list_for_each_entry(list, &src->groups, next_group)
 		nr_parents++;
+	if (nr_parents !=3D 1)
+		return 1;
+	tracker =3D list_first_entry(&src->groups, struct btrfs_qgroup_list,
+				   next_group)->group;
+
+	if (tracker =3D=3D parent) {
 		/*
-		 * More than one parent qgroup, we can't be sure about accounting
-		 * consistency.
+		 * The parent already contains the source.  The snapshot only adds
+		 * its new root node to the parent. Keep the existing exclusivity
+		 * check for this case; the tracking-parent optimization below is
+		 * separate and does not change this path.
 		 */
-		if (nr_parents > 1)
+		if (parent->excl !=3D parent->rfer)
+			return 1;
+		qgroup_iterator_add(&qgroup_list, parent);
+	} else {
+		/*
+		 * A tracking qgroup can account for a snapshot-only parent when it
+		 * contains exactly that parent and the source.  Before the snapshot,
+		 * the union of those groups is the same set of extents as the
+		 * snapshot parent will contain afterwards, except that the source
+		 * root is replaced by the new snapshot root.  The source's exclusive
+		 * extents are the part of the tracker that must not be charged to
+		 * the snapshot-only parent.
+		 */
+		if (!list_is_singular(&parent->groups) ||
+		    list_first_entry(&parent->groups, struct btrfs_qgroup_list,
+				     next_group)->group !=3D tracker)
 			return 1;
-	}

-	/*
-	 * The parent is not exclusively owning all its bytes.  We're not sure
-	 * if the source has any bytes not fully owned by the parent.
-	 */
-	if (parent->excl !=3D parent->rfer)
-		return 1;
+		list_for_each_entry(list, &tracker->members, next_member) {
+			nr_members++;
+			if (list->member =3D=3D src)
+				tracker_has_src =3D true;
+			else if (list->member =3D=3D parent)
+				tracker_has_parent =3D true;
+			else
+				return 1;
+		}
+		if (nr_members !=3D 2 || !tracker_has_src || !tracker_has_parent ||
+		    tracker->rfer > U64_MAX - nodesize ||
+		    tracker->rfer_cmpr > U64_MAX - nodesize ||
+		    parent->excl > U64_MAX - nodesize ||
+		    parent->excl_cmpr > U64_MAX - nodesize)
+			return 1;
+
+		/*
+		 * The source remains outside the snapshot-only parent after the
+		 * snapshot is created.  Its data is therefore not exclusive to the
+		 * snapshot parent, including extents already shared with snapshots.
+		 * Keep the existing exclusive count and add only the new root node.
+		 */
+		new_excl =3D parent->excl + nodesize;
+		new_excl_cmpr =3D parent->excl_cmpr + nodesize;
+		parent->rfer =3D tracker->rfer;
+		parent->rfer_cmpr =3D tracker->rfer_cmpr;
+		parent->excl =3D new_excl;
+		parent->excl_cmpr =3D new_excl_cmpr;
+		qgroup_dirty(fs_info, parent);
+		qgroup_iterator_add(&qgroup_list, tracker);
+	}

-	qgroup_iterator_add(&qgroup_list, parent);
 	list_for_each_entry(qgroup, &qgroup_list, iterator) {
 		qgroup->rfer +=3D nodesize;
 		qgroup->rfer_cmpr +=3D nodesize;


On Sat, 17 Oct 2026 12:08:56 -0400, R E Broadley <rebroad@gmail.com> wrote:
> Additional exact-version QEMU validation is now complete.
>
> I rebuilt the initrd from the current Debian Snapper 0.10.6 branch (commi=
t 46fcfbea) and the narrowed Btrfs module for the running kernel release st=
ring 7.1.13+deb13-amd64 (kernel change f06fc2e5; packaged module SHA-256 de=
0ef9b7a9b0b0ee609fbbae2e234ba940bfcb70f94d4fc903bc48b370059b96). The Snappe=
r executable and shared library in the guest matched the current build outp=
uts.
>
> On a fresh Btrfs filesystem, the workload prepared the interrupted state =
with only the configured snapshot qgroup attached to the tracker. The next =
snapshot repaired the tracker and completed the required scan. Successive h=
ourly snapshots and timeline cleanup then completed without qgroup inconsis=
tency warnings or additional scans. A full rescan after cleanup left the qg=
roup counters unchanged. The test finished with SNAPPER-0106-INTEGRATION: P=
ASS.
>
> This adds recovery coverage for the current Debian Snapper candidate alon=
gside the earlier real-hour and quota-cleanup results. It does not change t=
he conclusion that the stock kernel's fallback is conservative and that the=
 kernel patch avoids a demonstrated recurring scan for the tested topology;=
 no counter corruption has been demonstrated. The upstream-version kernel b=
uild and review remain open.
>
> On Sat, 17 Oct 2026 11:45:13 -0400, R E Broadley <rebroad@gmail.com> wrot=
e:
> > Scope correction to the RFC candidate before any formal patch submissio=
n.
> >
> > The earlier candidate also relaxed the existing fast path for the unrel=
ated case where the source already has the target qgroup as its parent. I h=
ave restored the previous guard there: if parent->excl !=3D parent->rfer, t=
hat case still requests a rescan. The new optimization is limited to the se=
parate tracker case (source's sole parent is the tracker; target qgroup's s=
ole parent is that tracker; tracker has exactly source and target as member=
s). Other layouts retain their prior fallback behavior.
> >
> > I rebuilt the narrowed module for the currently used Debian 7.1.13+deb1=
3-amd64 kernel and reran the corrected real-hour QEMU workloads. Snapper 0.=
10.6 and 0.13.2 both pass 01:00-04:00 snapshot rounds, quota-aware cleanup,=
 and full-rescan counter comparison with the narrowed candidate. I also tes=
ted the preserved same-parent boundary using an outside snapshot that share=
s extents: qgroup 1/100 had referenced=3D8,404,992 and exclusive=3D16,384; =
creating an inherited snapshot emitted "qgroup inherit needs a rescan", com=
pleted one scan, and a subsequent full rescan left counters unchanged.
> >
> > The exact narrowed source change is pushed at https://github.com/rebroa=
d/linux/commit/f06fc2e5cdc8. The patch remains an optimization for avoiding=
 repeated scans in the proven tracker hierarchy; I still have no evidence t=
hat stock accounting is incorrect. The upstream v7.3-rc7 build and maintain=
er review remain open.
> >
> > On Sat, 17 Oct 2026 10:44:15 -0400, R E Broadley <rebroad@gmail.com> wr=
ote:
> > > Hello,
> > >
> > > I could not find an upstream report for this specific qgroup hierarch=
y. There is a related quick-inherit optimization for snapshots assigned to =
the same exclusive parent (linux-btrfs, 2024), and mainline now has fixes f=
or full-vs-simple quota handling and updating ancestor qgroups. This report=
 concerns a different layout.
> > >
> > > With full qgroups, Snapper's snapshot-only quota group does not conta=
in the live source subvolume. The source and the new snapshot-only qgroup i=
nstead share a level-2 tracking parent. The tracker has exactly those two c=
hildren, and the snapshot-only qgroup has exactly that one parent. On Debia=
n's 7.1.13+deb13-amd64 Btrfs module, snapshot inheritance for this layout t=
akes the conservative "qgroup inherit needs a rescan" path. The rescan comp=
letes and accounting matches a subsequent full rescan; I have not found evi=
dence of incorrect accounting in the stock kernel.
> > >
> > > A candidate quick-inherit extension is included below for discussion.=
 It is limited to full qgroups and the exact two-child topology above. It d=
erives the snapshot qgroup's referenced counters from the tracker, preserve=
s its snapshot-only exclusive counters except for the new root node, and us=
es the existing iterator to update the tracker and its ancestors. All other=
 layouts retain the rescan fallback.
> > >
> > > Evidence so far:
> > > - A QEMU control using the same Debian kernel image, Snapper 0.10.6 a=
nd the stock Btrfs module logged "qgroup inherit needs a rescan" and perfor=
med one recovery scan.
> > > - With the candidate Btrfs module and the same source-only tracker wo=
rkflow, tracker repair plus snapshot creation did not start a scan or mark =
qgroups inconsistent.
> > > - Repeated two-config snapshots and timeline cleanup passed with comp=
ressed data and externally shared snapshots on the candidate kernel; a late=
r explicit full-rescan comparison left counters unchanged.
> > > - The QEMU behavior tests were run on 7.1.13. I verified that the att=
ached diff applies cleanly to current upstream v7.3-rc7, but have not built=
 or run the tests on that version. Quota-limit enforcement coverage is also=
 still outstanding.
> > >
> > > The stock kernel's fallback appears conservative and correct. The pro=
posed change is an optimization to avoid repeated rescans while preserving =
the snapshot-only quota scope, not a fix for demonstrated counter corruptio=
n. Please review whether the tracker conditions and counter derivation are =
sufficient, and whether this belongs as a kernel quick-inherit optimization=
. I will send a formal patch revision after review and the remaining quota-=
limit coverage.
> > >
> > > This is an RFC discussion; the diff has no Signed-off-by line.
> > >
> > > ---
> > > Candidate diff against upstream/master:
> > >
> > > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > > index f68b696b4bf7..300607c10a6a 100644
> > > --- a/fs/btrfs/qgroup.c
> > > +++ b/fs/btrfs/qgroup.c
> > > @@ -3263,9 +3263,10 @@ static int qgroup_auto_inherit(struct btrfs_fs=
_info *fs_info,
> > >  }
> > >
> > >  /*
> > > - * Check if we can skip rescan when inheriting qgroups.  If @src has=
 a single
> > > - * @parent, and that @parent is owning all its bytes exclusively, we=
 can skip
> > > - * the full rescan, by just adding nodesize to the @parent's excl/rf=
er.
> > > + * Check if we can skip rescan when inheriting qgroups.  This is pos=
sible when
> > > + * the source already belongs to the target parent, or when a tracki=
ng parent
> > > + * contains only the source and target parent and lets us derive the=
 target's
> > > + * counters exactly.
> > >   *
> > >   * Return <0 for fatal errors (like srcid/parentid has no qgroup).
> > >   * Return 0 if a quick inherit is done.
> > > @@ -3276,11 +3277,17 @@ static int qgroup_snapshot_quick_inherit(stru=
ct btrfs_fs_info *fs_info,
> > >  {
> > >  	struct btrfs_qgroup *src;
> > >  	struct btrfs_qgroup *parent;
> > > +	struct btrfs_qgroup *tracker;
> > >  	struct btrfs_qgroup *qgroup;
> > >  	struct btrfs_qgroup_list *list;
> > >  	LIST_HEAD(qgroup_list);
> > >  	const u32 nodesize =3D fs_info->nodesize;
> > > +	u64 new_excl;
> > > +	u64 new_excl_cmpr;
> > >  	int nr_parents =3D 0;
> > > +	int nr_members =3D 0;
> > > +	bool tracker_has_src =3D false;
> > > +	bool tracker_has_parent =3D false;
> > >
> > >  	if (btrfs_qgroup_mode(fs_info) !=3D BTRFS_QGROUP_MODE_FULL)
> > >  		return 0;
> > > @@ -3299,27 +3306,67 @@ static int qgroup_snapshot_quick_inherit(stru=
ct btrfs_fs_info *fs_info,
> > >  	if (list_empty(&src->groups))
> > >  		return 1;
> > >
> > > -	list_for_each_entry(list, &src->groups, next_group) {
> > > -		/* The parent is not the same, quick update is not possible. */
> > > -		if (list->group->qgroupid !=3D parentid)
> > > -			return 1;
> > > +	list_for_each_entry(list, &src->groups, next_group)
> > >  		nr_parents++;
> > > +	if (nr_parents !=3D 1)
> > > +		return 1;
> > > +	tracker =3D list_first_entry(&src->groups, struct btrfs_qgroup_list=
,
> > > +				   next_group)->group;
> > > +
> > > +	if (tracker =3D=3D parent) {
> > >  		/*
> > > -		 * More than one parent qgroup, we can't be sure about accounting
> > > -		 * consistency.
> > > +		 * The parent already contains the source.  The snapshot only adds
> > > +		 * its new root node to the parent, even when some source extents
> > > +		 * are also referenced outside the parent.
> > >  		 */
> > > -		if (nr_parents > 1)
> > > +		qgroup_iterator_add(&qgroup_list, parent);
> > > +	} else {
> > > +		/*
> > > +		 * A tracking qgroup can account for a snapshot-only parent when i=
t
> > > +		 * contains exactly that parent and the source.  Before the snapsh=
ot,
> > > +		 * the union of those groups is the same set of extents as the
> > > +		 * snapshot parent will contain afterwards, except that the source
> > > +		 * root is replaced by the new snapshot root.  The source's exclus=
ive
> > > +		 * extents are the part of the tracker that must not be charged to
> > > +		 * the snapshot-only parent.
> > > +		 */
> > > +		if (!list_is_singular(&parent->groups) ||
> > > +		    list_first_entry(&parent->groups, struct btrfs_qgroup_list,
> > > +				     next_group)->group !=3D tracker)
> > >  			return 1;
> > > -	}
> > >
> > > -	/*
> > > -	 * The parent is not exclusively owning all its bytes.  We're not s=
ure
> > > -	 * if the source has any bytes not fully owned by the parent.
> > > -	 */
> > > -	if (parent->excl !=3D parent->rfer)
> > > -		return 1;
> > > +		list_for_each_entry(list, &tracker->members, next_member) {
> > > +			nr_members++;
> > > +			if (list->member =3D=3D src)
> > > +				tracker_has_src =3D true;
> > > +			else if (list->member =3D=3D parent)
> > > +				tracker_has_parent =3D true;
> > > +			else
> > > +				return 1;
> > > +		}
> > > +		if (nr_members !=3D 2 || !tracker_has_src || !tracker_has_parent |=
|
> > > +		    tracker->rfer > U64_MAX - nodesize ||
> > > +		    tracker->rfer_cmpr > U64_MAX - nodesize ||
> > > +		    parent->excl > U64_MAX - nodesize ||
> > > +		    parent->excl_cmpr > U64_MAX - nodesize)
> > > +			return 1;
> > > +
> > > +		/*
> > > +		 * The source remains outside the snapshot-only parent after the
> > > +		 * snapshot is created.  Its data is therefore not exclusive to th=
e
> > > +		 * snapshot parent, including extents already shared with snapshot=
s.
> > > +		 * Keep the existing exclusive count and add only the new root nod=
e.
> > > +		 */
> > > +		new_excl =3D parent->excl + nodesize;
> > > +		new_excl_cmpr =3D parent->excl_cmpr + nodesize;
> > > +		parent->rfer =3D tracker->rfer;
> > > +		parent->rfer_cmpr =3D tracker->rfer_cmpr;
> > > +		parent->excl =3D new_excl;
> > > +		parent->excl_cmpr =3D new_excl_cmpr;
> > > +		qgroup_dirty(fs_info, parent);
> > > +		qgroup_iterator_add(&qgroup_list, tracker);
> > > +	}
> > >
> > > -	qgroup_iterator_add(&qgroup_list, parent);
> > >  	list_for_each_entry(qgroup, &qgroup_list, iterator) {
> > >  		qgroup->rfer +=3D nodesize;
> > >  		qgroup->rfer_cmpr +=3D nodesize;
