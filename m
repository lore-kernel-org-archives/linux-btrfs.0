Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822214;
	b=5plfna+XrPB/+MGUelyeW++qEFrATIej+2hiDc9VXzMrXUOflp70B1TPJEXwQaugTxho
	 oxQ1mLcKS0E7vl9S32YlJWesZHnTeraGoBQhUbBKvHiZrhetEbS39TAq5VVSJj/h7DzPz
	 m83OFLxZB07BvXjRWr6mx0TUuXuRzDZoDfXu737Pr8agp6uhEzbMgiFM3JKHkmQH3oxaI
	 Z44vOiyFB5KEd9DLqxRwXKfn3V2ay0eTG3r0j69uztv1VCbst8TAjo4E54KKLdMVQJ162
	 Ib9FFiGoAC/r2a5NrsonlNJgQ+0y9BD6f4M5zwkC08hA+YkNbyQ6WOOao5mH7XTm1Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrKa+VT265YSl+/JqzQSpxcCcwhP8N6auXFpJdA3IgM=;
	b=KD3V61syQ+2vZk1eG+CjqUQoUyUloIX7K3AVRPEwUdTPaxBlzvY1wkFv8nT3Ma3Y5V+u
	 PxbCRxsMNMmbJQrCLT5TQnzGMmdngclqD89jO2EdVYKHqKmZnkicISVOVtCMOkxVBPG06
	 pXMYaV67QY/CO+Q6rC2FhAjjtZj/Ue6IC2dblZ19wvz08DMN3rxa06WsJCZDSL2Brvabu
	 7DtsqUdkGCn6ixBKqk0l6a0nE2bLoqX5Kt3UTNTqmaEdUskXnBHgeXB7DYrGSRvl2Qdpc
	 fvRRSHow6WKiclMHwahVXnGWtl44w2sF7z5dX9sOyQoIprH22OxIjGnPFo1PE2oa1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=N53fQ7A6;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01EC60E7530
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A01EC60E7530
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=N53fQ7A6
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2476493eec.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 11:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793822213; x=1794427013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xrKa+VT265YSl+/JqzQSpxcCcwhP8N6auXFpJdA3IgM=;
        b=N53fQ7A6j6zDRf1HvGp2eiK1RyXqfnJynb0VUYXAeNZPhy2b8b5Yt/eQ4IMJWvBHuO
         rPZSTNLo7fdbmdrIaxiUSLddCNXIQa4oLPJVeOIrdklDjmQAVduoWyS3ktQ0jD0i7pBC
         rLvloDK1qSYvrAJbiVhgy8SMLD0alUNQbJg5KwfpDQfPbqt+49CbyYzlznWqs8Md/8Dk
         PBOUx4RQSdCIBT4Vk0Y2q5cW8imS44umvk9MPlj6ISED8H84yKayQr+glentQgUPN75L
         A3WncJrdc3t+z0fkgRFGu5smxposAYN9RQy7ZF0KPS2gDwLGc+f87PqBfK/Wk9cW2h6p
         UZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793822213; x=1794427013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xrKa+VT265YSl+/JqzQSpxcCcwhP8N6auXFpJdA3IgM=;
        b=lXO43UatWddezoGfPmI1eJHf1mXRl0fxnz+OWN+vdsKUGJAvqB4y5vEK9bLMmpmk/I
         Qo2+1mCez34Gn7CIQ4qy/2k+XBjAy9jMvkRThEXzKQ9W+Q8S5pm4BRDwnw7R4fpBfDsk
         9ZPyA0dtCz/GFWxmosaWwmXgHriFciHhp3nrF7Hu0gnnZkzJ6Q4jZqyIIVzhn5j34KoI
         OxO/fyF0DSZcLoUGO9hjx7hV9uoc5s768TDo2oKjxpQOUa48klVp3ZXc3LGyQDDnMsFU
         r0MFm3Qx7WSX9Upk/YONCX8JkYdxGFyXuOkZw2RwFQVxYOIbr0DjLHVCAE8+WF/XZGGt
         hPXQ==
X-Forwarded-Encrypted: i=1; AKwUvBz9r5p/4ZmaJPSHGMTPH8DXsoGawg/qirnSz/K8zxBzgcb4sO4U/yi12Z4JnTle3OUg48W7B/KXyLvKZw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+o8GmV5y5F5bRj65+QdSlD0M7OFEUIv1f5mw9FnLJ49luF285E
	1Fg0HKCXl5TUVFocM2qAgYDMQ1wzHhs4xrYrr92z5S7XYh++4K9TVDaWD6JXc+wrAw==
X-Gm-Gg: AYBFou2hYcstLpO0eFT0QWYQQYfvSvYOft8gsXOCqdv4kSpX0G/ZhbAVPNvnbgEB45S
	pYZc8uAZCLyV4VeLxf8T4byae+YyApeRrP/51z7ZFIU+sXCOhAUlrHfTAJQOdcL4p8JD2fS9w5f
	6VtrkTxRqn1z4gcYb3O6JrqbH6eEympzInsBXxWcVmTvHjVYeZAHtlSctWSEuMHO2DI9hwEL+z+
	9TofYSXNhPSPSHKkrY3zKcDF4f4u1rB9UU9wvC2Un5P7ublrQbjXS6p6LXU8NORPgTc5EY/bIWF
	CSMMXeAZLzZyhEtEBL+Jgy/4Uq0HuEjlbWe8HEDbI5oOTg+YHtJbYYvAcaO1eFkIUdexUFExgh2
	KQyn8m3KqY6qwR9r1LZ2/o0k1Sf0awGjGwcfyIGVcsE7J7PlhSE77oIXaxu8dRAtJTRR5ybYTMk
	eNZVZo2eA9UYW+kemZhL1stwgt2GWgEOiFHDg3TmKbX4sDj+viSEOV6Y/VUZgNOdXJAg0I8wdzy
	XhhW3lO6FDAnoouFJBgmsV29yRNi5S1Z31LPbCjX9kNiPN7P3FN2DgIlD85Zp4n7fyAky6AKryF
	v88ZGDWwUR7kHbVqA43G1ap3dUuZWq0OcbDU
X-Received: by 2002:a05:693c:8806:10b0:369:f97f:72c1 with SMTP id 5a478bee46e88-36a4241bbd5mr26449643eec.36.1793822212586;
        Wed, 04 Nov 2026 11:56:52 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.89])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38fe477sm8703069eec.17.2026.11.04.11.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 11:56:51 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: Boris Burkov <boris@bur.io>
Cc: dsterba@suse.com,
	wqu@suse.com,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: tree-checker: reject inline refs not matching the extent type
Date: Wed,  4 Nov 2026 12:56:49 -0700
Message-ID: <20261104195649.2422485-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104192415.GD3301639@zen.localdomain>
References: <20261104102323.4090290-1-smish149@asu.edu> <20261104102323.4090290-3-smish149@asu.edu> <20261104192415.GD3301639@zen.localdomain>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 11:24:15AM -0800, Boris Burkov wrote:
> > 	item 9 key (30478336 METADATA_ITEM 0) itemoff 3636 itemsize 33
> > 		refs 1 gen 13 flags TREE_BLOCK
> > 		tree block skinny level 0
> > 		(172 0x5) extent owner root 5
> > 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
>
> I assume this was crafted manually, not via btrfs operations with
> squotas enabled, right?

Right, it is a corrupted image found by fuzzing. I did not find a way
to get an owner ref on a tree block with normal operations, the kernel
only adds owner refs to data extents.

Thanks for the review.
