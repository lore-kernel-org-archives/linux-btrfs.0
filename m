Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1083BF684
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 18:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260357; cv=pass; b=QHal9XjVUEW6YHo8DbtaMyITJTUZ81Q5ks/jjD59tBntPV03CWE53EHyyG3j9bRbyNs6x5DM7Q3p7BnC+c4invgqLHPHDADWVjBZJpVT2ypF1QODcy1icKEBDfbN7kSFgYOMNh9cdMLQCJS9iBsniDacOpZ4PqWVX5/CU5Mhb7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260357; c=relaxed/simple;
	bh=ruOx3G5ituzuJvrW7gt88kcw0EA5ksqOphx47M9PWmU=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CYs5ItCRMwIdGSO5zSVstAlqDZBon9WGiYnvuVI/e/9J/1qg9KJUBbUFiqRH4yL2igonBnQMQscmpxuZ37P1u+vcuwdCLrPcziRU40mrBrP3DuklG9rLA6bSv02sx+hL7hUg7sXnRw/bYSB/UsKzi5YrZ/R4QbJg9SXXkBYTzDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8kSTnoR; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8kSTnoR"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8ab432273c5so6906807b3.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 11:05:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792260354; cv=none;
        d=google.com; s=arc-20260327;
        b=dap1dkNwHQCX9rmeOPxwRJAo8gnN2DIAQdRaRiWBqjO5FXJsSRNw9rIQ5CdPL8zx8n
         dwOEGT0oQ3k8Msk6r/pLagzjWZLZAIZBeo3Btu+hGHPlWi+vq0Bmaqm0wspFBQpVt5jw
         L7PZouvBNhWTkvVEIj0FoX36CB3zI6hPCmil47l8t8PJfF+HwiBu/tE1Rjgs6PURZ0Cy
         kcG0s+w2JbRc2lPDksxRKS6KFYG5xGPNxxJ1FP8EXK7BgBwcvXutWShiVh9k8xEKVjG3
         ZVQe/h2BpeT7SGOIoCHbvtzMLtG/VpgQCtrRtfFOrreFsmB2gF/Vw0Way83Ro7jQAO1o
         xYsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=5WYz1Retd24HUnvvdl9jkRLzPG0/UPeYjwKPSTILvsw=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=cwzmHoXfzw5a3OyxSQ5HB1RtKIn2ClaIry0ZFNOlLRp75GVagoH1ibRdRW+8/Oe9g2
         CRJxrVgeuAwmvlwemnJ2Fvr6Co83FyMtCTbh2E6GzWiiBYGHY9jfAIpoKrW48BmsshrY
         utxKKJNlaoQYRB+z/6tQf+wxXKZyr35fanKX0Dbz2PLkJPGZu6jvFUwLRbDtSMIUFMa3
         lmyzU2F16wHSBcQXIxurhCP49nVtThgeRzyOsexz54Xocxy2UvTMxmzUV4jFSGNTug9Q
         dGM1y/5pi+J2NYxJhxjpIT4KsBMdP7CWGkRrGPF2h0drdjvV+BPvLC+Np8WzDjeYnn6/
         UGtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792260354; x=1792865154; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5WYz1Retd24HUnvvdl9jkRLzPG0/UPeYjwKPSTILvsw=;
        b=g8kSTnoRZyHodSkkpIWM6LivEcot4s/W3L69MI5znKvc7Srp3nwLHfvhsPEfXxpz0C
         lj0tDAQnmPnOrxCJ8jzfLjtU12/P6iL3yNPgqoyLl4+iNuQrBRliINq3FUfTlV8rjXAQ
         CGTkTO3RsMFWknJwc2hZGgfq/xOrIpEudLfmtnafvZPn07Qfi5g2DAs+4PjFG29FHL8G
         b7iyYulzbQ8M2ODlUWSMTcJQHt4MuJbCOoSxn/Gh6huYwfZFAM2zJo1/2mtwwnVGCiti
         vivA1Xq37Zn01VzQZW4wxuGU54spnfICy40SYIlUkmyT7FSZAtzv1wFOIjMBIgNPwX0r
         EtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792260354; x=1792865154;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5WYz1Retd24HUnvvdl9jkRLzPG0/UPeYjwKPSTILvsw=;
        b=JV3+zCGIBeD1rQfMjIvoSAk0IXgXsWCiUnAsaK9Ctbv4qBry8rFjAWn14hV5HpViJN
         sIkiL1qACGsxiBoVrbpl/HfhHhdXeu57NZobinjq4FIQ3PRK7IF0cMoajJFdlw7ti0i4
         JTygiIXu8G8Xbr97lGS0ZHIZjn2c3FOucSTd9AF2ozSCZuzc7/CYE7gVX7jJtLQabFE5
         G9pKyPVj13bQQ8qr5Z0m5zIfvTB46B0aXLPjS8eVJySqvbBGUqjikhOY4LgqzJedpgUd
         Pio7k9I7oxVTBhAD3A14YhG8jdAQGia0s5VqMBKF74tWBcywe8vZJyGYfi+jQLTyuLZr
         FAmQ==
X-Gm-Message-State: AFq9FYIytBOy4iBc3Dpm7hDqhUROzf1sdIeI56XKKZETwweokI6bmbpB
	VcvK+E5Y7h3YnNjdCDdVphiSmi9wWdVDECyE8ySSXO4oOA3yqcSEyLcbNDfBvcoAKftAwNXTxCs
	IqBJ6f3bCqXDmw7ecUIaNTK2ir2iVwlBs2w==
