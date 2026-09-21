Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D93B439F77
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 08:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979826; cv=none; b=perolE5zbBc1cGXSNxAxyLwHsdOcT6YUJgM/kwJldiwl1cI6SvGd1ZPI+L3y5Vcpxol7338CAbU8HB1CoCEP20m1ZtKJ/B2S0m9qwZgoazCFOF5DMnh7sXRk5V1NcR1Sd+KBHi8k2DUfx4VYnZktKkt/c2Z97s3IPPYx5AXw4yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979826; c=relaxed/simple;
	bh=/qU3XbDZvC7W3147vVjvAKiMiOZ3GaZoTFSnlceA7JU=;
	h=To:From:Message-Id:Cc:Date:Mime-Version:In-Reply-To:Subject:
	 Content-Type:References; b=gbeh9UKRuYIYPKSJMu4WFHp4LgLExl887Uj/EF0ce7Z3D/QNm3wwR8hjRTJz1mj7g4jP/gGGfrld9QCx3958mAIOvHwyA4pQXFlNeh19nABHvAhc04n6yRwABDYWtOlpXpN7K0bG+tJ/37d8ImMrlwNsp6CPFkFECDb+1MJpYvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=SslXe0Tt; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="SslXe0Tt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789979817;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WXGrqiQP3Qcq5b10xtWjlbEsWO7CdxaiuZMQVAifQAk=;
 b=SslXe0TtOWjI0S6HAHhOBduE3ju7aMto25GcZWVqcpwrYUD7Xo7no7TUfOv+2Wlxq7Gqxx
 Af9Idff9zhXiotwYh0bonjbjSaydTAKPBp+vSrQgRgamfreqFC3j4cGGnnv9uxSbcekLMK
 gZp9jKnZX4bHAL3wFOwGD8HB/kBWMQJs0e/PF2dYOKH7cMWD0UFBixSg0f0MDcUlqEhTWI
 aim0o2S20FEY0jwQDtqtlgRES7iXHezfmTIE6JG/q9th8OqOaQ7m1r1OKVZCJw99Cq7i9g
 31LYtD35EaM3TZAmApak6FU6sHd2AS3pftviJGiBnsbYvRY3eP0gD9uGs9uHfw==
Content-Transfer-Encoding: quoted-printable
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io>
Received: from [192.168.8.64] ([183.34.169.232]) by smtp.larksuite.com with ESMTPS; Mon, 21 Sep 2026 08:36:56 +0000
X-Lms-Return-Path: <lba+26ab0eca9+411e02+vger.kernel.org+zhudongjiang@fygo.io>
Cc: "Richard Weinberger" <richard@nod.at>
Date: Mon, 21 Sep 2026 16:36:51 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>

=E5=9C=A8 2026/9/21 15:03, Qu Wenruo =E5=86=99=E9=81=93:
> [BUG]
> There is a bug report that a running qgroup rescan can fail a pm
> suspension:
>=20
>   [ T278489] Freezing remaining freezable tasks
>   [ T278489] Freezing remaining freezable tasks failed after 20.003 secon=
ds (0 tasks refusing to freeze, wq_busy=3D1):
>   [ T278489] Showing freezable workqueues that are still busy:
>   [...]
>   [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 active=3D1 refcnt=
=3D16
>   [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
>=20
> [CAUSE]
> Btrfs qgroup rescan is running in a workqueue, and when the fs is
> frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
>=20
> But a sleeping workload still counts as active for the workqueue until
> the workload exits.
>=20
> So the qgroup rescan item will sleep on the frozen fs, and fail the pm
> suspension.
>=20
> [FIX]
> I strongly doubt whether we should even use a workqueue for the qgroup
> rescan workload, a kthread would be a more suitable choice and can handle
> fs and process freezing way better.
> But that will be a long term solution.

Hi Qu,

Thanks for working on this.

I recently posted an RFC series addressing qgroup rescan lifecycle
issues around quota disable/enable, error cleanup, and remounts [1].

 From the recent discussion, I got the impression that full qgroups
might be phased out or substantially reworked. Is that a fair
understanding? Would focused lifecycle fixes like these still be
useful in the meantime? I'd appreciate your thoughts on how best to
continue this work.

> [...]
> The above fixes should interrupt the rescan, so that pm suspension won't
> fail.
> And since the INCONSISTENT flag is not cleared, the end user/tool should
> re-start a rescan if they need uptodate qgroup numbers.

Also, the Sashiko review points out that RESCAN remains set when the
worker stops for freezing, preventing a new rescan after thawing [2].
This looks similar to the cleanup issue addressed by patch 4 in my
series, where stopping due to quota disable also leaves RESCAN set.

[1]=20
https://lore.kernel.org/linux-btrfs/cover.1789524388.git.zhudongjiang@fygo.=
io/
[2]=20
https://sashiko.dev/#/patchset/cfc34be50699e2e0e5c84e4d57345c7e0506caf8.178=
9974081.git.wqu%40suse.com

Thanks,
Dongjiang
