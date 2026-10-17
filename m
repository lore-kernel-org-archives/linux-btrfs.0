Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60238C421
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792248258; cv=pass; b=OKjICNkp2IzlZlUViP+S/V3dPC/kTiY8p14u3T/cUjgm32AqWCCoMlE74Qk3YFvngztw+0CZS12hDPmYAu2g02h6KKKyNAnJVridfEeamOIfnHGjuRssSqNS2U8vyBqxnKRfdp0nZRyYja7n52a5roLERYDUtxDedFtkXK2jo1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792248258; c=relaxed/simple;
	bh=d+zH1o27lsGi7LwGSV3qurApDYSot4+ZIgyb5ShGrNQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k7J7PXDR56wAUn/qCxWWtEeiaVM2HV1ZwtftmjCp31zV7O7hbxgdSdZmT2D81hus21HlJf/pSg4jDb0p78Z4tvDxrwwOEgDSKAA/ntaXc1ljDr+TaBXU9P3/H3F2Lnu7WEZIY8XDpfMuN7H8ZY3PXXOKGtr95184m8xJsAGcuFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2t3HR6g; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2t3HR6g"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8ab43af5e97so8962287b3.1
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 07:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792248256; cv=none;
        d=google.com; s=arc-20260327;
        b=Pvw+mQA6rXgbvfe4rnfJF7BVgoZiIWIllnx3g38bKrAiJe8KOwDhH1U7XjVzDLPtF8
         dI/qv+3zb5vIVFzl+ZkOC6rh7f/bZUKZIYdg0bO0SiMB3iff474oEisI6IejgTsQV2gK
         Whyslesle8TLkxmus1d+I0c6rkhBRhEeUPrN6adgZiQrjr+B/xRElrzGCBz8ciZRrvVz
         odv16zVyiI7cn5aMtUjStlGCNnJq8KH4jZckfa5JoGsMGN3cXRrkCmUECmFlNOi+G2Ge
         lyjwJEx5zYeR7aNXOyds6QiS5CjFqJfYS+gE8srZqYjRyX43RhCBFJhUi1K/BAOg8eaa
         n7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5HaXDPMoZCxd9+Xr7L5NkEN5bMkWsfBrc+wi/v7R09s=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=Z0HFpQ96TdXlXV181xOOydR/aIQ+zRT2sOnL1zNGTLnTWABI1BF4WbqujjXjcr1WLI
         p2Rl4Q5KbllKgs0epac7ywJV23RlhKyk1kVw+G614O9iyowZ72Tv1fMQiKAIBax3hJCo
         4tWl2r+1SNXmHl/Nnt/sTdfRN4BiR8EP8QF52lVPzgPobIBeZdwBKrsLg2xekgbMZJrr
         CVlY90qpS2PHCZSYS/7IJOVoBtwXzfqSj0y/zwt1OTwciMawCOjDcWCsYJ0hlzCwwVRw
         dExP35bEWCm7NYCEQR2pKFSC9YaKlKAySKtcWyXA2UX0jbaMB+yvrpXgbnx3DKCpegg5
         I6sQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792248256; x=1792853056; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5HaXDPMoZCxd9+Xr7L5NkEN5bMkWsfBrc+wi/v7R09s=;
        b=g2t3HR6gzUmrFxUveiBOJ21LTiDPqvs1a8X4PJQI6zEZvKgN1iW/WPrlHKow81wy3L
         rLQajnbjQEK1BDRwmonlXZKhCUENpf1vE20FObtHWyw4wR8sFuOXyRcMwlqUEjkcr6ke
         9d9Q6C5P52WhTjKAqbo2DS1LplcD+dkaVxBbKMqsujq3OT7NyFM+swfLiizfnmNVLN9l
         e0HjptWsR9zIc9mWCEl4cljB4nLbpep7UMKRowaLBdwjA9q5mAhKwQvEEnzcXj/i63wD
         +eRLSLTjFMWT1me7mC2EluEr6Ddv5NjdYGBiAKsQTQ/obrCEJZs0sBiWqDYDTRUV8NRo
         y2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792248256; x=1792853056;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5HaXDPMoZCxd9+Xr7L5NkEN5bMkWsfBrc+wi/v7R09s=;
        b=aveO7oqr+ceWEQhMuaRSqaQ7qT9OMqC2zXHAVo3LpH+IaHl3StvTtjeVB16uWTi/qr
         Q+mCJ+5znjKHWTl177rolI3lu1hdTdOQ6ZhnU0/zY91tpbfcRNSVgAe9426rO27eSIVj
         8w0qhfA2/PyDy3NpEy36le4FpvGUgKJW+JuO6I9fnsBosyR2C5AK8uizTD86qQeYBtFL
         99yYnaaLIXg9EEFxthBZrCD2qq5d+f06G9pkEjmHY1i1zOEEDH4FkWctJ22tKX+kpYps
         ppNm2dVsXSwhNPIFKiH9n6jOQscynURVbR7ye1xGbVeHEyB8FNfBiAHdEM7exAKgU2Oa
         cuAA==
