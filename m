Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2AF38654F
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254526; cv=pass; b=Ei7mKM/o1ScvKGrU/0WgH1xE5qAvSNnHSK3ONuCTwTXzL9kggxVAA+m/5APnP36SaZd+Ev+bKZxs6WVuuiiCuwZ1dfhVym1S/RSdk3+pvBDAEYCbUdFSb7Nbf3IcB6A1q/IVtOGIZxMCvKFnnbAmevnu6Eq1/aeHgRvUf9Lw6jw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254526; c=relaxed/simple;
	bh=FsETVhKJGMdH1/tKbs6PPtqAFVE+vQ1843viIALUabA=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bnsQndaZSYPgnaLhKqo9134CZN1ZOkl2Ye6+godykDiNHN2RR6mzsFRc6i/WvRjApxwh3xN3vBCd6gxy2mo+krt36fIC0YpEBDbBhoIxLf6eg+2tnD7KuIl5x6pIucgrdpvr8lufKYNVSPXnzZ1P0tV3wi7ETCT4SUJkwcSk11k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qwhXoBAx; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qwhXoBAx"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6756a01fa01so825967d50.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 09:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792254523; cv=none;
        d=google.com; s=arc-20260327;
        b=BV/LJ1c8oOui0TbMMgEeRGIAtdWwhhddFoP46pdqreWdVTx+mqLg6v855Zqu8YaABQ
         Qulxmp166AC28S1FwOCiv7gPVbPPm7CdwqtXpuJ8vlmQpDpfLl6BswLihdLwrxoJDsHB
         H1Cy6jO5dSloiPWXx5utBBwW0GK8yDibSxQSRwALQaZy2bpAAKREJQEhfGnybHqodKcN
         X1BBwWMb5uBzhU6aOrXDAo/bMdjUZm3+lJf1RxiyGwg3dyNWoG/VJIL0BtLSAzBOpSLe
         e5OZkq1RgpSAWRZb5qADLVb7M4xbjIj8XQbvSHtVmz78Mv5Q6CEp/C6pmdFlnOoprH2d
         YVBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=EvUd83PacNb8FgiartcIq9r6joTHxjRCPwAo9VIaZJY=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=qIj2s/+Y8/L+PRSHYh7DAKfRMv2sMDb6JXUiYNFDaZpHx5QO4c9GOIx977cAAhj8y9
         pfSlGHGp+hLvJqJhczrHuzYRfrdFeHUGFOWzhaFHlCciY9ur4TPOO2dEcDwspR3GgDsJ
         7hFXSeC2aGH4E1dol6SqpQ7p7KmjfEQkdPK6Fbk1abwMDY7G0+JA1wx98NVDrwJw2vxF
         78p3jX2SzbsNpgS/JuFaIy99AaDocO/8lLQDzxqlzIFWccQcedOFqhasOyX9s/gyBCzM
         vi2da3RcabG//b5BRTR17kp4XyyxweVIcWF/3NofqbQgcO+aYSQd2QKl9o76KJoxA6ad
         +mvg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792254523; x=1792859323; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EvUd83PacNb8FgiartcIq9r6joTHxjRCPwAo9VIaZJY=;
        b=qwhXoBAxa9gP5QCMrLDJh+o0GkcyimigIHzeLcSV/0ttd1UUsjEY9YhUqlJKgu9oNR
         g8a7hFTztxtUq8IvZKtkGsvataxV9PYzcJ4b1FDjKUh1hmQq2WBXFnkuglj/kTL7/lq1
         ur2PnG8Oc97DtSox9rvqBZe6zc39KPB+hrFWBUlbnqzkjIMLAtdI19u9JbxXcASO/H9Q
         B2hmh92Xd8j6arvfh9qQBuDAfQ1HlMJFmlAu0s9shdfnPoKG6lBmwIifRcuxD/2A6TXU
         vTYLATwE9hozjs5NymMcg3q4ugC4H+MnDQEgU0Zwjel4r20O7vr6QTCpWSAfpYrV91/Y
         PVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792254523; x=1792859323;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EvUd83PacNb8FgiartcIq9r6joTHxjRCPwAo9VIaZJY=;
        b=LmFkj19qLScFvJottA9dMxhTMnwDXKFBhxb5Y5F95Tcpen5QK/O4jFZg3oQH+/m0sG
         c591uiaT6xRVu3MTtX4m5o6KQwDVvIUh+6QM9WdOU+WghjGlJzD+/XyIgH56q3nWw5AU
         jQ+KfUslq4nAHRQncFmzNGb6duTDKCf2+CVgZxqmsKnFhTjo3zrdqhkoS1jjLnzy3reF
         /NEKxXutuzFzR7tGrufQBjy8ovs/SLE0g26y1GDzoMFUvh95Wp52ZiwdFBkUeLGvxVlr
         oh9acp8wlSBOwCNj38pFm9IkYxC0QaQWWX6wTRpzGaga0fipMh7t6ej1GQDkaCViOaWS
         xqpg==
