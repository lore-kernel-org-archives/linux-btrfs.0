Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254934;
	b=ARy3/GEsd7te7NHamol43dfvCAjL9kwI/ccZQ64GnRVE35I8XHbX36sbw1tgC612zCcx
	 /Oc/Fd3RP2GTL0kwWhlmqmM7oS/lxdl/46OWFuRjcqCNoNtJYzUJJUF/8yS34IK9Ia3k0
	 yr43W62RPc1y6TuR7CYCu4uVrKeh369C8/3fwxyvC3k5lO3WR4I0EhQNjJsX3WFIJ+sIs
	 v2V9pzhj0KVkiI6YJF6dooKPMV6w5rkX9VxVQNJEXeWgCk1Q54CbuHivFE3++VlnGrTft
	 zQuR3nU5PUhH0iK5Br822i1JsuqsC5qZx2/B9/E6QhfBGgslK4Gxxog6TRMQ8CuO2iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254934;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gWJcolm1R8XlWxzgfe2s9+oiZQqztKVaDr6hNscL8XU=;
	b=1gzBjGBvrXPIlvJg2CHR6n1J8+bWddfE1WD+AoT3ULjF8LRjKqsiCkjYaDZp2Gi0U6A7
	 8m9e0BJWFwg/vNkCH+NNOH475Rv9wLwDIUTR2/X3VI32DZ9pyoV91NiVO2NFKYhIprPdn
	 kKwZZaefboz0OxzIwA6cJmwD3QLx9e46qLCF5qenB4ppOdhUgy0G6CrAUWnWdklewKSQX
	 N5Tc0qnIOhV0XMovZFqQVQzZAvoPcF3r3ZM8CybMGKGT6R4VN640PGDBHQSL1NKs/txXP
	 3iInUAJHYCjdcrKwxKzXlhQ0Y5bv7AYZvDxF1rPLs+zbvJtJ/ho0kK+kUvyiZXUfnhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S7CjgRWG;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3808A606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 06:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3808A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S7CjgRWG
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ccce6d9abfeso1289341a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 23:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793254933; x=1793859733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gWJcolm1R8XlWxzgfe2s9+oiZQqztKVaDr6hNscL8XU=;
        b=S7CjgRWGtlwRQf43BB2JWjHDHzHwLPymF1z/Ij/m/OOUM4SdFreDFfTZCT6U6oAHxS
         sNLQu/InsYwGsgEtCbzri9ToFtyk/+mhZxp0yKpQUthQwwrwrie6QaOtuGUGtGOP7lUQ
         oilrJTeMQI5TIxbM2Rz86925Z8MN+joT1HIeiLMwdR1cd2XjZUlFYK9lu7O/4LYPGpQV
         xSumzbgqHglQLtSms4X3bBs0Fv7Z1i0W//yfn3efIjlwP9Lt5n9nEdtOpdUviaE2d8mH
         jgk8CzpDehXv6jsCcPwQLd/vcyUmGDKS9JbIzEmDjFrowx//7Co6j15UowYMUfQL2PPj
         CH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254933; x=1793859733;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gWJcolm1R8XlWxzgfe2s9+oiZQqztKVaDr6hNscL8XU=;
        b=UFpgXphnrl7csy/eP8kwKSRMZ3LqzBxIInvlya2eBYkmTjLNRS7qIpvqsBhAdlxPHl
         26m2+Ommm1YLoXReQ9q+BuuFdoryfEs9UNwoZvlrmvUMYXbEte3d9TIH1hFDsuObViVm
         hPeqIG9p+NOxlJ46C/BmDUth5xtaum55LEtX7M293bhCmlc28o2EWNui0ZkcIlCtZmoi
         nuEsaYYYApjlPMBRqU3bqnw+j0GD3t4A9VW6NZDG6yO1x9vNYOAbhz9XqhgZ+vnCzzOG
         8z03Wt1Uvb2eiZq3I3PIhtXf07AKPG2sqLCLt//qq99zQOgp6rLze2GeymmCMj9YrcFF
         eong==
X-Forwarded-Encrypted: i=1; AKwUvBzkZIMHspMNVznvmjT5bKvKnLjTQgBfxtm4RcF1ixzjyZId2+NIKeIuShkihXdWXhpy5LUsAv+RvXeR4A==@vger.kernel.org
X-Gm-Message-State: AFq9FYKXKd3EP8XK3rlmNV4RQWcaDuIPT/Re6PnGNl5xWrKMhed3aHwJ
	Bg0hkC0lLZU+oeJkHj5aiBx38uoGsekCVrD5hW5x5SWXrzfZZoT7VdADS31J4Let
