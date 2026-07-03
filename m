Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A286233721
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043279; cv=pass; b=NMydS8x3AA0wa/7EtUsH2347jZ4FhfZaozUpjSsUz621zlLHszmvBZShmKdkuWLb4R+1UZ2aGeoQ8Er/e1yPkfgOMooB3eoUKFJDcENzmrrOfIatngssJOYTpZJ4TsRAMJ/02GxumCeCzoouOp9m446REh/hpxT97B+JJZJbNhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043279; c=relaxed/simple;
	bh=JLtvplRuOrV1XCd+vmBKYGpvhguS1Ynr34OsxGcjbOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E0FwJm9j3Lkp5f/hG9sTtF9aDEdpoGMKjREidj9ViGqOdoSUbG13kzokIweqquD57m9xxn21VZdLuDEbvd5myiWOzqyONjQpsQKoNhaffO4PqfLpi7ADyp3D9uHGpjSpj5GuDsKdXA8Q03ENuOAy6TfMwX2VRQAa5vzqG3kpqfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dufoFZFh; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dufoFZFh"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4720f3bf164so577889f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 18:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783043277; cv=none;
        d=google.com; s=arc-20260327;
        b=mVPOpyw9qCbtFlzuj/UDOCiz5gSUi+GeUjx/yxqat2FyuYNB89K1Vk5T3O3P0ACGNd
         hY2FP5t78/t7K7vk4oFFzdqz1eLYGp8Baqk+YWlFKwr9QsTFKpXaQ68IF7zhRMU8YNTL
         TtIWjmBx1p9BBsAIttixfUZllD80LZSCYGJtsyZim2l3pbnEcFlHHKT7wDEBI3Loa/5a
         6EQewOExg9lR24wwvFgalefvK9E5JXBk718uN8yqqoETNnrDzyuRY2iyhDlYWbejftnO
         ArIjC9/kQxFpGVJcpG0LkX3vkvTypWlS18Hmq8xOSPbKP7All88OgdIvyKmkQ/Ph88lb
         LZvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        fh=FqlUclzCk4JZrpQkouGbKoYJjkmxvG+PA7z0F3+D1aY=;
        b=CECposENlIRcGgzGdEwyqtv4UdHPMEcS2M5IrOcZQVh3I2OEiCobGl8hu/+NR0tAPN
         vtdDn844dvfOeZpz+ubayf0A+TWSzCf6B0hz02fc0pOfo1GRxPLdckrzA3jWo7FPkSfU
         P0ZDURLH+E3IBruzQjqETw3N2vM+jklmUfUkLxF78HSb+gVnF1u57W4LxGzBFTqa1fIS
         cbZoF8oMzslgQ9oLid/B5qA5wiC5TWJb5jG0IrDzar+7XBcen22Jwng4RyD3icyr+fNr
         m9e54035OfXYsJB9BHhJaALET1regGbWdma2lug5MZ6VqE4VRo17Tu+UQXdWyK2+mdp5
         kSqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783043277; x=1783648077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=dufoFZFhKQJbHC9rHylIz0aof78rVCYT3QUD5mRkGhy2l7H+cJFcrmx0ybWXWVb0Bz
         lrW7QlHAltzBw+kvMLizK0YEHAsZoyWS0+XBAoIi5xhndr82fJHS0BTO14xA2bp0pF09
         V9ZauT/73+0QwIKwA8dZRxz7vTpOQodLMGz6+b6JtbzgHZWnE4U3ZSPxEiq9b/IPAP61
         XgxOaQaSXfFyC+6XiKajOM6iaFL3E6uuC8U+Vp4QxuvemfkTSW28CH+qwU8M2vcSQlbp
         EcQ0Cc6bpR44VXn7DnhTNgPmvFIcLFMk2xzoNdLcWJ+zRAytywpl/r3mFm9GN/af3ipm
         Fn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783043277; x=1783648077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=nN2NpFaOETBURievs8T/TxwtCxrx1AzlOId1UeiLM02uuNhm/dI5QC25Z5F/RFpX9X
         /7A1c0vMRlZCScMaNu5qMDJVayDc6ucUMxD/rQp9RmGzLPAZkN9yCg00zVp8W0uMVjxa
         BD4G5dVa/1n4HZnPqqE3/xDZQS+pfMyLpNXqO4J14FYGTUfLUMx8S3fzqKNrsTAFcJHv
         D9tH4CxEKa2kkp5gTiVwUaeCrFwri9rBh3WcdM0saKbUOZhZbXMa76j0eYdZ8hEJZXeb
         AVW6cvFk1x99kXry1t1JepxsvazWy7GWWThdDN7yHHh3lZsF3LDHdnWFmu5GZej3S3WO
         DJAQ==
