Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793677801;
	b=u6n/5N/OoYpeciDlO1e06q/oljMNQGiOUQTxjhRyrzNDYitB9BVSx8iPyCEHGJAwstBQ
	 sBKPJkpnqYRhMtjfh/YCRKUpH9dygO3dwuqrUrb27g86gDdwf280E6s0gEZjCg0/vruMv
	 8Mk1DwWw5QZ7MdoiqT+R+VBnqrKv9g1iyKsESx0U9dTLHi//f4ZsHyFmh55sDWaXdbsxz
	 FlllJ8NBDC+INhHcdT0S7nmui6DTK0xdYIzhCmyCtjtpoQvd8yNicX1359h0vpueekS8E
	 ATdawFR7mCgA8+km80dYHJVx4VxFHybfE1INtmRQex0uy/jWYlzsKA5p33EIMylePEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793677801;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WwN7oTt+Frc9xSRiyvCe82KmUH+lH7uYQeHbdcghhHk=;
	b=ABmZCf6Ogrwgz+iZ1aQ1P9sGazQLOjJpIw26jiyBRMRM1ORkAD23TbXC7G8PJAdhG9ao
	 VmS8JgJZbPOT4YVN2u7ARWQyVJjp47WX6S55uiP5fMUpVmr9MIWmbH1GucuM+vPhpSc0S
	 W86hXe1kkdGPqEh+KyT9vqOoCCPi6APWabsKCN34O7Y6CHY+ZIyYoYiEJVOWxgF6gM628
	 Bes4lGfdLdVnFFrTnzS4Mio3MuufAlpEcZa8Nxxqxq/M4x6oeArC+iJFlytmYc9yoIOpb
	 3i89WLmDIsDmGi9Ov7VqxFhbJcghxBc4OnuFD/xnxdan6ryO6vrN2HV+OmyrCP5GKyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=WFxQXFZM;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E67606A324
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 03:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52E67606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=WFxQXFZM
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5366ae57896so45061651cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 19:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793677799; x=1794282599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwN7oTt+Frc9xSRiyvCe82KmUH+lH7uYQeHbdcghhHk=;
        b=WFxQXFZMKejQcVbsQryiZ28kiEli4eCrQ2u8YBLUucNRK9b7sacW0xbIhYsk/ToK8m
         /Bkl6rtQHDzhNvWGUOHh8UQ5TrAR6LZFcqNVKA83w9v1fimnE+RkHTvNAgGlinG+TaWh
         ko8FGmDrTF8fVKn3wgXaKXslzt5+XLPhl/1NFeRDPg5uc/xucCGpk0QmZvYk9/RnGXlu
         wA2IYmMmJZQdQBkKp9MXpaOAzqs7thKrZ6U3GzYxVituhWbMaqcTqCEFjhCC1aOqcmEu
         4BQYkeFgzoZQQD6sFXKNZKqdG2NVPmOgoarGgQHdbcj+PLbIRFMZTuSjPwYSoPTlC3no
         UDhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793677799; x=1794282599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwN7oTt+Frc9xSRiyvCe82KmUH+lH7uYQeHbdcghhHk=;
        b=x94PBG0nnqNqhtCTqESBVyIBB9o/63Zm7iKLc8Eb7S24ysvcA+p+SpvAOWrXbqgY1d
         XB2UnxtdopunOjgz9tRCn20bqcR5uj2W04YMwlgacFK9+HHakh6z7HlDf3fS/HoxUrih
         PsLGkw3NHnpv+91ZQLmVPwkbLABK52X/Z+FHuvL+wOYuK6m45o5kbR+ltz2m6ScUDJwc
         8yd577i5000ibjBYDoPgy/4AYl++b+eu7OJdxT2oRtvi+XOlsR9FINx3zql5799LpEVN
         wxA3OhpyOc1NsyB1Ygv184/Yud/Bv5qYQp8iv6xgMMtbrjocY/4spCTrvvJ36BD1ezWZ
         Y8UQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOwOxc71cmRl7SxPZfq+9gWmALS1iQdYC9UzgiFWz9eRjab3sZGQ/4guviR7uShE3dZH+XKY1dMdlySQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIZNSMyfM1tAStyEFQeJ4RopG83as5cCef3l4H/8ZzVUUqPoxmp
	jOtxfvz3iybKjfEy19F6Duiv0YSwc2yhgfP//oaBHijBJggn09U30SkM3QcD0p93YQ==
