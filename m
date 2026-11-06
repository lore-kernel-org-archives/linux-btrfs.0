Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793957708;
	b=ynULWYVblp1y11v9q+LjpqX5Fdm5+ccUaV+dI8PhzO/b4AIjG1+Fn+bH4CQami/4IhNW
	 azGg+SDngQi34j5dSbcZoNnFctvk7lUvAgWugvDO6C6XtGKpdT3T4sE469zorZthYWjcj
	 S4c15n8fudgrCOnqyjlEDx56j31ppIVgsuJPxPqjGSSriYt6friZUfXW8/qQmS9I7YMMb
	 sMRV+K6bD54NijkkZ0yIUm3O0la/fEMQ3W+PTV1ggCuq5hXFhvS4hY+02yDfWiVhPT3FO
	 VUIqn2pygKaBh5KvT+fzhL5RbvzTlHFv92y78S0LToOmSQo1pOFKJSlBrzpIx45AOhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793957708;
	h=DMARC-Filter:DKIM-Signature:Cc:Received:To:Date:Mime-Version:
	 User-Agent:Content-Type:References:In-Reply-To:From:Subject:
	 Message-Id:Content-Transfer-Encoding:X-Lms-Return-Path:
	 X-Original-From;
	bh=Hu28XpLEwWJ7+xUnuq8g3SEEbhUTtYM5zp2cNel/cQY=;
	b=uTRhpN3aOQ/t4QHKXcvHMrOroft4gvyGLPxNHYUx/FLWMPiaWdVMRF1u9NiLBBAG744z
	 sD9ZqiiLScUDIgFys32zzP/f/OF4GHGpsUAJQo6akGboSHgcAk9d/RRMgYYijSEW6dihn
	 venJLV0l8E8tXuSGE0II2hCBjr9yurQPESk3sO6lmbLWdR72nzZ2dvk0BPBuWj+451m4j
	 rF5L02usrwLyixvPZ3hK346KbHWEbmivqEejWfZFh9VeQKC+iiAXk9K1qVdKl88Jo14zJ
	 4e2+f3FS82uxXrMtVwTEQFvVVFLkmI3gnTbpQUFXzbsOc94F9CZ1XIZIG9D6jcCAvAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=asIfuVKn;
	arc=none smtp.remote-ip=209.127.231.53
Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2EA606EEB1
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 09:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D2EA606EEB1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=asIfuVKn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793957702;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Hu28XpLEwWJ7+xUnuq8g3SEEbhUTtYM5zp2cNel/cQY=;
 b=asIfuVKnQZF60amh8dhg+v36je+ilhQRQRoe+4n4ujnBoncQQsWNJr9JJKfHCguXPCtiqw
 yusZe4NjhjD4YczpPY53w++rQ7jJcFMINlfRM+M1IplEFvlKCwmDI7Xk7TtRTWR2q5lIs5
 w2k6a/4TWy9Gns7tgBRtsUYuYfwzkEWrTbGf30NMOxepELfmxcpvYUdcKf0FLnHrbKzgxN
 ckURRF5EpltOuhHWElhlgLqis49FgKY+AEdRO/r9ClVdwnmyxDIoG/pmzEJE+EQfOjTiCb
 HarMPwVdX/pCJCjfJGTSE1if0BhMNEw18FG4i60YkE+x+bs7sMZNzEP1A2Ng1w==
Cc: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>, 
	<linux-btrfs@vger.kernel.org>, "Naohiro Aota" <Naohiro.Aota@wdc.com>
Received: from [192.168.8.64] ([183.34.160.174]) by smtp.larksuite.com with ESMTPS; Fri, 06 Nov 2026 09:35:01 +0000
To: "Jochen Philipp" <a2jphilipp@gmail.com>
Date: Fri, 6 Nov 2026 17:34:56 +0800
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com> <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com> <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com> <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com> <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com> <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com> <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com> <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com> <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com> <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com> <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com> <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com> <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com> <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io> <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
In-Reply-To: <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on host-managed SMR (WD HC670), fs forced read-only
Message-Id: <18ae2f6f-956f-41cd-ba40-7ca4ab06e659@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26aed9f46+dfb261+vger.kernel.org+zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>

=E5=9C=A8 2026/11/6 15:36, Jochen Philipp =E5=86=99=E9=81=93:
> Hi Dongjiang,
>=20
> thanks for reaching out - yes, I'm willing to give it a try.
>=20
> Johannes asked me to keep the on-disk state untouched while he
> looks at the zone report, so I'd like to coordinate with him
> first: Johannes, are you fine with me testing Dongjiang's series
> on this fs, or do you need anything else from the current state
> before I do?
>=20
> For testing I can set up a separate machine (bare metal, no
> out-of-tree modules), so my main system isn't affected and
> switching kernels is easy. I'd move the drive over there.
>=20
> Two practical questions, since I've never built a patched kernel
> for testing:
> - Which base should I apply the series to (e.g. 7.3, or a
>   specific btrfs branch)?
> - Is there a git branch with the series applied that I could
>   use instead?

Base: in sync with btrfs/linux's for-next branch as of today:
https://github.com/pdzhu/btrfs-linux/tree/for-next

Testing branch: my v3 series rebased onto that base:
https://github.com/pdzhu/btrfs-linux/tree/zoned-fixes-testing

Thanks,
Dongjiang