X-Forwarded-Encrypted: i=1; AHgh+RpY5YaDfoZihHovhva8J7r05esrIA6SUJUdYvj9oQNjKkdPBFq/RlbkVtcWRZd9jljRFqRiIqb2TzT44A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgM8TD/jt7kyTNyMxAv356Ks6gLBliLqrbpKKDDWg+aGklWYKq
	dQHMC8imj4XwkADMsCAl4AibI2GSILKP2KbkSof7DdqULKsCfu3HdQQWBvCHnw42BgGsKC1wPRr
	HqwJDF00UvOJsSAmE06Ig2rmFCDBDak8=
X-Gm-Gg: AfdE7ckhPeKM5yPo3R6muPuNZeRpbE84EAmCLxt46CnmU5cdx+U9cpjA0NcqohAYyYG
	Boe4z+xO7OlY/2aGKCeQ531BUCZD8ya2SB5Jem0zf2MnJ69aQ6z8IZkypAXx/hU5+ddOoh5+1Uc
	ezuUIwKC95kCb91+skmKfZMlL+McDGD17QNtsy3kkT9X038uv/cjUjHizCp+dohAKpxK3uvh4Ku
	6K28IEpffnSaEUi1pkv0+HTJ0jmloq6NkvCyR8ENfmDuOrtuACyX8/BZUxg45iapDcD24nBYaxp
	UP3mG+PMCcLnZh/Ki284xfbqhxQCg3x8U9OoPurbHbqdmGGnOfxv
X-Received: by 2002:a05:6000:188a:b0:474:88ef:cdec with SMTP id
 ffacd0b85a97d-479347abc89mr3414307f8f.6.1783043276701; Thu, 02 Jul 2026
 18:47:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702140705.GE21339@lst.de>
 <20260702165117.GK9392@frogsfrogsfrogs>
In-Reply-To: <20260702165117.GK9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:47:43 -0700
X-Gm-Features: AVVi8CdwjVgCnc8OibEiAJiLFqrCHykAhTtcw0AOMmm18cQj3dSCo5Q-SEBvMhY
Message-ID: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:51=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > In terms of merge logistics, I wonder if we should delay this and
> > the previous patch to the next merge window so that we can minimize the
> > cross-subsystem merge pain with more file system iomap conversion.
> > If none of them actually happen until rc6 or so, orif  the merges aren'=
t
> > painful we could still pick them up late in the merge window.
>
> I'd say everything but this patch should go in during the merge window
> for 7.3, along with clear instructions to brauner/torvalds to expect
> this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> the other changes that come in.

Just to clarify, did you mean this patch and the previous one? If i'm
interpreting Christoph's concern correctly, I think he's worried about
other filesystems converting to iomap using the ->iomap_begin() /
->iomap_end() functions still? That sounds like a good plan to me, for
v3 I'll submit everything but this patch and the last one and then
submit these patches (and any cleanup ones that become necessary) to
Christian right before 7.3-rc1 gets tagged (which as I understand it,
is when the merge window is about to close).

Thanks,
Joanne