X-Gm-Message-State: AFq9FYJ4zc2FuPip/aAyKBB6JMJFnSOuVGNRNbzlN1eN9mr4F2UqwS/g
	wCInV2QYtojrq+or2/RPVWnuLConXcFn7+5RLYGdfPkLi/T4cDY0asPiypv3NOpYScT754/T4Co
	mhBTNbp3G0em4tzgcxqFXnhCkytaaeinsmA==
X-Gm-Gg: AYBFou02NkxgIBeO4zepm0PLhCxZTVB1ArC4UgEwajrExqLkWVkoTKI6758367TaWu3
	reYUrCT/MbPQ/BhGdfdJduZaNo8iWidoF8RoL1ZR+nOU/vfeAPOEARRckMsDDlmaLkME2D/1RQR
	M9/kacibXa8bgTIq7wmQHI35tNMtlt5/QyT1P7JM8OnWVxp4LFR6jVgJuvXy7gH/cnDQ4g5OFd1
	px4/o7XtwyuQyZmIeip4aMtxSpXzHWnmHaxk+JE0IjcA1LLR/8ODsa+tpFV4Xzddw8Q2xcdImZO
	2VMCcN7huAMp3pAPKlhTIffg1P+ukQfM9uYMMGF7anjQCEgDnXR55A==
X-Received: by 2002:a05:690c:a599:b0:8b0:e595:8cc1 with SMTP id
 00721157ae682-8b0f2211ef5mr8703567b3.58.1792254522872; Sat, 17 Oct 2026
 09:28:42 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 12:28:42 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 12:28:42 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzAC0bjaFaH-i6S0DFFP025o=6V4QVsnBQk92P20XVrvthg@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
 <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com>
 <CAFBxzAAAdx1m_BzvsqG1DKLPanr5cDqvoxhzqkVCdpXLpkt5eA@mail.gmail.com> <CAFBxzAC0bjaFaH-i6S0DFFP025o=6V4QVsnBQk92P20XVrvthg@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 12:28:42 -0400
X-Gm-Features: AclHuK8MevyvjISAsA-XzovEgYaz6aYM_aBFTNf71juNoeQWQFGMaQvZdphfSow
Message-ID: <CAFBxzADnkEKuAxDxi58xczg53UC9t4Dw238bJ1SoXra9P9+M7w@mail.gmail.com>
Subject: Re: [RFC] btrfs: quick-inherit snapshot-only qgroups through a shared tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Additional exact-candidate quota-limit coverage is now complete.

I used the current Debian Snapper 0.10.6 executable and library with
the narrowed Btrfs module for 7.1.13+deb13-amd64 (the same module hash
reported in my previous follow-up) on a fresh QEMU filesystem. The
corrected guest clock helper stepped through hourly times. With
SPACE_LIMIT=3D1 MiB, quota-aware timeline cleanup reduced each config
from four snapshots to one and exclusive usage from 6,750,208 bytes to
16,384 bytes. The test asserted that the hourly snapshots and cleanup
caused no additional qgroup scans or inconsistency warnings. An
explicit full rescan after cleanup left the counters unchanged. The
integration test passed.

This closes the quota-limit enforcement gate for the tested Debian
Snapper and narrowed kernel candidate. It does not establish runtime
behavior on upstream kernels; the v7.2.11 and v7.3-rc7 builds remain
isolated compile/link checks with modpost warnings due to missing
full-kernel symbol tables. The RFC remains a rescan-avoidance
optimization proposal, not a report of demonstrated counter
corruption.

On Sat, 17 Oct 2026 12:21:33 -0400, R E Broadley <rebroad@gmail.com> wrote:
> Upstream compatibility update for the RFC.
>
> The v7.3-rc7 qgroup helper already has the two-argument interface, so the=
 earlier Debian-based diff did not apply verbatim. I forward-ported only th=
e helper logic to the v7.3-rc7 source (tag commit 24a19b953e2a3d0ea5a8c4951=
a0ab8f32720c907). The resulting diff applies cleanly to that tag and change=
s only fs/btrfs/qgroup.c.
>
> The Btrfs module target compiled and linked to btrfs.ko with KBUILD_MODPO=
ST_WARN=3D1. This isolated build tree has neither vmlinux nor Module.symver=
s, so modpost reported 636 unresolved kernel symbols and BTF generation was=
 skipped. This verifies compilation of the forward-ported source but does n=