X-Gm-Gg: AYBFou2OUl34s9CJUsNZoiAUo9XeglNDt8Sz/XYyuzkrPMpx3h4s37zKXacYfkCPYIF
	8QfcOfCGKdZsm+Hhd1F2K8CYsGti5AEtr4LqIJbgrusR8GsL6D215HxrS0+PxE9VSp6BLZ8Db9M
	rhawTrZw2Vu9RWvCWvLkKhlZ3wBiL5Mlz3f8DpmiuM2TBr4YD1g+SgjgZeYMgi4+SoezVZKd/m4
	YVPWZZZGpO1Jj58rTPNUd2OL5XXw4qf/Fz7BsBrcO/IGYHc8/IOQLCh6PsJH8KkhYUZ27UKw9bA
	9XbqmCGQl5C2KWZmAeBgkCVoVFs9bK2IKF1mmUXytrftEz4chUA/pw==
X-Received: by 2002:a05:690c:83:b0:8b0:9e81:8ba6 with SMTP id
 00721157ae682-8b0f21ded69mr14678787b3.44.1792260354470; Sat, 17 Oct 2026
 11:05:54 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 14:05:53 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 14:05:53 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzAAWOdVk_E2FVyjS-en+h0oF=YKFqdWZ+VFeU36V4BNBmA@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
 <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com>
 <CAFBxzAAAdx1m_BzvsqG1DKLPanr5cDqvoxhzqkVCdpXLpkt5eA@mail.gmail.com>
 <CAFBxzAC0bjaFaH-i6S0DFFP025o=6V4QVsnBQk92P20XVrvthg@mail.gmail.com>
 <CAFBxzADnkEKuAxDxi58xczg53UC9t4Dw238bJ1SoXra9P9+M7w@mail.gmail.com> <CAFBxzAAWOdVk_E2FVyjS-en+h0oF=YKFqdWZ+VFeU36V4BNBmA@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 14:05:53 -0400
X-Gm-Features: AclHuK9C4aWpc3aReXoESgc2dzAzTEGhprhVLjJ3OCqQHyTPC2mkMoE0XNTAoZo
Message-ID: <CAFBxzADfCPgYD0xsKqCse0Vc1p8Poo-X-r4H1JBp419hgwgmZw@mail.gmail.com>
Subject: [PATCH] btrfs: quick-inherit snapshot-only qgroups through tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Btrfs currently falls back to a full rescan when creating a snapshot
whose inherited qgroup has a parent while the source qgroup has none.
That fallback is expected for the stock Snapper layout. The paired
Snapper change can create a shared tracking qgroup containing the
source and the snapshot-only parent; for that exact topology, the
counters can be derived without a scan.

Extend qgroup_snapshot_quick_inherit() for that case. Keep the
existing same-parent exclusivity check unchanged. For the tracker
case, require that the source has exactly one parent, the
snapshot-only parent has exactly that tracker as its parent, and the
tracker has exactly those two members. Set the snapshot-only parent's
referenced counters from the tracker, retain its exclusive counters
except for the new root node, and use the existing iterator to update
the tracker and its ancestors. Ambiguous hierarchies keep the current
rescan fallback.

This is an optimization for the paired topology, not a fix for
demonstrated counter corruption. A stock Snapper source with no parent
still takes the fallback unless Snapper establishes the tracker.

Testing:
- QEMU on the current Debian kernel release 7.1.13+deb13-amd64 with
Snapper 0.10.6 and 0.13.2: repeated root/home hourly snapshots,
timeline cleanup, compressed and incompressible data, and externally
shared snapshots passed with the candidate module.
- Quota-limit cleanup passed. Comparisons of all four qgroup counters
before and after a full rescan matched.
- In the stock-module control, each snapshot round took the existing
rescan fallback; the paired candidate produced no further
snapshot-triggered scans after tracker setup.
- The patch built against v7.3-rc7. The qgroup.c source is unchanged
between that tag and current upstream master; this build was not a
runtime test on v7.3.

Signed-off-by: R E Broadley <rebroad@gmail.com>
---
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


On Sat, 17 Oct 2026 13:58:47 -0400, R E Broadley <rebroad@gmail.com> wrote:
> Correction to the baseline hierarchy description in my RFC.
>
> I described the shared level-2 tracker as though it were part of the exis=
ting Snapper hierarchy. That was incorrect. Stock Snapper has no shared tra=
cking parent between the live source qgroup and configured snapshot qgroup;=
 the tracker is created by the proposed Snapper `prepareQGroupTracking()` c=
hange.
>
> In QEMU with Snapper 0.10.6 and the stock Btrfs module, three successive =
hourly snapshot rounds each marked qgroups inconsistent and completed a sca=
n. This is the expected conservative fallback for the unparented-source bas=
eline. With the paired Snapper and kernel candidates, repeated snapshot and=
 cleanup runs passed, and a later full rescan left counters unchanged. No c=
ounter corruption has been demonstrated.
>
> I also checked current upstream `master` and Linux 7.2 `fs/btrfs/qgroup.c=
`. Neither has the shared-tracker fast path: an unparented source still tak=
es the rescan path. The proposed optimization therefore does not appear to =
report behavior already fixed in those later sources.
>
> This narrows the RFC to avoiding snapshot-triggered rescans for the exact=
 tracker topology established by the paired Snapper change. Other layouts r=
etain the rescan fallback.
