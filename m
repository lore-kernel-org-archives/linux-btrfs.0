Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764464D9F77
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 06:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790058635; cv=pass; b=KA8TTCuPJgfRem2qLuYlU6V4WCHBu648Iu2lK386/v+hpRcKfV2EbO7XMxzHB8RtoSVM9rzJwtXXhY8IIo08cA8a4r7j07uQjX3Pxk3/YsuK1rz/eWMCLgDpimfBIXiHuGUsuoYddDtZLnnnjxBn1vIa1/V2m/KJC5FNCktI47I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790058635; c=relaxed/simple;
	bh=13S6nXxk+8VbGr9O84inOpYDp0fEg4FZZ3PZF2kQNbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dercdtx85hTDVsuIJWRwGsjhm1lqpox49sLgveHHQ8/15ffoqN22O5NOxl83uU6BhPnltRaUBohRqWD/ls1x34nrQnDs8z8JRoN7BmI4DJOeirjVmvrqq0C4IGivE5F3uJ6b+Wpg4B2pnVJ9S2EiRcQX53bBC15f0URtoQmuZ78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fXFtuSMc; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXFtuSMc"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa650c8so545565666b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 23:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790058626; cv=none;
        d=google.com; s=arc-20260327;
        b=nmESF5z6/NZC/oJ5Z/ior3lutoPJcfxBAbZuzZpTSo53YVM8jRiVO50pE35rCwonId
         dmVX7u749tU75eHDEPPeEfZsKskkHF3AUkIzP9tQmKnU/oAsegfs8jwbYT3fxviftVjd
         yl8Dsxt3YVfUwkRSg9TESdVzdhGKk+fCrsWelFrB6fEsHhhOIctr2iKn03QUGCx/Fg0/
         B8wYvXwemOs5txvsiRh33eokHwlMk/O+tFR/0r4972saqPvFJ/3g8u2A090NIKm9i+WF
         2ToLH81WNQhZtA6F0BOy8SBp7f3ZKMfpXzpcWC6qoU3H1Vglm6ihG7OY1XmP50Lx4tb2
         ZQMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CSlza8CkdzCUdl23ZrbxGk9SXHAYSBkH2iIHwwzYDo8=;
        fh=BCaFVgMZkZwXB3yeQJ4ujSfc/sGEwbr7uNsFg++Jzj0=;
        b=BU/8kaPdjGOIn/kNhgDno7sYJzLlYQos6nNYuOlC9qpXrLr+wQv5ZJ81HRspX2X4hO
         RyAoqC+2DxrJP8jbWAdaBhTZW37I0dDK8Dz3MRhUZiKTuL9PaLuEqDNEhbQYAJfRFAA9
         DSD6/0b+DLUW0HripC9beQCr3OSlCgb0Fkh1qz00eEGN4uPfBKUN49415S2Hzgy0nY5m
         iwr5H1pyxDR2hGkK6zmKtkhxgDSqr3XvVx0LvJ8SHbvrhtnLHJxT/uwRVModjg3h848d
         kUvqYkL7hrpdhU1SMZLX3RLqjlZM5pxY10aSV8eSO/5TpocuuhV+wUnH1Yl9VkuERkUS
         WpvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790058626; x=1790663426; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CSlza8CkdzCUdl23ZrbxGk9SXHAYSBkH2iIHwwzYDo8=;
        b=fXFtuSMcm20Wa6/XWfmVIuOdjM20Z8tFWOdoKN0zigP011lQ0wNbDTvBclzezqL680
         BdtgAs1/29I5Am3q+1pQ+aJr+xQ4msTzT5bR1q4dQhy2u43jncTyVDXBrQOwX+6OPejJ
         MR6e1qv5aMwv12qc54swD1p6zd87wD1NGeTddsKKEOr9q37tb9q8CKA4CVaZ2JJosA4T
         U3jtPOfnOal/7ukLwCuleCbPcF0wSo/wKRG5I9OhBR6Nv4OoUzWXmcyIG0jZjlc5C07v
         6/WlpdTkczlX6G82xx+Ut12hL3v+03Pee4E0CTbuw+FoicfFhBb04QqP75U/Z2qBrQ3P
         nBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790058626; x=1790663426;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CSlza8CkdzCUdl23ZrbxGk9SXHAYSBkH2iIHwwzYDo8=;
        b=FcFCdWlb20qmcAfO0+NJIqHTmAjg8ubvfKkekXtuwKdL5CzdTjb9jBqigFbaxjmdVW
         0hT1ypTnQs15NK3QAsk7wPFcMN28ZHZoL51IulCBvSuGa9aEI71I5MCU+TV2E+Sp6p42
         iaDd+4gLbuAWFIcw92UluGuCe/alq7lMe9lYxRTQ6IY3zQ2EhlrMu3BILdCEEgWC+ZgT
         VtS+oea5zi5xQLIpDzsQzrC7dmKndC4XucJv7UMvGuQJOUZRvItsuytXd6+Rqeukvql6
         CKwnymvtTveb/mGN3DDXsLM60KZm1gfQxoLhHNCruLbYIcCOEAIrJ2+7U+eR0zcjWs+5
         xrWQ==
X-Forwarded-Encrypted: i=1; AKwUvByfP9IB7ti+bhyEzBaW1xeUHJRijEXGD4tK0EfBC/5ozemjwJBckTeOD9S1OVazwglgCC3Nn8Sy5Q530Q==@vger.kernel.org
X-Gm-Message-State: AFuF++ljVpLheZjcRScgG+BEaqI1TRGoEykWeX8SSUGo4fs+B5zaTKd+
	azCNyoGNx8UBiM6TkTV9z0MW7QENxWrowOoU2OLff6vcFY5UsQcKGA1Cq47YgTdKsAQ1Oos60L1
	8oOfo6P+OAeigoDPg3B6j/ivi4HXFE3WsBg==
