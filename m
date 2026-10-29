Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274792;
	b=dnkOHIdc9npdN7aCphRF9ALhkjUk6aryvH779lxbuDq/UV3HdYoEyHXnY5ZBPFnBMKZy
	 bSmmYMvrU12fuZ2RoAq+W0+gNwxqPkj4VLu1MKd3ekPxA3OEpBOpl6v0pMOeza2aLshIC
	 SgjOgLHWWeJAscADHWnego7waxbJKgWbDeYFoz7Uo4L1YZl0tkBDQ7e+Y8DKwovHnPwdm
	 jDFijveP/xB9pOM92K19/5ic28yKCqLWFiyKaF0b9SV0pnCPu8FLncd9ToW8Bpey8wW0W
	 qGwTLVpTHIXWftHduehrpI0DQhPov6Wv9haut+3bEBmUgH7oeXM0CwlMhJgdHTSF4gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274792;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=jUwPwLLs3ItuEGtYWzom9wMw0uBhDScICxqoGDVoPms=;
	b=TiqMX62QCiaiyO4fSd5kQvnNQwDvj1gKT82UfNeuq13LJItmXfjUMOw/8G5Trv09hUGz
	 xBs8QSyrRgDXuGASG+zgAo/qu0c/MWOCvioSumoqDk9hutxUpOUa11mrWvTBhPrFrrjVT
	 t9ReZ8g8sMl9audRB7Q/7qpUOCKYYQyJJ44VSD/x798ru0T97RKHqn7Rd3jcDnYR6lXgG
	 V33ZRPYCoWlAa9XuGrW/eDiT0GWsmBudSJWwAN3aYf31/dNkD4kM5jS7pnHWGLQjOiP3R
	 j8VJRpJq90Ef8fF7YK7hkOi9iJHV96Qj+3eGxs6HpqyPL9tBhRDj5gkF3k9YasQOQRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RYU3cpo9;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAB606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 11:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FFAB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RYU3cpo9
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c49c32650adso229977766b.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 04:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793274791; x=1793879591; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jUwPwLLs3ItuEGtYWzom9wMw0uBhDScICxqoGDVoPms=;
        b=RYU3cpo9DciUFn6VpBMgihzLJDxrpN41WV68WkmYn6mVv/24wdMR5DdenFLdICeb0U
         rH08VGFDuUTfC+/dga2oBEcjdnuOSLsAWhQ5T2aA7EuIT48ChDX1jsQudCRi1B8quKgW
         2X8xd6Ugr+sVQ8EKQ6dBGexbbkxWKVXqeHnAWSFg9xCf1JE28o/EZVSyvZ3icSYESfhK
         YUk0WhiK3akB7KYllTWmbWLmG2RwoU7vmVLUeI4aeW0eSrPGM4Cm16cn9iCAfvKAF9Ci
         8vgsAL53gRinaQkTmrAyNdPVU7LGBEnWhs/8NrRkwQJGYvs0N+FtHPKUAv8JMuWWUUsn
         2NFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793274791; x=1793879591;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jUwPwLLs3ItuEGtYWzom9wMw0uBhDScICxqoGDVoPms=;
        b=gIvtgzBO/YTPsNa1clCEJM46ZVlbSNCkAXVbh8chtOrY5f22+F83hO9kDtbQf6VL2F
         pkwFmVwMCfzj7Q2p5l6kvhlFfX2MCov872J7yxqnJKm9/zAGYeWY0Ub3EUemvJzP5sSV
         lOov+1n1eF1PTfkHN+G3LMYmS/t+b7/0eLsvScFkbq7KbDEQWPUQdB2Qpnmfi3ICg5+L
         ECGYMYZHNsMLLghj2fdVU86O7cRjK7hNafciB7IzzagELg5kbZcTiTYeNakKw6S/Fi4K
         B8ITLDIoi35CfckDhlXfTtQWO3n8MxQDjEIkdeGzOJ96QdGcwkxvVzXmhjI94223M+eg
         RhHA==
