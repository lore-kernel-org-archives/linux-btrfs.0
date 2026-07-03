Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E07286AC
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 02:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783046046; cv=none; b=qNQShUP9UZTY3mjjzv85O/ODcVvoliHyhjl2jf7kctccPAHtOoLJIHEVzrPD7cckJsID2WNBz55cC529GOmFaNcqniA4vXtUQByIKqbeyB5fstWfCCNvXEqen/ZAJo8mxlHcIC6RMl7+LQH+93ohHgYFn9PRdKfiFvbTFBJyNH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783046046; c=relaxed/simple;
	bh=LiXqciQCt8Cob9wW4aZdf65FA3T6J8eErhhAH4gE9Hs=;
	h=Content-Type:In-Reply-To:To:Date:From:Subject:References:
	 Message-Id:Mime-Version; b=pyDUiheATdpp3cEMVXq2J1L238J4XMnaA43lz/YV0qvNlIY5l65JjP4nJ3RrAOrthsWaLD76vgrEW/EeSRc9fY9tNaQJdI2JsnTS9iDekrWIpniZE2QkVEn/L0VcswkaCob9L/P/xZaHigkNkYo2zfYZM6DKr3MNrj3MFQZslC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Q5vT67Yv; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Q5vT67Yv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783046031;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LiXqciQCt8Cob9wW4aZdf65FA3T6J8eErhhAH4gE9Hs=;
 b=Q5vT67YvIQbEp0QawoVpnKdkq8gU6QgnNKn3jeb7t4oLk3weR7HxvLgJgmjuW4lx0RarYT
 ADr9HOQnvXHkismC+yVjE01zP63K5BGZBH9H/3V1CP4rFW9oV9rCTpu484UcJT3raWGDrM
 l0ocjfgXEk+RG1iiIGR9jJuaHo8tGiaFsWGpArCJOWaGzGUOQsRqoIiiq6mn2lqsfBKCT1
 /h5i+IO7mJxuLxxGa8CCpT4UHTgYY1/NRR6ZN1tKZ6l5S9gK0YLZ1xnfXjOm++twc0SRsV
 6PqWrOY8BUr6Au7FyCCH2P5zc4RuO/6qirU1dD0/5IX5G9H0H+IXDbIPk9DAeA==
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783035512.git.wqu@suse.com>
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
Date: Fri, 3 Jul 2026 10:33:41 +0800
User-Agent: Mozilla Thunderbird
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a471f8d+b04750+vger.kernel.org+zhudongjiang@fnnas.com>
Subject: Re: [PATCH 1/2] btrfs: add "rescue=usebackuproot" into forced read-only options
References: <cover.1783035512.git.wqu@suse.com> <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783035512.git.wqu@suse.com>
Received: from [192.168.8.64] ([183.34.165.6]) by smtp.feishu.cn with ESMTPS; Fri, 03 Jul 2026 10:33:48 +0800
Message-Id: <47c417e1-acf9-484c-a166-3787857c8f22@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2026/7/3 7:40, Qu Wenruo =E5=86=99=E9=81=93:
> According to btrfs(5) man page, all rescue options should require an
> read-only mount.
>
> But that read-only check is only introduced for newer rescue options,
> not for the pre-existing "usebackuproot" one.
>
> Unify the behavior to match the document.
> [...]

Hi Qu,

Just a small note from looking at this together with my CLEAR_CACHE patch.

If rescue=3Dusebackuproot requires a read-only mount, my patch to set
CLEAR_CACHE for it may no longer be needed.

Also, should rescue=3Dall include usebackuproot too?

Thanks,
Dongjiang
