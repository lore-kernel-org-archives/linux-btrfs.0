Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201096;
	b=aZh9kn/miYDst1s0NbkQNG9HE496IvEDYDc6WyFTYDKi/6KpIoQ+D8Yp+LRJUhrmaI+j
	 HZrknhPGjYte+PX4XJlskEsWFcWZmgb7OxFfEq6WZKlaM2rsWSaeJzOQrDW/NULAf6dA0
	 0h4eJRDkjsqCXoUyUl8MuhYQiK+3OLzrqdEMgM+EpgEbVCVNjm/IfG4mOZIrplKc6RW6T
	 OBSruLtNqWBo0UACdidxzyYqoFRglrAFiFPf3URy58gFFjXJ0Tw1RpoQDF1M0IW8I/3In
	 PaHvjh8QKLhd5P61hgYc8pLmgXwiBUs2s/dYM1mvksN3KX9FlqFeUzo7rzRrjH+mv8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201096;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=nUt6v7TYPwPrIj5OtRpYnPMncMWjYpUFSsHrwAQydBY=;
	b=Eqmq1CkFGp4NH9T3ot21zp7+Km775+stxfI5ByvGY7h2wJOYAT7U5QCFb5vj0II7TdY+
	 dKUVD7qRa99ETwAB/TFaFEyBFmND7HC40wV46J4bbA41e9JAgTSf/29Jt2mq99UdUE8OP
	 /4LDwgTIiP7KLnTLUI5UPQwfvA7//ucS2a8aXWBtxr0FaRImQD5RHcOzPgZso8g8WxK4Q
	 Ub9eA6N3aRsjx6zsuk54Jqpy5GDMkMqJjNA7mROvYIrPRA2YmFu9+u5NMuPxfFt6L6xxZ
	 vyy47zX9Pi/8DMzfbvaeXeWSS8pxDvqTM1hYVUmlCR7LMPozkoWFDUpsUTKghnIU/cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=diSpw3SZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5DB60A2613
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 18:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=diSpw3SZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFDB1F0093C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795201096;
	bh=nUt6v7TYPwPrIj5OtRpYnPMncMWjYpUFSsHrwAQydBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=diSpw3SZOvCtnPb5YKPdZ+MGZF80mLY9wVF3IQUAG87Xrf/VQFdi1Hjx2r7CUnkJU
	 yK0PKqOBr6EGTOV38qMg6am20QPebF+lDMVHrViFVcLRU5eGH/e3qA6N7hIBPKd90k
	 VBSoPcLl90y7lOkAM65XiczKgW0V3B1MminsC0y1dqAHX55e/btO+W8L1u5znDJhQm
	 Njc5hehQBk8rufzzSw46Dfx7/sN8MfKiVchBx3muwAsCT2idtf6+wboahpY0yj4b7B
	 wXsIbf834f436gNqzBNRSE63xxDYnCn+Y5M7X2KDSm7vVUhLNjfud8HypFGjJGDP0f
	 QTerzR8S7vz8Q==
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-9828fee1b4bso413598241.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 10:58:16 -0800 (PST)
X-Gm-Message-State: APuU4Z8cAwIWFW9zWX1oonsWV+ArEPA5ChOnZVLEsCwQwSAuJhSuhIdB
	vppssCERN9tZaqaD7c5xxrPVCuyk6YhZkvxX77j3IBk7Z/gOXlVjrQlgkE1H2hAvEPFSmdvbF4P
	VeFW8codT72Ig63//tpD5gI5IewJluUs=
X-Received: by 2002:a05:6102:c49:b0:7d2:d194:3dd7 with SMTP id
 ada2fe7eead31-7d7396744f4mr1561445137.36.1795201095080; Fri, 20 Nov 2026
 10:58:15 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795168584.git.wqu@suse.com> <0de834dc726392804b83031be495d34db0cb1c8b.1795168584.git.wqu@suse.com>
In-Reply-To: <0de834dc726392804b83031be495d34db0cb1c8b.1795168584.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 20 Nov 2026 18:57:38 +0000
X-Gmail-Original-Message-ID: <CAL3q7H40G+R0iUysbdLU8NwfoGn80Z8WJGokCnQZS0THccmQ2Q@mail.gmail.com>
X-Gm-Features: Aa3M54pAs0ye82Eo-Cqk-bStep5Ovvc6pFfbVwDFakBf4knaxG44eaomkukiOOE
Message-ID: <CAL3q7H40G+R0iUysbdLU8NwfoGn80Z8WJGokCnQZS0THccmQ2Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] btrfs: qgroup: ensure the qgroup rescan messages
 are always shown
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 10:04=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> In btrfs_qgroup_rescan_worker(), if by somehow the transaction is

Delete "by".

> aborted halfway, later we can not start a new transaction.
>
> This marks @trans variable always to be NULL, which later skips the
> qgroup scan related messages, this can be a little confusing for end
> users.
>
> Fix it by only end the transaction if we have a valid trans handle,

end -> ending

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> other than returning from btrfs_qgroup_rescan_worker().
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 9f3886d128d3..afac7402af36 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3986,10 +3986,8 @@ static void btrfs_qgroup_rescan_worker(struct btrf=
s_work *work)
>         complete_all(&fs_info->qgroup_rescan_completion);
>         mutex_unlock(&fs_info->qgroup_rescan_lock);
>
> -       if (!trans)
> -               return;
> -
> -       btrfs_end_transaction(trans);
> +       if (trans)
> +               btrfs_end_transaction(trans);
>
>         if (stopped) {
>                 btrfs_info(fs_info, "qgroup scan paused");
> --
> 2.56.0
>
>
