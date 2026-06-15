Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C423DC4A4
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 10:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781518108; cv=none; b=MKDQXqfax6j7hil1LQY8mVKjiTy8Tp+O00aHD58FkYMJKK0jUZnTdntRCi5zOeJro9fXBx1CBuRkviKlJfIhErFl7971uCjUF8W/T8EE0wojahfqVhaTlfTkF0R7yiIHrqRif/mAZmP8IrMxuSI+9JVuq+/5n4P+rWqdGJ4XHuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781518108; c=relaxed/simple;
	bh=uO0JqRoXriv3q239HYK1oSEoH3c2+vHUhVyN6bqDlNU=;
	h=References:Content-Type:Date:To:From:Mime-Version:Message-Id:Cc:
	 Subject:In-Reply-To; b=jZm/wi7J+G5lzzJU6otVurSmQo1II2Elg+znSppChe/S13g8Guc6/0IzaFRAbM++NTYrPlpuSW2QblbNmSA+Wr1tNZYhe+TN3UoMUGBs3Ai6+cEhBxMF2Y2UNrq53iR2SH3IE+RBjtkXzjowDwawOwZWhJOQ+jtSJzVLMmtiOe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=KAPYI6Nz; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="KAPYI6Nz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781518100;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uO0JqRoXriv3q239HYK1oSEoH3c2+vHUhVyN6bqDlNU=;
 b=KAPYI6NzwNnFvRhwVk0bkFTYykbb9ODbqtZfhA2tTIcZrqMuz4CHMDNNeUWsxIEpDpwmy3
 kK32UoT7CBmt/TyoVJizuXa+uBuXOiBMgUQlU4mr7AV4VqVwAD7OUQudCeH6nLsuDJ8nbk
 JbWpdOnfVxWgh9bVnxE7OypmQ9IIQN6Aq9or6j0vobztznL9wk86b9IbE3lLAxK5ELbNsO
 UP3Ijyv/S0WCClNe89MmkZYRUNNZsDm/iUU6qRH2uV6+0jWgJNuBuZlmW4z9YuPbE8ZS0T
 VLv27QsyXtCnbWVLM0i2K7DpOeNXcD/dQ8+FzirtH4is0FMCJWwv4zKvPUyZ5A==
References: <e3f872938a6ed3061a08ba18713f6d416c0b65be.f237395e.6fc4.4578.b4e1.98cb5eafd212@feishu.cn>
X-Lms-Return-Path: <lba+16a2fcf12+489b70+vger.kernel.org+sunyangkai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Jun 2026 18:08:17 +0800
To: "Qu Wenruo" <wqu@suse.com>
From: "Sun YangKai" <sunyangkai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Message-Id: <e3f872938a6ed3061a08ba18713f6d416c0b65be.821985f3.0f04.4a16.9d5a.bc69739d2573@feishu.cn>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Questions] about defrag related logic
In-Reply-To: <e3f872938a6ed3061a08ba18713f6d416c0b65be.f237395e.6fc4.4578.b4e1.98cb5eafd212@feishu.cn>

> Hi Qu,
>=C2=A0
> I'm exploring the defrag related code in kernel recently, noticed some co=
de seems misbehave in defrag_get_extent() and related code path so I want t=
o double check them with you before modifying anything.
>=C2=A0
> In this defrag_get_extent(), we use btrfs_search_forward() to search the =
tree if @newer_than is not zero, so we may skip some existing extent items =
and get a large key.offset. But later, if key.offset > start, we mark the g=
ap as a hole, which seems not that correct because that range may contains =
some old extents.
>=C2=A0
> The comment of the function says it will return NULL if we cannot find a =
file extent matching the requirement but we returned a hole extent_map inst=
ead in this case. Currently this will not cause visible misbehavior, becaus=
e hole and old extent are both 'skipped' in defrag related logic IIRC.
>=C2=A0
> About the design of this function, I still have a few more questions:
>=C2=A0
> Why we need to use btrfs_search_forward() to skip old extents? I don't th=
ink a normal search_slot() and then drop the too old extent is expensive he=
re since we only care about the extent that contains @start. So this optimi=
zation makes no sense for me.

Ok, after reading more code, I found that the search_forward() and using ho=
le to stand for the old extent seems intented to skip the large range of ex=
tent data, so we don't need to walk each extent item in defrag_collect_targ=
ets(). Sorry, I was stupid.

> Why we need @newer_than in this function at all? We already properly hand=
le the old extent things in all callers of defrag_lookup_extent(), so I thi=
nk it's ok to just return an old extent and we don't need to bother with ei=
ther btrfs_search_forward() things or drop old extent at all.

So for sure we need this, that makes a lot of sense.

> And in defarg_check_next_extent(), the comment claims a case that
> `... or we'll hit a case we mark current extent for defrag, but the next =
one will not be a target, this will just cause extra IO without really redu=
cing the fragments.`
> Does it mean we should count the next old extent in target so it can merg=
e with this extent and we can get less extent and reduce the fragments? But=
 the code seems doing the opposite thing.

And this is for not mark this extent for defrag when the next one cannot be=
 merged with this extent. I think I understand it now. Sorry for bothering =
and please correct me if I misunderstard anything :)

> Let me know the direction about how to improve this if needed and I'm gla=
d to send a patch.
>=C2=A0
> Thanks,
> Sun YangKai
