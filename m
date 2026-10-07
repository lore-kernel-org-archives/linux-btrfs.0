Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D10F3A6EE5
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374178; cv=none; b=gQ7Cu6/kefGXU4rxlt/0Xokhvbwex39JmgdwNRz0HS1K/wySgbXi0GD1e1Ka63Ta82Dj3iwlr4D9skhDGUSxhke1NCJBnVkAGIr13rGikn/59h3ozZJJpW4AyMS546MHDGsNL32LFtvWq8bdOpicnwt1TS9Znlf5RHN6W8eWUgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374178; c=relaxed/simple;
	bh=0mKzJzhvRTn23cOkp9SXQk/Lq1UUtnbmx21hUDvb4A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKD/AC8ouy9U2aEh/3ENQUTZrpD9+Suu46dngbu35nHSQLcLThK8+YNtf6O7ZIlnxbbqguVo/t/nVkX59VO9kjS+dh+jBU7DKvMbzuRGFvszXKeR1QqfmEMFyeR6hCeLLM7/UgxeqFmb52FQxbGddvQpVf9+3a4QbsQoPhjwAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvsEZ9tO; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvsEZ9tO"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc502d509c0so1553214a12.2
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 04:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791374168; x=1791978968; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZQ4iJQBmWrwwDO/BcGSbLFg2HWM5GD+53dVXLWaRIc=;
        b=gvsEZ9tOVdPQ1im69qr1l2Z90ixHr05o/aQJ4zdHUAsSRDMORoIgrfdXb57eTyr0Fl
         j/uCADh4XKy9b2Z/bN/hYgObfTGdk0PQUTt/pAs535XOqGHtUC3dxsUeNH/884tSmVOS
         1UgrktG9wE/lUHSbeKZqlVb6RX53prlGc0SX2/Fe7M6FTqkMMdDNe1RF+8cd3kfxZhlF
         brQlbe4Z1Pkee6NedwEUFD7HKV2qUzc540iKT60wPVOXrg5NXiKDxfLYD6WTGjvFpT8Z
         aF9+BniAlOIiRkOwqsfPgmvwHpMrO+kyT1mE6ZLo4xBD5ZptlYUykYeNrF3NTpl8M59B
         qOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374168; x=1791978968;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JZQ4iJQBmWrwwDO/BcGSbLFg2HWM5GD+53dVXLWaRIc=;
        b=dqWSWeFwRg0SgczwK53YS0JJ/c9MLQnCKy+icYzqh1tj+iLPP8z/SpFBPhCBbG7+yq
         SFFOZfTOM53IigZjfsqoXwisS8iWKdpmAk1+dSNvYAlx+l/bCWy96oFguRgZLk6Z1+rK
         wcaxbYjvkUO/v6fRdu7TorbETWfHm0vHdp9R6/C3no97yZbPKrio3dSw0O3+AaUVlT2e
         uAqtbV/r0yz0QCTQGGuqCxSzP7Fs6cIwUlkj+JFnAI2oDLDbWgMO0N8P5oOyG7Ep5d2z
         g/yY8YPAMUVMGq3JRc5eQ8A2nWY9648yk2WsJ81Zwtf59RqPBlLCNMYx9zJ1iZFnbOKS
         Rmog==
X-Forwarded-Encrypted: i=1; AKwUvBynbsOtU+b9LTmGuxQwYLHVRaY18/Y3d4OmQ5AqmMtI/yeA2cN/ZGSqs9gx9sNvXxkuVX2WQGtWF/Ba0g==@vger.kernel.org
X-Gm-Message-State: AFuF++k0D6tLaVZqS+BAqCWok0h/wExjr0bhAusfsv2XQ7NSCNvCsIWY
	Jgz8lhI5uxHjRWqwYUECYSis2+bZn42paD/ldo7d3v8hwL0xQ0Ru+0gWiWjrCHwI
