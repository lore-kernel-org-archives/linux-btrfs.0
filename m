Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E733A1CFF
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771952542; cv=none; b=DHMFZKeIopRbsvcx+nF0lJ5o3yYInRuR78LevypFTCaI54Dq7afMDIf8uJyScm8S9sKHbqbuzaZqx9EqkVTC6BUjjLwFLS5o4pVRfvCcqN/Cpy8FZWJ/TidJTI6LxOSzsCOpdAshrVGYISfRO6qt6lD6h9mlg9tU31B5V/fUa9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771952542; c=relaxed/simple;
	bh=IKh54VM/xUWkKjWY0tjuuqkNOAS9Hg6fk7z6Z6htYW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u4PWAkWaBts+/svHV42e8wwgq7krjGV5cqVV6qDPUyAGS4uzy1zTp2YwJT0LRMtkhacEdpZ1HZhZRMTsqMTMlJYaIp0WJqTytUDWnfe0QYY9K+WuMFFdGyF6XCOj6F+rEo5mNJ0u5Hx8wdOm0DbTkNsmGM775d/lxabijubYLIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8WLpjdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8WLpjdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C209C19425
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771952542;
	bh=IKh54VM/xUWkKjWY0tjuuqkNOAS9Hg6fk7z6Z6htYW4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D8WLpjdIVi6GI1YdD0+xAjXLWWOXA6QpuCeFEjhyb5Ie/XIqFS3bkLR36iEixEezT
	 xK+UjDzzZ1pR0zGNnaY1xNRjCEXkZw6nlUuZlMAP8axjw0vCwAHptl6fmYzwkzjHpq
	 /+/bKJeGuveZx/IcysIiC2XQAjvH1ySEjKwBq3aX9TwEREkNFsa9Q0SCQ/Esi+kabv
	 V6FjVIg7K3VVOT/J+KgTVTxXCAIjeY7aln0a8NMYfWzeWVq+Ix3cm0YZ14CBZxLLt8
	 T5lVBsGn3SLouEJOj1UAXdgpkWbkiieAEe9uk0ULVa7GJxba2/XWFuDPcalJChfsa3
	 lXLp4Ydn4Me1g==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65a43a512b0so6534315a12.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 09:02:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWA8W/rM0pfnX/66jga7ZDeSKhimYfFlfb/bhOtlLjeSlxj6F9weeOx6lUprOuD3iXX3CGPvOP8cgZcvw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0oenjFlK5B7CwYXCS2MQassx7a3PayoVLzjkktcITomASfjgk
	7IT+wknQ3YEQoGJfIulZixptIgxg+YGZf4psKH7AvvlAX3uR5Ux5QORsprWIuIFWdSg2atTJDcE
	qb20Y0dRuYZgIuroceIElvCLadasabkQ=
X-Received: by 2002:a17:907:d08:b0:b87:322d:a8bd with SMTP id
 a640c23a62f3a-b90819d97c7mr725666066b.24.1771952540483; Tue, 24 Feb 2026
 09:02:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <djynzzkwdfzqq6rks5njvhjexmje2zoofffkx2qtectxlyv53f@r54cgbf5l2b3> <20260224165704.GY26902@twin.jikos.cz>
In-Reply-To: <20260224165704.GY26902@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 24 Feb 2026 17:01:43 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4HZ1wJ_YHpPXcZOJ=UVSoKqncbkS+3e1D6PhMpzTpTJw@mail.gmail.com>
X-Gm-Features: AaiRm50U7_dg-TyUro42cko4H1DBDDr4eL3kCdijUuS9xg_wcD-CnER5NrsWhiU
Message-ID: <CAL3q7H4HZ1wJ_YHpPXcZOJ=UVSoKqncbkS+3e1D6PhMpzTpTJw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use inode->i_sb to calculate fs_info
To: dsterba@suse.cz
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 4:57=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Mon, Feb 09, 2026 at 02:11:37PM -0500, Goldwyn Rodrigues wrote:
> > If overlay is used on top of btrfs, dentry->d_sb translates to overlay'=
s
> > super block and fsid assignment will lead to a crash.
> >
> > Use inode->i_sb to calculate btrfs_sb.
> >
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> Added to for-next, thanks.

There are review comments in v2:

https://lore.kernel.org/linux-btrfs/apsgauiwdj2exslcb7wmy2womtf6suyzfwatnxk=
75tzseivm4q@e7wktzgzxmsd/


>