X-Gm-Gg: AYBFou0ZOmt8q213hQ20qVsQqK6hMY92r2ryczsbQsWHbaVlr8SK+5qswuRE69FPaei
	Qo9WXOy3/EniNOEEWFrP5jNbis6P/n2+ZO77hdK6R8rbYKcA7oDjZBwaMQRbSmKZapt1m+Vp5jE
	bp3ZGeVAmEHT+2U5VPITvkiIA3FbLhMPr007Gb+q8FAjjk9ClLZFBCOcnmZ3kqKdoEhLXY6nSsX
	FrbJgUTZ75mQSsbgIvAY2yqvWoHli4HfNQdtT42P0xFle5t/R7i2+bZE4W1Iaq1rZunrj0kZNT5
	PBXo4yKc95bScmwLimsqcqz7ILmTIzoRwAQuz9byvxNDhU2iuo6vWfGxdaZOiHaCb/qaLVm26vQ
	bmrCDaATwmrseGusAaqR2VNCNS6OSSrNrG1Jp1GRqWyotnWlSYvv1QZWdC91cZQ7FWiTJNUi5y3
	xkzMvawBMR8w2/kDFqF00+1T1Y/MswhI5SHFOhLHxO1zciCrMMchcGEYzABG3rzxiCgyj8K4mqy
	Ktdp/YHQ5ilJhPc4L2CuYZeLdtsxc6FRdxs4irK4KYQeTRHBaojJp0FlvQXIhUshFeXYVo63Sy5
	ulIQSxhyl6whDS1IHUSJn9WfQzZ+hN1X6YPg
X-Received: by 2002:a05:622a:a15:b0:536:3463:88d2 with SMTP id d75a77b69052e-542b6a72b11mr198323311cf.22.1793677799065;
        Mon, 02 Nov 2026 19:49:59 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7e2342asm105461276d6.5.2026.11.02.19.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:49:58 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>
Subject: [PATCH 0/2] btrfs: tree-checker: reject simple quota metadata without SIMPLE_QUOTA
Date: Mon,  2 Nov 2026 20:49:30 -0700
Message-ID: <20261103034932.1790235-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
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

Simple quotas put two types of metadata on the disk : the status item
with SIMPLE_MODE, and the owner ref in an extent item.  These two types
are correct only when the super block has the SIMPLE_QUOTA bit.  Several
functions ASSERT() this rule.  The tree-checker does not enforce it :

- The tree-checker does not examine the status item.  A status item
  with SIMPLE_MODE and no SIMPLE_QUOTA bit causes a BUG at mount, in
  qgroup_read_enable_gen().  Patch 1 adds a check.

- For an owner ref without the SIMPLE_QUOTA bit, check_extent_item()
  gives a WARN_ON() and accepts the leaf.  When btrfs frees the extent,
  btrfs_get_extent_inline_ref_type() causes a BUG.  Patch 2 rejects the
  leaf.  syzbot found both symptoms in 2024, without a reproducer.

Two sources can put these states on a disk : a damaged or crafted
image, and a power failure just after simple quotas were enabled on a
kernel without commit f2363e6fcc79 ("btrfs: fix transaction atomicity
bug when enabling simple quotas").

I reproduced both problems with crafted images on for-next.  With the
patches, the tree-checker rejects the bad leaf.  With patch 1, btrfs
then mounts the filesystem without quotas.  With patch 2, the mount
fails.  A clean simple quota filesystem still mounts, writes data, frees
extents and mounts again.

Siddharth Mishra (2):
  btrfs: tree-checker: validate qgroup status item
  btrfs: tree-checker: reject extent owner ref without simple quota

 fs/btrfs/tree-checker.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)


base-commit: d6f76ca0a70d0c814731394a625ff0dc1feb390e
-- 
2.54.0