X-Gm-Gg: AYBFou3Jua6qmSs6sIRiDsJvsv1MwhUYFHbc3i7qYN9RWDdqUJNbiVtOKfHMmaSg27V
	IpafbHiaZ1WX+MmMWpACylf8b6vguxG456CIy55iHrQ3Q98JZOgK20x47emmx13sA+rNUV2aDSC
	PSkDdGJKYzPvSmUWxNLaTVd6HjnMxPGd8UeIfzKY4IvtYY0xNlJdvtPUuRuAz2aepnLKbzgM1Ss
	AoqtIxWO7DTATwQWclnlOZXhpszG6mblbjWnWUx1+hoOAc6lPkwKYsQHs3i7imzSwfphAES+EN3
	qTJBf+Ut8Iz9QJ/Jr9XjFkl43Kti9fTBFMc2kVFOOg3F5DarWHX/6zcdzj41j5vCao+9k9x0Tro
	lmroNUYQa54xd0roDD6kBUIo+YbFM6q7j0UpqCyM9L3LtcVgab1AQY7zsLay4uLslPkgMwH7gx3
	DuEoCOqPIGAosOm8FGXUdc8RGRqK+zkVb+dTRXyM6rovjb/+AdCF1MwIaQw1t1zVu5RjFnB8KX4
	I2exfklTaT3N9HSxqRI54d29ZAssEOOzUZHCNDAyNg2MzW5HwizWzImyZzb6Qs1u5zA9hMxuZQq
	c4v/esjf5zEykg54e4aFwjRER875P9QPxmznIRqdFFvQLGao6rY=
X-Received: by 2002:a05:6a20:db8e:b0:3e0:b445:5612 with SMTP id adf61e73a8af0-3e902329a47mr3897989637.14.1793254933446;
        Wed, 28 Oct 2026 23:22:13 -0700 (PDT)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8cccbaaa9sm4759253a12.23.2026.10.28.23.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:22:13 -0700 (PDT)
From: Qing Zhang <diasyzhangqing@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: set the block size before starting a transaction
Date: Thu, 29 Oct 2026 14:22:07 +0800
Message-ID: <20261029062207.652772-1-diasyzhangqing@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <d7a63c1c-f178-4879-ae42-39e9e088b9dc@gmx.com>
References: <20261028121458.23499-1-diasyzhangqing@gmail.com> <d7a63c1c-f178-4879-ae42-39e9e088b9dc@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

在 2026/10/29 06:55, Qu Wenruo 写道:
> 在 2026/10/28 22:44, Qing Zhang 写道:
> > From: Qing Zhang <diasyzhang@tencent.com>
> >
> > When adding a device, btrfs_init_new_device() calls set_blocksize()
> > with a transaction handle held. If the block size changes, this takes
> > the bdev inode's i_rwsem and triggers a lockdep dependency cycle:
> >
> >    bdev i_rwsem -> mmap_lock -> trans_num_writers
> >                -> trans_num_extwriters -> bdev i_rwsem
> >
> > The buffered read path nests mmap_lock under the bdev i_rwsem, while
> > mmapping a btrfs file can join a transaction through atime updates.
> > Since commit c0e473a0d226 ("block: fix race between set_blocksize and
> > read paths"), set_blocksize() takes the bdev inode's i_rwsem when
> > changing the block size.
> >
> > Move set_blocksize() before btrfs_start_transaction() to break the
> > cycle. Also check its return value to reject devices whose logical
> > block size exceeds BTRFS_BDEV_BLOCKSIZE.
> >
> > Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
> > Reported-by: syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=5c01398781fb51df783a
>
> There is already a better solution by not calling the stupid
> ste_blocksize() at all:
>
> https://lore.kernel.org/linux-btrfs/3d98566e8aa2cd99a23ce89665f79281c614f05e.1792885061.git.wqu@suse.com/

Thanks, agreed: removing the call breaks the cycle at the source.

> > Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
> > ---
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> >   fs/btrfs/volumes.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index d3e6a9b429dd..a7f0607a5b86 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -3019,6 +3019,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
> >   	if (ret)
> >   		goto error_free_device;
> >
> > +	ret = set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
> > +	if (ret)
> > +		goto error_free_zone;
> > +
> >   	trans = btrfs_start_transaction(root, 0);
> >   	if (IS_ERR(trans)) {
> >   		ret = PTR_ERR(trans);
> > @@ -3043,7 +3047,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
> >   	 */
> >   	atomic_inc(&device->dev_stats_ccnt);
> >   	device->dev_stats_valid = 1;
> > -	set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
> >
> >   	if (seeding_dev) {
> >   		/* GFP_KERNEL allocation must not be under device_list_mutex */
