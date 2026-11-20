Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200953;
	b=LB0YsgdI67/YYaLgoMbbRL0QCdpHs0ddO+78I6Yok94r29jgYxOna3s3xOqc/exyo491
	 vSNmAtIVAMSyXNZgGXoxZy3bBwBUOEwSGVhqyZ8iu5Cgmfp1YKjmk+fqc5W5gKJjNc6JJ
	 0AQHPOu+C7Y+ITyRqSlyu/9sXZb70fi5w52BzIr3EKmYzP3UJDwX0PvrT+QnaS00Z7QLV
	 WfgrFe75lGc44CPirqCe9Ur/2djkcxY9jq7X5HjZKcFQkkRIMsqLEtHpoQ/Jvp4uHGVAM
	 p4QHHxIoi+jK5ctWP2qEAxQ9CkCr7kYTVMnUtwSBAg5t7CsCV9lop5UX8smwCTc3obA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200953;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=aVe7QAtYgLUF/jH3V4jLtDfswfaE7SBHfV/dCwyBq7s=;
	b=03X9Ejdi0L8xm2UTpQYp8DGdzfcUDtXTbtvAYIJFtwsUaB0f6WQZg1AFTgPCGZuQHJ8O
	 p5ZiHp4ZQlKtKbw+Hvk66ajxhhb5t++Mwc1AY2umutknyJJZSTjhBFba1kXkell6XKAGE
	 1FGhciaQt0VWpXWlLQ1ErLfML8Bv/+oPuyK4JXeqmfXEKH6QpHug7hwI0Qom1z9EEis+k
	 UDmXJnpukwXzWLtnLPgjmSamRSA1uyUSxcxcoyXkUlxxcRm9a90we7QBsaUQRwC4yQ2Sl
	 /tH+PbzR9nekfCBsWTPd1WSlxGK90rACsjh+8SzG7SyC3lJ8H7v5IUUfDpXbJ1SMgcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OE7T6rt+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3688C60A2621
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OE7T6rt+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827BD1F000C0
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200952;
	bh=aVe7QAtYgLUF/jH3V4jLtDfswfaE7SBHfV/dCwyBq7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OE7T6rt+qR/kP5sYrj4M069ycIgB2hlSxR85IY5eGZ1QjYRIXzOleyUKbF4uEAkVj
	 Hapn3HPkIqj+Z4qwfSzWEHbvsaheQNiaFx3mZnXMpRStBiWn5DpMPruMi1M339HW45
	 X17V6ewdpOLlLIXI9s3T73PqutDBa4cUEzivp8zY1G3vzkMqUZqfSyuwvA6iTQbwvG
	 M5Fa2yOJLqjMLcnRHbJP8Vmh0iEIWc+QMkbcsqQWaamHyVC1kv6VuldNZHcHPf739F
	 fRsezM3YcbD3iOnVJi37OqX7Pxhf1GcC5N9WNcf+RVuXd/7XpUA6zWgh8P+kubXKd8
	 Im73BKVVfFtJA==
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7d2da1667b2so741219137.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 10:55:52 -0800 (PST)
X-Gm-Message-State: APuU4Z9izDLeuOVQELq0JULwLe1UH75ZED471C5FL9sfMvs8drXNcuBB
	Pg086Req1ND8JmFnRDdNBCFL/3tDglEIPHOMPNGt2e8DU0YPhrykQfjiNY+a8VwCEOisGtv6BaH
	l7oCIA/EPqnt2a3MXNz1Wwb+jaJTY7Go=
X-Received: by 2002:a05:6102:26c7:b0:7d2:7be1:271f with SMTP id
 ada2fe7eead31-7d7395b6953mr2254719137.31.1795200951717; Fri, 20 Nov 2026
 10:55:51 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795168584.git.wqu@suse.com> <900cc1ec5feac55f401015f3fdadc242c0c6d275.1795168584.git.wqu@suse.com>
In-Reply-To: <900cc1ec5feac55f401015f3fdadc242c0c6d275.1795168584.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 20 Nov 2026 18:55:15 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6KOHBY9_bqjJofF1r-rSqT=jUSH55bpVxMO6owR6RX1g@mail.gmail.com>
X-Gm-Features: Aa3M54pllHCUcE4xkJfIVUa-10VWAFZe_N5FsWpZKgN3hl3wDyeREIK74bU8xM8
Message-ID: <CAL3q7H6KOHBY9_bqjJofF1r-rSqT=jUSH55bpVxMO6owR6RX1g@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] btrfs: qgroup: handle the transaction commit error
 during rescan
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 9:58=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> After qgroup_rescan_leaf() return 1, meaning it has done the scanning,

return -> returns

> btrfs_qgroup_rescan_worker() will call btrfs_commit_transaction() to
> update the qgroup infos.
>
> But if that btrfs_commit_transaction() failed, @ret is still 1, which
> will treat the rescan as ended successfully, clearing the INCONSISTENT
> flag.
>
> Fix the error handling by also check the return value of

check -> checking

Looks good otherwise, so:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> btrfs_commit_transaction(). If that failed, update @ret to the error
> code so we treat the rescan as failed.
>
> Link: https://sashiko.dev/#/bug/linux-b578ca93-4f5a-4a46-9dfc-71c1ac9af09=
5
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 3127d3fcab31..9f3886d128d3 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3928,10 +3928,15 @@ static void btrfs_qgroup_rescan_worker(struct btr=
fs_work *work)
>                 ret =3D qgroup_rescan_leaf(trans, path);
>                 did_leaf_rescans =3D true;
>
> -               if (ret > 0)
> -                       btrfs_commit_transaction(trans);
> -               else
> +               if (ret > 0) {
> +                       int commit_ret;
> +
> +                       commit_ret =3D btrfs_commit_transaction(trans);
> +                       if (commit_ret < 0)
> +                               ret =3D commit_ret;
> +               } else {
>                         btrfs_end_transaction(trans);
> +               }
>         }
>
>  out:
> --
> 2.56.0
>
>