X-Gm-Gg: AYBFou21u/juKFYVHl5seQ4IDAW5NLWc+bLn8ts1lZCzGj/1UCeM1agbgL7nz+X2kyg
	WKuvDFGy0jLUwy94ZJBLMlKMeo7Gxt8q91RHlbFNQ4qLg5hrmFsqplMRF3YVAPmEsomkaR8bl2z
	aZW5RlaWjV4CYyM3yXd1thy4EtShEew9KFLUHeUwNSH5PR9hp2TMXBz+An6tHz0dMKBJUDGZxFD
	ZsWgHkB57oAmwUwu+EIv2Ri9euqJxgdOoXo/9cJ0uduokYvZ//bTzuFlG4mgwht83N7msQPtFxL
	bMfFbj/i15MZEd/05r0aiJo6ulSuTTtL2yqjqQo9Ylu66o9VWmtXuIBuZ39ltKVotQJ2k+aOhfX
	HYMYOG9xZZsbVoaaPoXUL66NWPD138xe5KCGR3qjgtZfwkrGmZN3nrw62VyhfxfmHecy8g5ofrX
	SjDI4rpF54UC9zkRB5fveJ/r/UdGzh2UKvQvCyu0kK6yU9MUZYZYGktShloaa4L1mNj6NvyQn16
	uj4
X-Received: by 2002:a05:6a20:d48d:b0:3de:3f34:5df7 with SMTP id adf61e73a8af0-3e13401e7a7mr1775759637.12.1791374168216;
        Wed, 07 Oct 2026 04:56:08 -0700 (PDT)
Received: from user ([2405:201:c052:b00b:836d:b1f5:934e:51ea])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0aa36f1f2sm1240482a12.30.2026.10.07.04.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 04:56:07 -0700 (PDT)
Date: Wed, 7 Oct 2026 17:25:37 +0530
From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, mason@kernel.org, fdmanana@suse.com, shuah@kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Subject: Re: [PATCH] btrfs: fix use-after-free on quota enable allocation
 failure
Message-ID: <asYzOSJqJTgD5Yzp@user>
References: <20261007090656.20609-1-pavankumaryalagada@gmail.com>
 <4851139b-6cd0-4b1a-9a6e-1af947d49098@suse.com>
 <55739226-436a-42c3-a5fa-c699b01f819e@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55739226-436a-42c3-a5fa-c699b01f819e@suse.com>

On Wed, Oct 07, 2026 at 08:29:14PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/10/7 19:47, Qu Wenruo 写道:
> > 
> > 
> > 在 2026/10/7 19:36, pavankumaryalagada@gmail.com 写道:
> > > From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> > > 
> > > The quota root remains on the transaction's dirty root list when
> > > kzalloc_obj() fails and btrfs_quota_enable() releases it without
> > > aborting the transaction. Later add_root_to_dirty_list() then accesses
> > > the freed dirty_list, causing a slab-use-after-free.
> > > 
> > > Abort the transaction on allocation failure to clean up the dirty
> > > root before releasing the quota root.
> > > 
> > > Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=947286c775f432b073a8
> > > Fixes: 8d54518b5e52 ("btrfs: qgroup: pre-allocate btrfs_qgroup to
> > > reduce GFP_ATOMIC usage")
> > > Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> > 
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> My bad, Sashiko exposed a valid but very rare race that the temporary
> quota_root can be added to fs_info->dirty_cowonly_roots list.
> 
> This requires enough subvolumes to make quota_root to be higher than level 0
> in the first place, which is not common but definitely possible.
> 
> Although all readers of fs_info->dirty_cowonly_roots won't be reached after
> the transaction is aborted, there is still a very small window that another
> thread is already holding a trans handler just after the transaction is
> aborted and the quota root is freed.
> 
> In that case the other thread may access the already freed quota_root
> through fs_info->dirty_cowonly_roots->next.
> 
> I'm afraid we need to call list_del(&quota_root->dirty_list) with proper
> trans_lock hold during error handling.

Thanks, Qu. I understand.

I'll update the error handling to remove quota_root->dirty_list under trans_lock
before dropping the quota root reference, based on the latest for-next. I'll send v2.

Thanks,
Pavan

> > 
> > > ---
> > >   fs/btrfs/qgroup.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > > index f68b696b4bf7..42be06675c90 100644
> > > --- a/fs/btrfs/qgroup.c
> > > +++ b/fs/btrfs/qgroup.c
> > > @@ -1204,6 +1204,7 @@ int btrfs_quota_enable(struct btrfs_fs_info
> > > *fs_info,
> > >       prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
> > >       if (!prealloc) {
> > >           ret = -ENOMEM;
> > > +        btrfs_abort_transaction(trans, ret);
> > >           goto out_free_path;
> > >       }
> > >       qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
> > 
> 
