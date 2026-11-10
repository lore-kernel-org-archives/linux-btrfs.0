Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794319418;
	b=m77hqiDc9je0CetEL088gJleX2dbsNqVkL1EV6Z0FAEh0nm9ZNrA1RbpgOXSQBSqHN8J
	 YAQ63/JYz1weD7q250ieWthrfZ7ms3OmHatz1tVf+x0CXMNUW1WtGBbHWVpFCGqvxY4Pb
	 RmjPuV38jszc5sSbnDq7NiQIydER5BJ/WDBr22S1kUT4RBPfLMtowMt2fAq8MJvs+o9hU
	 iCy9XpJuwYdUUE6Fgf36pFkxNXDi1t6XVXu69pOU8jFmMRJaXqG2d0jApvCbyEuaFI2zT
	 96Pmovs/caiQx739W67majgr7R72q8grL0bq8xM9QHDBXXCJ4sJoQPZzJ59kOFce6Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794319418;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=LmeHeiyAlUzpahmPYHz4GdQzrqGVFRf1t8/WmrIMmcY=;
	b=gazju2GiUMDnkJyCL9wBgukEsVqepcV/U1+lIH5BQ6JhlWi6EWYxlIsTq5xK8dD9KjeF
	 jaXDaIkBl52NA5dTDHL5KXQQ6mfwP5gdSgdI9JKJarBnR912x7tZKkGGzr9nAWtpRnn5m
	 QvXqYeyQmnjY78Rbq7bfL5tJHb1fAOiL6svkJod6QVlstEAqfTSJ1SKWeoXPsUgdvYV3M
	 iR8n2XpezLo7Y2ybpUlILoIo5c03zqHvCu1ky3yTO1rUpRQ9MgAmu8MAwFJW0R98MqTdh
	 Xu3+kekBjIqTv5KDGcaGr98bsSPNnIz6cuiscsOLvbFZTbbnOC3Rj53IzOUlK2vdjcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qd9av5Tu;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC7960A2605
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 14:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FC7960A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qd9av5Tu
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1ae58d17cd9so1552421c88.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794319417; x=1794924217; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LmeHeiyAlUzpahmPYHz4GdQzrqGVFRf1t8/WmrIMmcY=;
        b=qd9av5TujnJ/Aq2L1f9AluP+IX3Le7VDPsCMuxi5ml0vPbBJfX3Jo1rG2fwV09ZX5T
         aqfMSuVz4Xo8ffuvtx+E+Ciavvr7pXC8sn8XUOz3jkjccMl7gjn8Vdpr9ghNM/P4WWAx
         v/USo4lQ+1gEnB89Tt0XE4vsIe6RCG5dGhQjo1ND5JhUIj71jya89EG/jvg18+kgsEDm
         cVfYN1oX5lVwo/KSlzSpW+qMSCL6E4nqPk9wH0H4nMIV0gbSMqD/yJUJn4cbeGK92VPa
         12kUBQeF7WVm5zCXOLGqPjd7q22p2sE9VLrWlxuV+o9Hjs7XdwP+2iUEp+seLdDcDeAt
         2Pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794319417; x=1794924217;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LmeHeiyAlUzpahmPYHz4GdQzrqGVFRf1t8/WmrIMmcY=;
        b=hcPKIOBmCmFrm0Uod7wQ1hhsVfxAQMHP74b/KXLRkr+9dWGET4ZmEF49jqdbAvqDbR
         AazREp/IA6cwtbr2R6cBJHbLrlRG9WW++BDlBwNOuTOqgfrDYs4heR39JeRG0HxQhCvz
         7zbWEkY3TVPHX5dMS196Iq/IuG2/c0yApssupiBaexWZEweqQWhBkfuAJHYOtzFBfo4g
         MOin30ZKXVmDU7Kgd7TTRdPNuGN+DtunheBzn0POHcZylNLKCQJ6v4kmAqGXdcqtJckd
         QyxK9gWKeM2Wbv5XquyXsW2HAh+IFM+N2cXw++jCBXvNgDUq3vUmvEL15WRGd6rD+j+7
         gOjw==
X-Forwarded-Encrypted: i=1; AL+hErEBoBxR4+DkwNgCY6u+nzNKkEpgvjmqwfTMTgi5OyrhBAolK6OsyrtgrmywqXJowcK1WHg9DHaLke9BuQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9b5jgE5pxnmMFwKeETtTAIrJ9Df32SmoVpn3HWBdrOu3QO9thZ
	vQwLrmZ3GyqrAaPwZOjQgZOUCl1yCknrEB+8k4RZoFWMu+RRgFMrTGVRbzx5fg==
