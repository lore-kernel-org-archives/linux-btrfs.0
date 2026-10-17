Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D083909BC
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260702; cv=pass; b=KKgtl+x3+Dlsh9k4h12d49S9VO0FjwzhsTtwk6u589xlvcDFevRZXypbLSGzTJ+UroMQxRL6q6pbOYQ8valS7UL4/qjsh3j/QdAVWIhRjvQ0s5kofMR/chvfvoU+PGnNQPXzjr/CubSawR1k4KW36To65MbRYheS8JcRpYHjoUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260702; c=relaxed/simple;
	bh=//yM4NvVL0m0W4yZF0KsPWW7Mu8CP92oLTyvOlChMAI=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5UcNH1jYVdehkqb/advtLVzXGoPGWu8P7MMzy85JkM1DrzukEgN3AbDdi4bV9vfe5bWgFQ3rJCaFHTabznj7cxfGQj2G0321bXlanm7VZNBDcNwYmZxxfb6dJih/rzJ7+JjHKJlcsRG0fHnv25vF3TX3iIR2g0kJPQRUdlL8To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CmPR4j/K; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CmPR4j/K"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b0f59a5fdeso4262517b3.1
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 11:11:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792260700; cv=none;
        d=google.com; s=arc-20260327;
        b=Iwt1ioSaeEy1WqS0ajWL8mQXv1rBPDHdT48iTxUmdXfEraShYbdDZSNlmCQri5zPRu
         C8qegxcX/T6pyoa58+0LWNYRmSJ8UNaN/37hxnTQBvbK3sPcUA+eCcJLXF8XLku+JuMM
         X4EHCAf5HFopr0ylrLINaufz10DCzLFUWOpxBKZtF51SkL4bkhc2eH3jn5FyAzuc8A0j
         1qjm4udSR/43U2gZkIiYHCGb3fx1pmUbyyYw0Qu7Q1sVFrX9rHelkF8xeCJo+4Tzd79n
         qu+BJRiyIqONLhg6ElykLz0spGQXLSB9HudzUHEmA0gXZKvgL+lrgnaDp2C4UK/jt9ZI
         42rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=Ucvi0VMpUlfu+hOXQPWi/CAv0ok5FDFx82GY0KWykq4=;
        fh=fGJJ3Neh1I78eVfcrA1sNu01TO166JCYyCP48WGIdIU=;
        b=TfnmHGZlBibcvn79NbusZwhGW+XhWbdk+16Onwq89NRnYTKogymKB8/8YwawnIrJo9
         1EnOiIgas/u5ldS4o3tPP187cKyHk47RqTH8PsAvmd7VEAK8ka2LvUZjH/5Hbhq8z0hJ
         W7u4sOVAiiML5CESIT+v3AsOUBWNHno5UimF5PX/XD2Uc6t5Qth7DcVynBGi0/no4jVP
         0wgQ9zuBmyb3rkkmgASxAm268Zwxn6ZCWR+CI4JuEgL84iBBX1dO62Y9/afWUSUz+Iuo
         QGvNutGrbH+Ry0aKv/9TuMrSVKVuRIcRxSqvg+6EG7KTuSDxztzSidI363zbRAIWsQbC
         14KA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792260700; x=1792865500; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ucvi0VMpUlfu+hOXQPWi/CAv0ok5FDFx82GY0KWykq4=;
        b=CmPR4j/KLmNi24BJrGjwoWUm3eMW0GgIBsrJLNnPSeZzNm1IbnnGM6q2mJSEu2XVzH
         RX6/Y9LcZn8CJ3Yubdzh1Xng6kniTXU2Q/XibbGf9XnKkoo/V/ehDK10lQi2u4gpEtC/
         G6vnGV8FCFilJDk4Eq2LJnF4COpVv3sUrZmHOgB31NA14DsBl6S3bf03tNJejTiRFjwV
         XzIUrlObtOj/31LwIvduF3r7KEgRRbTW7J9qJ6lxCLFQhjuppYZ3SUCe7d+Em4obvXa/
         KTYe34LC6wu1vS6kRfU33JqB/LzEDSC1+oTrT/aLAY13kmlVroD6opE9iqjrRFdwcM8r
         4xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792260700; x=1792865500;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ucvi0VMpUlfu+hOXQPWi/CAv0ok5FDFx82GY0KWykq4=;
        b=jY2WzB94oEZifsBzQWkk0wTFd5ItGZqi4kbqRz+SUiUVf19VWRP6nQMwdM/yV9kVZ+
         y5ZmlmDvkf4/GC2SYvRIlusvu8yf5KnuNyKzwlU7GCYdVFDIMuoZIM2mjtyGHDKFkUgF
         ZXr7P89b1rxBNAPATs1soPiADrgJNj7I4ODOehqaeiXYWO9QBR2+cTvo2KLOnfxqPMwk
         r07ixf+nowevXTShIR6UyhtDmiWtNxCHKhY1vIPU7goojZTqU3jA9FDyob/26X8tY1ve
         ziMMJPlCff2C9NS4cnYCRQy568mjKRDJAP7ame1TFcoJY37V2qvR4FxmehI688oAVA0i
         iRzA==