X-Forwarded-Encrypted: i=1; AKwUvBzOcKxnu206aUsHPcbXzeV8TYNfLnQfgO9HsGLYQ7fx7Ogeh4Nv1V3c1ZVaIvAs+PkDInw65OwsAGv0lQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKmM+TiO7Bc3H1HpPyzwM4eIgcuLxjcFtGIb4Unqi7bsnhkLUkB
	ABAR+EG5OrHr1sy4X2Su2+R1m14YD2ouh0cTx64lDyJDBI8TKVSbUmnG
X-Gm-Gg: AYBFou1IqRAF4DFYkq67taCbQBPC1Sgs89z1OytJXTWEEfKVCZ8EYfBXP4wfm8t9IRu
	oCFb+7f8ve7u+aM/y25KkjFr/6XgtfwkN/nBSGnIWXElpfgHuvKbZedgOr9fyE8XMMKSr6bz2Uh
	17GEw7JaIHC8i6Ur2CKQHTngYBEr82hJa28VuRR0p8JPJEt2rbOg3mI1UnlR3oNGZ1TgIzDxFtQ
	tOIl/xkGi4JXK4x6GsSnUhnbVgJb1HI7oCGTso6TPugUpXFcUyrFqrjQpMYznTaEIjgqwAhU2ub
	Ep5ZoBXLp88tT9j0aepLrEoGD8F6GUKgQadXigMzLqf5r45oW14QSD3bwwHsD9LKez9bYM5mE6y
	vd+RhWkh/sI1DuHPZ+xYs0+OPSJIBn8amrJBoWMBaIKGkFa3aJrqT5/7AniDuxK6hz6M/42MUtq
	TwZpivsXlQMXgkK0SYQBrNZURIRj8t0pn6UH4eqWy+I/Oast4OoHFGD9kpNVDsmenFbfa8D1i3q
	89dEWEqb5FLvlJjlYD+JffuRR9Stq2ZNltlZvPXBc/QwYV9KyBCuL7aG4XVGXyn2d4UL1jF+aUn
	0EVk23qMvAbv7Tym/1R97maczoeCoHAagbmlF8Mb9k4X236WUE8KyCBGLHBZcYkx1nR42PPt0FU
	fLwZ+2kulkww=
X-Received: by 2002:a17:906:9f86:b0:c40:80eb:c541 with SMTP id a640c23a62f3a-c49bdd7e2admr460193066b.2.1793274790899;
        Thu, 29 Oct 2026 04:53:10 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd34f465sm721068766b.8.2026.10.29.04.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 04:53:10 -0700 (PDT)
Date: Thu, 29 Oct 2026 12:53:09 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] vfs: add provenance time (ptime)
Message-ID: <auMzpUIEmGCE_x_N@amir-ThinkPad-T480>
References: <20261028134728.294127-1-koray.fra@gmail.com>
 <20261028134728.294127-2-koray.fra@gmail.com>
 <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net>

On Wed, Oct 28, 2026 at 02:56:39PM +0000, Pedro Falcato wrote:
> On Wed, Oct 28, 2026 at 02:47:27PM +0100, koraynilay wrote:
> > Add provenance time (ptime), indicating the time when a file or
> > directory was created. This is user-settable via file_setattr() and
> > retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> > 
> > The semantics of when to preserve this new timestamp are the same as
> > mtime, the idea being that there is a correspondence like this:
> > 
> > ctime <-> btime
> > mtime <-> ptime
> > 
> > so every operation (copying, moving, ...) that currently preserves mtime
> > should also preserve ptime.
> > 
> > Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> > FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> > xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> > allow ptime to be used with the file_setattr()/file_getattr() syscalls.
> 
> Random comment, but: could this be doable with xattrs instead? I'm not sure
> where I would put the xattrs code (if in userspace exclusively, or if hooking
> the VFS up with this, or if doing it on the filesystem side), but it would
> surely be less disruptive than modifying a bunch of filesystems one-by-one.
> 
> This patch is quite simple, but changing btrfs, then ext4, xfs, etc is a
> mess, and inevitably you can't get these timestamps until you upgrade your
> filesystems.
> 

I disagree.

I think that creation time should be a first class property in
filesystems that support it.

Thanks,
Amir.