X-Gm-Message-State: AFq9FYJ330q3t3QfHypiu2bP0PkxGg2nY4uGG1eUH1aLZuz1ojXEZtt6
	5PI5WG/Sp1tn9mQQJCdoh9PssIR0i1aAaKX1Zx+YRSz5Y/6nqcICLWX2HqbJEC8O9r8SA671zvd
	5wYMq9/cmqK7W3vQQOfQQ6myHhcZitYnwzQ==
X-Gm-Gg: AYBFou2ZrFPNObBD9GQs4viWdySLpDzMezW5UY/a8tm3jhfRttU+9NML1RD7+RO0IOD
	9mvm/s0hOI0oM1Er7KR56KbftfkeyZD6zkZYwQ6trQYs/ydQTkYwvCZiTrhHbGfW7NcFJPCY/O+
	CHdSZ97XhP20UN3yQMvPsweiG8Ju9uygLf/MSFGV+VQfXG/KuVy6YFcXKBBbzocvAKiJsm+Y8GQ
	m06Vz4driJlzzghdf0X2qbWu3Q2lfFySrTWxU6+kheT4nYZy/hrnYNollKsGfLgaFcodIL8RQzK
	xU1q3RA0JphrfXzuS03UGHlGl7+57DfUfHHCxubw6lcSESUTO6Jo3g==
X-Received: by 2002:a05:690c:19:b0:8b0:bc8e:9d75 with SMTP id
 00721157ae682-8b0f215aa85mr11038427b3.22.1792248256270; Sat, 17 Oct 2026
 07:44:16 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 10:44:15 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 10:44:15 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 10:44:15 -0400
X-Gm-Features: AclHuK9LLMwKpi6tFv6W53ij4FJ78HmWpG_j63xxwMm2qh_L3tYmS-BQmsohx2A
Message-ID: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
Subject: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"

Hello,

I could not find an upstream report for this specific qgroup
hierarchy. There is a related quick-inherit optimization for snapshots
assigned to the same exclusive parent (linux-btrfs, 2024), and
mainline now has fixes for full-vs-simple quota handling and updating
ancestor qgroups. This report concerns a different layout.

With full qgroups, Snapper's snapshot-only quota group does not
contain the live source subvolume. The source and the new
snapshot-only qgroup instead share a level-2 tracking parent. The
tracker has exactly those two children, and the snapshot-only qgroup
has exactly that one parent. On Debian's 7.1.13+deb13-amd64 Btrfs
module, snapshot inheritance for this layout takes the conservative
"qgroup inherit needs a rescan" path. The rescan completes and
accounting matches a subsequent full rescan; I have not found evidence
of incorrect accounting in the stock kernel.

A candidate quick-inherit extension is included below for discussion.
It is limited to full qgroups and the exact two-child topology above.
It derives the snapshot qgroup's referenced counters from the tracker,
preserves its snapshot-only exclusive counters except for the new root
node, and uses the existing iterator to update the tracker and its
ancestors. All other layouts retain the rescan fallback.