X-Gm-Message-State: AFq9FYJqVRSDEUwk/a2Vtbmem3mPhzMrWPshUWyrkGBd+J4rmUIpsKqe
	ENmGQYxD2ZGruywsUKSp28/VBizXYp+YWbkobWgv+PY6EKdC2gK8+rvIzVTiQBwWGd4yfIfSrZw
	hh0pAV19+KV2HSto2NXEx8S4LHR9x+BE+1A==
X-Gm-Gg: AYBFou0KQOASaaSKHnaKTq/OkAMW60gPSgPt7FxAn01NmNfxE1c1/9jpUgcEuz3giZ/
	vMFt/gYZ+zVlbd0EwpBxXNkooWCZOFxRu2JoR4XeU8oElS4Ks7iMpUgU28RyC0cTlkZScnvRA9R
	FvXrLIHrVagBIXS5YPhywCE+jcWpouyy2pwgR2XsOOvbuEmZ16IfdNS6EwoMXPmf7WGst31F1Um
	GZiaATeVq9XNgUi2owdf3zJz12UEmDiRt4kUDudm8NnRa920IF+VQIcflCFCttDep5zYIDNOQ3B
	wejPIQvvNQejw9zt8g5KaXgL05Y+AqW6r3/uhwuxBfvdVJwyIJopcomlfJpcjP8+
X-Received: by 2002:a05:690c:e652:20b0:882:b4b2:c49 with SMTP id
 00721157ae682-8b0f219b8d3mr9913847b3.18.1792260699847; Sat, 17 Oct 2026
 11:11:39 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 14:11:39 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 14:11:39 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAFBxzADfCPgYD0xsKqCse0Vc1p8Poo-X-r4H1JBp419hgwgmZw@mail.gmail.com>
References: <CAFBxzABSqgexZT5knr974bWU4g80OHvcQEmKMsZHnDmh1ifm4A@mail.gmail.com>
 <CAFBxzADfBSaOVM+gny086a_A0vhoGDB=mHkJKLkaqsUu=KbELg@mail.gmail.com>
 <CAFBxzAAAdx1m_BzvsqG1DKLPanr5cDqvoxhzqkVCdpXLpkt5eA@mail.gmail.com>
 <CAFBxzAC0bjaFaH-i6S0DFFP025o=6V4QVsnBQk92P20XVrvthg@mail.gmail.com>
 <CAFBxzADnkEKuAxDxi58xczg53UC9t4Dw238bJ1SoXra9P9+M7w@mail.gmail.com>
 <CAFBxzAAWOdVk_E2FVyjS-en+h0oF=YKFqdWZ+VFeU36V4BNBmA@mail.gmail.com> <CAFBxzADfCPgYD0xsKqCse0Vc1p8Poo-X-r4H1JBp419hgwgmZw@mail.gmail.com>
