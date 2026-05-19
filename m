Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6154A13A9
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779185664; cv=none; b=dcioP93OQUg9Fj/39gqXrLH+zT99MGNbOuq8pnmuhcAgo6CDAhdDKHymuBRjbAsl2KHBEttwdQEsiB5232gGn4JaPQOwqJjfVlofbN0ajGad6LZ9wZrOPvv4f926afnoYA07QX00LxioSsIoYnDdiJH/YCBzjDgMEUwpZEF/c8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779185664; c=relaxed/simple;
	bh=clRG4yFkpV4qJjrA1FlZc1YPdgWSRcNPpfFe6zb/Dgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jVdeOnLEiJHzUGQGpmhOsJuvPgksdey07POtoN0XwFGQO37ZuCYzo8qqecFuJpxRLfhXNcVOptMRjvKpy5VyGHiqmGhe2tWvja1hx0jML55p+rpmBimmV+GTRcSHpNR4h2mG1bQcsYjrJkn0XDTOkhQHjSitcI26i//LD8cr3H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQVewsqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQVewsqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934ABC2BCB3
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 10:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779185662;
	bh=clRG4yFkpV4qJjrA1FlZc1YPdgWSRcNPpfFe6zb/Dgw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mQVewsqDQyI7cYuxK1ahn97qVYyV9oHXLfacKWCpWJ5XUHxBbYFCC9DcEhJnxCM+f
	 u5BRmhP0l8TGxJUED/C23Q8lZ2tL00IKzs4JmKyi6gC1/1Cq7AVTUL5Z7723j7GKCz
	 H0YB/R+9AIPwunNf/aHsDbL6KNxb89N0oK83BI68j6b6GEXdn6PjhonRNYacYzmaGm
	 AOgO42GLwtSIgU9PBIgwgPwXKUxucsJYviFwu0P5JWrRzi5NSjjobhZ435RK1cnZN9
	 q95WDlWdkzdLfO7bC3H1pFCCiaBCMtIaGodcJlORrN68DKlb7u238q5zDi3VvBmet0
	 m7RJnHx21cW0A==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bd8faef2e18so172141366b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 03:14:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YxvhpSrDFfkbs3mM5TpzP64m0WkY3P4/dPcROQuBZ7U38lAFiXX
	I5bybpc49gX16WNoIM9PJUoml3EUmwJQpuedVwCF9wgkzLazjQ9MbGhb//DhweEZKQT0b4bFBU/
	ft21a56Nw3jdx8wd8rCDhJY9HoumUNAw=
X-Received: by 2002:a17:907:d14:b0:bd8:6ac6:d722 with SMTP id
 a640c23a62f3a-bd86ac6da56mr379006866b.24.1779185661216; Tue, 19 May 2026
 03:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778776706.git.fdmanana@suse.com> <7244807c-dc19-4b24-bdf0-ea9853641c44@wdc.com>
In-Reply-To: <7244807c-dc19-4b24-bdf0-ea9853641c44@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 19 May 2026 11:13:44 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6kzbbbrN-C5_v2_rjeOVFS3=nW5gM2urXsRJKtHx7-_Q@mail.gmail.com>
X-Gm-Features: AVHnY4LHJnNQVu7n4IihN5g1Xul9qP6rX9aGRY8Oq4T1BMbU4X1kMzq4V7wYGpk
Message-ID: <CAL3q7H6kzbbbrN-C5_v2_rjeOVFS3=nW5gM2urXsRJKtHx7-_Q@mail.gmail.com>
Subject: Re: [PATCH 00/28] btrfs: add trace events for fsync and inode logging
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 10:59=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> Are we considering tracepoints an ABI? I hope not, but if we do patch
> 2/28 won't work.

They are not:

https://www.kernel.org/doc/html/v5.17/bpf/bpf_design_QA.html#q-are-tracepoi=
nts-part-of-the-stable-abi

Thanks.

>
> Otherwise,
>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>