ot make the module suitable for loading or establish runtime behavior on v7=
.3-rc7. Runtime QEMU coverage remains on the in-use Debian 7.1.13+deb13-amd=
64 kernel, where the narrowed module passed the current Snapper 0.10.6 reco=
very/hourly/cleanup workload.
>
> The RFC remains open for review. I have not treated this limited module b=
uild as a complete upstream build or runtime test.
>
> --- v7.3-rc7 candidate diff ---
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index f68b696b4bf7..496f6cee6757 100644
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
> @@ -3299,27 +3306,70 @@ static int qgroup_snapshot_quick_inherit(struct b=
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
> +		 * its new root node to the parent. Keep the existing exclusivity
> +		 * check for this case; the tracking-parent optimization below is
> +		 * separate and does not change this path.
>  		 */
> -		if (nr_parents > 1)
> +		if (parent->excl !=3D parent->rfer)
> +			return 1;
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
>
>
> On Sat, 17 Oct 2026 12:08:56 -0400, R E Broadley <rebroad@gmail.com> wrot=
e:
> > Additional exact-version QEMU validation is now complete.
> >
> > I rebuilt the initrd from the current Debian Snapper 0.10.6 branch (com=
mit 46fcfbea) and the narrowed Btrfs module for the running kernel release =
string 7.1.13+deb13-amd64 (kernel change f06fc2e5; packaged module SHA-256 =
de0ef9b7a9b0b0ee609fbbae2e234ba940bfcb70f94d4fc903bc48b370059b96). The Snap=
per executable and shared library in the guest matched the current build ou=
tputs.
> >
> > On a fresh Btrfs filesystem, the workload prepared the interrupted stat=
e with only the configured snapshot qgroup attached to the tracker. The nex=
t snapshot repaired the tracker and completed the required scan. Successive=
 hourly snapshots and timeline cleanup then completed without qgroup incons=
istency warnings or additional scans. A full rescan after cleanup left the =
qgroup counters unchanged. The test finished with SNAPPER-0106-INTEGRATION:=
 PASS.
> >
> > This adds recovery coverage for the current Debian Snapper candidate al=
ongside the earlier real-hour and quota-cleanup results. It does not change=
 the conclusion that the stock kernel's fallback is conservative and that t=
he kernel patch avoids a demonstrated recurring scan for the tested topolog=
y; no counter corruption has been demonstrated. The upstream-version kernel=
 build and review remain open.
> >
> > On Sat, 17 Oct 2026 11:45:13 -0400, R E Broadley <rebroad@gmail.com> wr=
ote:
> > > Scope correction to the RFC candidate before any formal patch submiss=
ion.
> > >
> > > The earlier candidate also relaxed the existing fast path for the unr=
elated case where the source already has the target qgroup as its parent. I=
 have restored the previous guard there: if parent->excl !=3D parent->rfer,=
 that case still requests a rescan. The new optimization is limited to the =
separate tracker case (source's sole parent is the tracker; target qgroup's=
 sole parent is that tracker; tracker has exactly source and target as memb=
ers). Other layouts retain their prior fallback behavior.
> > >
> > > I rebuilt the narrowed module for the currently used Debian 7.1.13+de=
b13-amd64 kernel and reran the corrected real-hour QEMU workloads. Snapper =
0.10.6 and 0.13.2 both pass 01:00-04:00 snapshot rounds, quota-aware cleanu=
p, and full-rescan counter comparison with the narrowed candidate. I also t=
ested the preserved same-parent boundary using an outside snapshot that sha=
res extents: qgroup 1/100 had referenced=3D8,404,992 and exclusive=3D16,384=
; creating an inherited snapshot emitted "qgroup inherit needs a rescan", c=
ompleted one scan, and a subsequent full rescan left counters unchanged.
> > >
> > > The exact narrowed source change is pushed at https://github.com/rebr=
oad/linux/commit/f06fc2e5cdc8. The patch remains an optimization for avoidi=
ng repeated scans in the proven tracker hierarchy; I still have no evidence=
 that stock accounting is incorrect. The upstream v7.3-rc7 build and mainta=
iner review remain open.
> > >
> > > On Sat, 17 Oct 2026 10:44:15 -0400, R E Broadley <rebroad@gmail.com> =
wrote:
> > > > Hello,
> > > >
> > > > I could not find an upstream report for this specific qgroup hierar=
chy. There is a related quick-inherit optimization for snapshots assigned t=
o the same exclusive parent (linux-btrfs, 2024), and mainline now has fixes=
 for full-vs-simple quota handling and updating ancestor qgroups. This repo=
rt concerns a different layout.
> > > >
> > > > With full qgroups, Snapper's snapshot-only quota group does not con=
tain the live source subvolume. The source and the new snapshot-only qgroup=
 instead share a level-2 tracking parent. The tracker has exactly those two=
 children, and the snapshot-only qgroup has exactly that one parent. On Deb=
ian's 7.1.13+deb13-amd64 Btrfs module, snapshot inheritance for this layout=
 takes the conservative "qgroup inherit needs a rescan" path. The rescan co=
mpletes and accounting matches a subsequent full rescan; I have not found e=
vidence of incorrect accounting in the stock kernel.
> > > >
> > > > A candidate quick-inherit extension is included below for discussio=
n. It is limited to full qgroups and the exact two-child topology above. It=
 derives the snapshot qgroup's referenced counters from the tracker, preser=
ves its snapshot-only exclusive counters except for the new root node, and =
uses the existing iterator to update the tracker and its ancestors. All oth=
er layouts retain the rescan fallback.
> > > >
> > > > Evidence so far:
> > > > - A QEMU control using the same Debian kernel image, Snapper 0.10.6=
 and the stock Btrfs module logged "qgroup inherit needs a rescan" and perf=
ormed one recovery scan.
> > > > - With the candidate Btrfs module and the same source-only tracker =
workflow, tracker repair plus snapshot creation did not start a scan or mar=
k qgroups inconsistent.
> > > > - Repeated two-config snapshots and timeline cleanup passed with co=
mpressed data and externally shared snapshots on the candidate kernel; a la=
ter explicit full-rescan comparison left counters unchanged.
> > > > - The QEMU behavior tests were run on 7.1.13. I verified that the a=
ttached diff applies cleanly to current upstream v7.3-rc7, but have not bui=
lt or run the tests on that version. Quota-limit enforcement coverage is al=
so still outstanding.
> > > >
> > > > The stock kernel's fallback appears conservative and correct. The p=
roposed change is an optimization to avoid repeated rescans while preservin=
g the snapshot-only quota scope, not a fix for demonstrated counter corrupt=
ion. Please review whether the tracker conditions and counter derivation ar=
e sufficient, and whether this belongs as a kernel quick-inherit optimizati=
on. I will send a formal patch revision after review and the remaining quot=
a-limit coverage.
> > > >
> > > > This is an RFC discussion; the diff has no Signed-off-by line.
> > > >
> > > > ---
> > > > Candidate diff against upstream/master:
> > > >
> > > > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > > > index f68b696b4bf7..300607c10a6a 100644
> > > > --- a/fs/btrfs/qgroup.c
> > > > +++ b/fs/btrfs/qgroup.c
> > > > @@ -3263,9 +3263,10 @@ static int qgroup_auto_inherit(struct btrfs_=
fs_info *fs_info,
> > > >  }
> > > >
> > > >  /*
> > > > - * Check if we can skip rescan when inheriting qgroups.  If @src h=
as a single
> > > > - * @parent, and that @parent is owning all its bytes exclusively, =
we can skip
> > > > - * the full rescan, by just adding nodesize to the @parent's excl/=
rfer.
> > > > + * Check if we can skip rescan when inheriting qgroups.  This is p=
ossible when
> > > > + * the source already belongs to the target parent, or when a trac=
king parent
> > > > + * contains only the source and target parent and lets us derive t=
he target's
> > > > + * counters exactly.
> > > >   *
> > > >   * Return <0 for fatal errors (like srcid/parentid has no qgroup).
> > > >   * Return 0 if a quick inherit is done.
> > > > @@ -3276,11 +3277,17 @@ static int qgroup_snapshot_quick_inherit(st=
ruct btrfs_fs_info *fs_info,
> > > >  {
> > > >  	struct btrfs_qgroup *src;
> > > >  	struct btrfs_qgroup *parent;
> > > > +	struct btrfs_qgroup *tracker;
> > > >  	struct btrfs_qgroup *qgroup;
> > > >  	struct btrfs_qgroup_list *list;
> > > >  	LIST_HEAD(qgroup_list);
> > > >  	const u32 nodesize =3D fs_info->nodesize;
> > > > +	u64 new_excl;
> > > > +	u64 new_excl_cmpr;
> > > >  	int nr_parents =3D 0;
> > > > +	int nr_members =3D 0;
> > > > +	bool tracker_has_src =3D false;
> > > > +	bool tracker_has_parent =3D false;
> > > >
> > > >  	if (btrfs_qgroup_mode(fs_info) !=3D BTRFS_QGROUP_MODE_FULL)
> > > >  		return 0;
> > > > @@ -3299,27 +3306,67 @@ static int qgroup_snapshot_quick_inherit(st=
ruct btrfs_fs_info *fs_info,
> > > >  	if (list_empty(&src->groups))
> > > >  		return 1;
> > > >
> > > > -	list_for_each_entry(list, &src->groups, next_group) {
> > > > -		/* The parent is not the same, quick update is not possible. */
> > > > -		if (list->group->qgroupid !=3D parentid)
> > > > -			return 1;
> > > > +	list_for_each_entry(list, &src->groups, next_group)
> > > >  		nr_parents++;
> > > > +	if (nr_parents !=3D 1)
> > > > +		return 1;
> > > > +	tracker =3D list_first_entry(&src->groups, struct btrfs_qgroup_li=
st,
> > > > +				   next_group)->group;
> > > > +
> > > > +	if (tracker =3D=3D parent) {
> > > >  		/*
> > > > -		 * More than one parent qgroup, we can't be sure about accountin=
g
> > > > -		 * consistency.
> > > > +		 * The parent already contains the source.  The snapshot only ad=
ds
> > > > +		 * its new root node to the parent, even when some source extent=
s
> > > > +		 * are also referenced outside the parent.
> > > >  		 */
> > > > -		if (nr_parents > 1)
> > > > +		qgroup_iterator_add(&qgroup_list, parent);
> > > > +	} else {
> > > > +		/*
> > > > +		 * A tracking qgroup can account for a snapshot-only parent when=
 it
> > > > +		 * contains exactly that parent and the source.  Before the snap=
shot,
> > > > +		 * the union of those groups is the same set of extents as the
> > > > +		 * snapshot parent will contain afterwards, except that the sour=
ce
> > > > +		 * root is replaced by the new snapshot root.  The source's excl=
usive
> > > > +		 * extents are the part of the tracker that must not be charged =
to
> > > > +		 * the snapshot-only parent.
> > > > +		 */
> > > > +		if (!list_is_singular(&parent->groups) ||
> > > > +		    list_first_entry(&parent->groups, struct btrfs_qgroup_list,
> > > > +				     next_group)->group !=3D tracker)
> > > >  			return 1;
> > > > -	}
> > > >
> > > > -	/*
> > > > -	 * The parent is not exclusively owning all its bytes.  We're not=
 sure
> > > > -	 * if the source has any bytes not fully owned by the parent.
> > > > -	 */
> > > > -	if (parent->excl !=3D parent->rfer)
> > > > -		return 1;
> > > > +		list_for_each_entry(list, &tracker->members, next_member) {
> > > > +			nr_members++;
> > > > +			if (list->member =3D=3D src)
> > > > +				tracker_has_src =3D true;
> > > > +			else if (list->member =3D=3D parent)
> > > > +				tracker_has_parent =3D true;
> > > > +			else
> > > > +				return 1;
> > > > +		}
> > > > +		if (nr_members !=3D 2 || !tracker_has_src || !tracker_has_parent=
 ||
> > > > +		    tracker->rfer > U64_MAX - nodesize ||
> > > > +		    tracker->rfer_cmpr > U64_MAX - nodesize ||
> > > > +		    parent->excl > U64_MAX - nodesize ||
> > > > +		    parent->excl_cmpr > U64_MAX - nodesize)
> > > > +			return 1;
> > > > +
> > > > +		/*
> > > > +		 * The source remains outside the snapshot-only parent after the
> > > > +		 * snapshot is created.  Its data is therefore not exclusive to =
the
> > > > +		 * snapshot parent, including extents already shared with snapsh=
ots.
> > > > +		 * Keep the existing exclusive count and add only the new root n=
ode.
> > > > +		 */
> > > > +		new_excl =3D parent->excl + nodesize;
> > > > +		new_excl_cmpr =3D parent->excl_cmpr + nodesize;
> > > > +		parent->rfer =3D tracker->rfer;
> > > > +		parent->rfer_cmpr =3D tracker->rfer_cmpr;
> > > > +		parent->excl =3D new_excl;
> > > > +		parent->excl_cmpr =3D new_excl_cmpr;
> > > > +		qgroup_dirty(fs_info, parent);
> > > > +		qgroup_iterator_add(&qgroup_list, tracker);
> > > > +	}
> > > >
> > > > -	qgroup_iterator_add(&qgroup_list, parent);
> > > >  	list_for_each_entry(qgroup, &qgroup_list, iterator) {
> > > >  		qgroup->rfer +=3D nodesize;
> > > >  		qgroup->rfer_cmpr +=3D nodesize;