Evidence so far:
- A QEMU control using the same Debian kernel image, Snapper 0.10.6
and the stock Btrfs module logged "qgroup inherit needs a rescan" and
performed one recovery scan.
- With the candidate Btrfs module and the same source-only tracker
workflow, tracker repair plus snapshot creation did not start a scan
or mark qgroups inconsistent.
- Repeated two-config snapshots and timeline cleanup passed with
compressed data and externally shared snapshots on the candidate
kernel; a later explicit full-rescan comparison left counters
unchanged.
- The QEMU behavior tests were run on 7.1.13. I verified that the
attached diff applies cleanly to current upstream v7.3-rc7, but have
not built or run the tests on that version. Quota-limit enforcement
coverage is also still outstanding.

The stock kernel's fallback appears conservative and correct. The
proposed change is an optimization to avoid repeated rescans while
preserving the snapshot-only quota scope, not a fix for demonstrated
counter corruption. Please review whether the tracker conditions and
counter derivation are sufficient, and whether this belongs as a
kernel quick-inherit optimization. I will send a formal patch revision
after review and the remaining quota-limit coverage.

This is an RFC discussion; the diff has no Signed-off-by line.

---
Candidate diff against upstream/master:

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f68b696b4bf7..300607c10a6a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3263,9 +3263,10 @@ static int qgroup_auto_inherit(struct
btrfs_fs_info *fs_info,
 }

 /*
- * Check if we can skip rescan when inheriting qgroups.  If @src has a single
- * @parent, and that @parent is owning all its bytes exclusively, we can skip
- * the full rescan, by just adding nodesize to the @parent's excl/rfer.
+ * Check if we can skip rescan when inheriting qgroups.  This is possible when
+ * the source already belongs to the target parent, or when a tracking parent
+ * contains only the source and target parent and lets us derive the target's
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
 	const u32 nodesize = fs_info->nodesize;
+	u64 new_excl;
+	u64 new_excl_cmpr;
 	int nr_parents = 0;
+	int nr_members = 0;
+	bool tracker_has_src = false;
+	bool tracker_has_parent = false;

 	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_FULL)
 		return 0;
@@ -3299,27 +3306,67 @@ static int
qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 	if (list_empty(&src->groups))
 		return 1;

-	list_for_each_entry(list, &src->groups, next_group) {
-		/* The parent is not the same, quick update is not possible. */
-		if (list->group->qgroupid != parentid)
-			return 1;
+	list_for_each_entry(list, &src->groups, next_group)
 		nr_parents++;
+	if (nr_parents != 1)
+		return 1;
+	tracker = list_first_entry(&src->groups, struct btrfs_qgroup_list,
+				   next_group)->group;
+
+	if (tracker == parent) {
 		/*
-		 * More than one parent qgroup, we can't be sure about accounting
-		 * consistency.
+		 * The parent already contains the source.  The snapshot only adds
+		 * its new root node to the parent, even when some source extents
+		 * are also referenced outside the parent.
 		 */
-		if (nr_parents > 1)
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
+				     next_group)->group != tracker)
 			return 1;
-	}

-	/*
-	 * The parent is not exclusively owning all its bytes.  We're not sure
-	 * if the source has any bytes not fully owned by the parent.
-	 */
-	if (parent->excl != parent->rfer)
-		return 1;
+		list_for_each_entry(list, &tracker->members, next_member) {
+			nr_members++;
+			if (list->member == src)
+				tracker_has_src = true;
+			else if (list->member == parent)
+				tracker_has_parent = true;
+			else
+				return 1;
+		}
+		if (nr_members != 2 || !tracker_has_src || !tracker_has_parent ||
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
+		new_excl = parent->excl + nodesize;
+		new_excl_cmpr = parent->excl_cmpr + nodesize;
+		parent->rfer = tracker->rfer;
+		parent->rfer_cmpr = tracker->rfer_cmpr;
+		parent->excl = new_excl;
+		parent->excl_cmpr = new_excl_cmpr;
+		qgroup_dirty(fs_info, parent);
+		qgroup_iterator_add(&qgroup_list, tracker);
+	}

-	qgroup_iterator_add(&qgroup_list, parent);
 	list_for_each_entry(qgroup, &qgroup_list, iterator) {
 		qgroup->rfer += nodesize;
 		qgroup->rfer_cmpr += nodesize;