X-Gm-Gg: AYBFou2B7Ruq+DwUwyjm5HKuu3KTekS6FcWKZgBteLEFDxzDNy6W4Gl4kkNs+VrOJQb
	fb06C15sdaTNz+5BnOD/yfR/nHrhNby1mgUOWvjELiJieOtnb3kN4U8NOaXmufkck55Vnwg6dwM
	yFpn3EqP5Ba29w+pjIse/mo6Yico6RxsnT5mAIHMkDqEXXx+VyoM8oM0k0Uq1991lcSpEeTLoXs
	gVtyly97luBJBiU8HK02MlXG1psC2MsSIJcSgQJ+rXXVl3IefxD2ZxA+Ml2bzwTewXkjGRmJZaU
	7+wkCeRFwmnMIdMiUq2ZRhb1BmE/QYCmeRaXS+FMy0mZkmhGVZwi4EJJBGtK4HwS/E7+VCQOzZP
	9RQUAB3R7tSe6z6jT7ozEpMZ5q5ow9q6j1V9+YwGyU2WrCxzWdUQo//FDC+BgRRgPOscZ0yOwR+
	i1sBIHyJvY6AUh/qCF31dgcGqttnKocp4vwTl+GsiYco554HJEKQWb5giRfyu1c/N3hz0nIcV4U
	KW7EQzdiiEvHalzy5XC8z8H+lscMDQnxiOg4IvPlq3Ck8b8ZpEvuRFB5aGDLEAMnHAAAKcGqTux
	Yr8xz0FK6C3yRGBnog8coN/27edVNAzixA==
X-Received: by 2002:a05:701b:2089:20b0:159:2c6d:fcc3 with SMTP id a92af1059eb24-1b3b602d056mr3655380c88.33.1794319415066;
        Tue, 10 Nov 2026 06:03:35 -0800 (PST)
Received: from user ([2405:201:c052:b00b:e920:f0ce:52ca:a7ce])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5ba8426sm6831793c88.23.2026.11.10.06.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:03:34 -0800 (PST)
Date: Tue, 10 Nov 2026 19:33:04 +0530
From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com, mason@kernel.org, fdmanana@suse.com,
	josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
Subject: Re: [PATCH] btrfs: Clean up delayed inode items on transaction abort
Message-ID: <avMkGGHSH2scfa0t@user>
References: <20261109202914.64371-1-pavankumaryalagada@gmail.com>
 <d3e07f45-58f3-4668-b9c2-e0cf63decd4c@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3e07f45-58f3-4668-b9c2-e0cf63decd4c@gmx.com>

On Tue, Nov 10, 2026 at 08:37:16AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/11/10 06:59, pavankumaryalagada@gmail.com 写道:
> > From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> > 
> > When a transaction is aborted, btrfs_commit_inode_delayed_inode()
> > fails because btrfs_join_transaction() returns an error. This makes
> > btrfs_evict_inode() skip btrfs_kill_delayed_inode_items(), leaving
> > pending items in the delayed node.
> > 
> > Move the error check after btrfs_kill_delayed_inode_items() to
> > ensure pending items are removed when the transaction is aborted.
> > 
> > Reported-by: syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/all/6af131f2.44d55313.247daf.0001.GAE@google.com/T/
> > Fixes: 2adc75d61203 ("btrfs: move btrfs_kill_delayed_inode_items into evict")
> > Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> > ---
> >   fs/btrfs/inode.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index abaa33471456..397aa64b4816 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -5623,8 +5623,6 @@ void btrfs_evict_inode(struct inode *inode)
> >   	 * the inode update is released.
> >   	 */
> >   	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
> 
> What if btrfs_commit_inode_delayed_inode() failed but without a transaction
> abort?

If the transaction has not been aborted, we shouldn't remove pending delayed
items.

> 
> E.g. btrfs_alloc_path() failed inside btrfs_commit_inode_delayed_inode(),
> then the transaction is just ended regularly without aborting.

Agreed. In this case, -ENOMEM is returned, but the transaction hasn't been
aborted, so we should keep the pending delayed items.

> 
> In that case, won't the btrfs_kill_delayed_inode_items() call causing
> problems?

Yes, calling it unconditionally could remove pending operations even when
the transaction hasn't been aborted. I'm thinking of making the cleanup
conditional so that delayed items are removed when the commit succeeds or
the transaction has been aborted, but are left untouched on other errors
like -ENOMEM.

	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));

	if (!ret || BTRFS_FS_ERROR(fs_info) ||
	    test_bit(BTRFS_FS_STATE_TRANS_ABORTED, &fs_info->fs_state))
		btrfs_kill_delayed_inode_items(BTRFS_I(inode));

	if (ret)
		goto out;

I included both checks because TRANS_ABORTED detects whether a transaction
has been aborted, while BTRFS_FS_ERROR() checks whether a filesystem error
has been recorded.

Since the TRANS_ABORTED bit can be set before the filesystem error is
recorded, checking both ensures that we also catch that case.

This way, we clean up the delayed items if the commit suceeds or the transaction
is aborted, but keep them on recoverable errors like -ENOMEM.

I'll send this as v2. Please let me know if you see any issues with this
approach.

Thanks,
Pavan

> > -	if (ret)
> > -		goto out;
> >   	/*
> >   	 * This drops any pending insert or delete operations we have for this
> > @@ -5634,6 +5632,9 @@ void btrfs_evict_inode(struct inode *inode)
> >   	 */
> >   	btrfs_kill_delayed_inode_items(BTRFS_I(inode));
> > +	if (ret)
> > +		goto out;
> > +
> >   	btrfs_init_metadata_block_rsv(fs_info, &rsv, BTRFS_BLOCK_RSV_TEMP);
> >   	rsv.size = btrfs_calc_metadata_size(fs_info, 1);
> >   	rsv.failfast = true;
> 