From: R E Broadley <rebroad@gmail.com>
Date: Sat, 17 Oct 2026 14:11:39 -0400
X-Gm-Features: AclHuK_cfBb33-pg9bayEEUcciabvcEggoHkZaCjrAo8Y0JuZ_Z1HmBIa_gIRMU
Message-ID: <CAFBxzACd90ckGVQekcZ6iCvo56zO3mcs_aP5VTau9uMveSRn8Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: quick-inherit snapshot-only qgroups through tracker
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Correction to the RFC thread: my 17 October follow-up correcting the
baseline hierarchy was rejected by the list manager because the
message included an HTML MIME part. For clarity, stock Snapper has no
shared tracking parent between the live source qgroup and the
configured snapshot qgroup. The paired Snapper proposal creates the
tracker; the formal patch describes that topology correctly.

On Sat, 17 Oct 2026 14:05:53 -0400, R E Broadley <rebroad@gmail.com> wrote:
> Btrfs currently falls back to a full rescan when creating a snapshot whos=
e inherited qgroup has a parent while the source qgroup has none. That fall=
back is expected for the stock Snapper layout. The paired Snapper change ca=
n create a shared tracking qgroup containing the source and the snapshot-on=
ly parent; for that exact topology, the counters can be derived without a s=
can.
>
> Extend qgroup_snapshot_quick_inherit() for that case. Keep the existing s=
ame-parent exclusivity check unchanged. For the tracker case, require that =
the source has exactly one parent, the snapshot-only parent has exactly tha=
t tracker as its parent, and the tracker has exactly those two members. Set=
 the snapshot-only parent's referenced counters from the tracker, retain it=
s exclusive counters except for the new root node, and use the existing ite=
rator to update the tracker and its ancestors. Ambiguous hierarchies keep t=
he current rescan fallback.
>
> This is an optimization for the paired topology, not a fix for demonstrat=
ed counter corruption. A stock Snapper source with no parent still takes th=
e fallback unless Snapper establishes the tracker.
>
> Testing:
> - QEMU on the current Debian kernel release 7.1.13+deb13-amd64 with Snapp=
er 0.10.6 and 0.13.2: repeated root/home hourly snapshots, timeline cleanup=
, compressed and incompressible data, and externally shared snapshots passe=
d with the candidate module.
> - Quota-limit cleanup passed. Comparisons of all four qgroup counters bef=
ore and after a full rescan matched.
> - In the stock-module control, each snapshot round took the existing resc=
an fallback; the paired candidate produced no further snapshot-triggered sc=
ans after tracker setup.
> - The patch built against v7.3-rc7. The qgroup.c source is unchanged betw=
een that tag and current upstream master; this build was not a runtime test=
 on v7.3.
>
> Signed-off-by: R E Broadley <rebroad@gmail.com>
> ---
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
> On Sat, 17 Oct 2026 13:58:47 -0400, R E Broadley <rebroad@gmail.com> wrot=
e:
> > Correction to the baseline hierarchy description in my RFC.
> >
> > I described the shared level-2 tracker as though it were part of the ex=
isting Snapper hierarchy. That was incorrect. Stock Snapper has no shared t=
racking parent between the live source qgroup and configured snapshot qgrou=
p; the tracker is created by the proposed Snapper `prepareQGroupTracking()`=
 change.
> >
> > In QEMU with Snapper 0.10.6 and the stock Btrfs module, three successiv=
e hourly snapshot rounds each marked qgroups inconsistent and completed a s=
can. This is the expected conservative fallback for the unparented-source b=
aseline. With the paired Snapper and kernel candidates, repeated snapshot a=
nd cleanup runs passed, and a later full rescan left counters unchanged. No=
 counter corruption has been demonstrated.
> >
> > I also checked current upstream `master` and Linux 7.2 `fs/btrfs/qgroup=
.c`. Neither has the shared-tracker fast path: an unparented source still t=
akes the rescan path. The proposed optimization therefore does not appear t=
o report behavior already fixed in those later sources.
> >
> > This narrows the RFC to avoiding snapshot-triggered rescans for the exa=
ct tracker topology established by the paired Snapper change. Other layouts=
 retain the rescan fallback.