X-Gm-Gg: AYBFou31NrIKtoDxtirWl7inKVCyOr7rawcW8kxSi69rzQEImvbcFn/ymJtDsYxPMR8
	j0mquSaTkgMJLU5dgPqYAlYQzuIvx3yKiI9zIz3vQP3Km/kyzHqbsAMbEBWtQYggExkVOlEX6BT
	Kt+7ZqfBzzauUQ51vXhSoRQzfNhpyaffv0kt1vuv8Z4YYivLA4tQHKn8EaiLs8+dW/GlRupcy9U
	7GHImhy8+OH+Rw5ILI348KIqzXHxGbCBccQK52vLT3wWBH8f2kyEplkgUU/Myh87lipv7DLGSRP
	6zzFfqHPtNqzEpVYurXf6V4ujhyEDylFgSfyRoMbMDgxA/6Kg9jFMAeA
X-Received: by 2002:a17:907:97cd:b0:c26:19e3:e98d with SMTP id
 a640c23a62f3a-c2a15829046mr1061488066b.45.1790058625789; Mon, 21 Sep 2026
 23:30:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
 <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io> <20260921131220.GE54722@twin.jikos.cz>
 <2c895064-f5bc-488b-8bbf-b6b9b7e842f6@gmx.com>
In-Reply-To: <2c895064-f5bc-488b-8bbf-b6b9b7e842f6@gmx.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 22 Sep 2026 09:30:11 +0300
X-Gm-Features: AcwNN1X8sfATla7x66nBsB8C6wbMFJaScB24QxU7CYIMYW8MY1W42nO66TIuX64
Message-ID: <CAA91j0XXX-W5Robv2P_8n0g5mSN5nzskE7ukzjNpV7YzroWY=w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Dongjiang Zhu <zhudongjiang@fygo.io>, Qu Wenruo <wqu@suse.com>, 
	linux-btrfs@vger.kernel.org, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 12:46=E2=80=AFAM Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>
>
>
> =E5=9C=A8 2026/9/21 22:42, David Sterba =E5=86=99=E9=81=93:
> > On Mon, Sep 21, 2026 at 04:36:51PM +0800, Dongjiang Zhu wrote:
> >> =E5=9C=A8 2026/9/21 15:03, Qu Wenruo =E5=86=99=E9=81=93:
> >>> [BUG]
> >>> There is a bug report that a running qgroup rescan can fail a pm
> >>> suspension:
> >>>
> >>>    [ T278489] Freezing remaining freezable tasks
> >>>    [ T278489] Freezing remaining freezable tasks failed after 20.003 =
seconds (0 tasks refusing to freeze, wq_busy=3D1):
> >>>    [ T278489] Showing freezable workqueues that are still busy:
> >>>    [...]
> >>>    [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 active=3D1 r=
efcnt=3D16
> >>>    [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111=
s
> >>>
> >>> [CAUSE]
> >>> Btrfs qgroup rescan is running in a workqueue, and when the fs is
> >>> frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
> >>>
> >>> But a sleeping workload still counts as active for the workqueue unti=
l
> >>> the workload exits.
> >>>
> >>> So the qgroup rescan item will sleep on the frozen fs, and fail the p=
m
> >>> suspension.
> >>>
> >>> [FIX]
> >>> I strongly doubt whether we should even use a workqueue for the qgrou=
p
> >>> rescan workload, a kthread would be a more suitable choice and can ha=
ndle
> >>> fs and process freezing way better.
> >>> But that will be a long term solution.
> >>
> >> Hi Qu,
> >>
> >> Thanks for working on this.
> >>
> >> I recently posted an RFC series addressing qgroup rescan lifecycle
> >> issues around quota disable/enable, error cleanup, and remounts [1].
> >>
> >>   From the recent discussion, I got the impression that full qgroups
> >> might be phased out or substantially reworked. Is that a fair
> >> understanding?
> >
> > Do you have link to the dicussion? Phasing out current qgroups in the
> > full mode would be a functionality loss and we don't have a replacement=
.
> > On the design level, the qgroups are general enough to cover the COW
> > design, sharing. The compression was originally intended but IIRC we
> > don't account compressed extents separately.
>
> The biggest problem is the insolvable nature of tracking the owner of
> every extent vs changing all extent owners in one snapshot
> creation/deletion.
>
> This means qgroup is only reliable with rigid subvolume layout, which is
> never the common use case.
>
> And all the current workarounds are killing qgroup limit functionality,
> requiring endless rescans again and again.
>
> >
> > Reworking could happen, the performance hit of qgroups in full mode has
> > been a problem since beginning, but I don't see any easy change there.
> > If the sematics change we'd need to add another mode, like we have the
> > simple quota mode.
>
> For now the only major user of qgroup original mode is snapper (for
> subvolume cleanup policy), and we're already pushing snapper to not
> enable qgroup by default (although no good progress yet).
>

The major use case of qgroup-like functionality is snapshot
management. Whether it is implemented by snapper or by something else.
Without the ability to get an accurate estimation of the real
subvolume space consumption (how much space will become free after
deleting this subvolume) any snapshot based workflow becomes a
nightmare.

> I'm open to new designs like simple-quota, or maybe "reference" only
> accounting (making it almost the same as the quota files supported by
> all other fses).
>

I do not see how "reference only" is useful in any way. We already
have enough tools showing us "used" space exceeding the physical
device size by an order of magnitude.

> But I do not think full quota mode should be a feature that should be
> enabled by default.
>
