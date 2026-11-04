Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793819005;
	b=ItOUx1oM7Ua8Vjoadxt9izUr6mjX8eR2T5Eq302FgN+YNNAdeAA1bwpHTVH+vLIWz6WD
	 vGYDKbYWyE5nPMaO8cuimc90SVenmh9r5XA6oFEgJ7irMsBcKfrWubt41EFcmaMZI95yd
	 OKsA4Yx6VMDM9Bu8D2jY6bH+5rYgEJIvCL9m3P6zcNaAiV8Od7NskByIqfFjkIOGTKIYu
	 bziFMd7txxmC/WK2NVZWk3piuN3FtuLKhT9FuNeEmDNyLORRZPII49DwF7h4xlHk93kVF
	 F12bMMCr3sNDe5YlY3nMpQZ2LJXklK+FjUzXQll5gQvP7wnpRWgzEKtRNJLsBTsUS4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793819005;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=XCfh/r1pNC+HkePqhofPM4Oqn3XKbj2GBSYYca0Gv2M=;
	b=gC0CPOXISHFYb7Zypr5gvcB0tvz4vGEVmkyzJXHQiNa4BkmYwm/Pjjgtr8P4Uoxz0djH
	 KQ9fur4NbzZvqrbgAzopfIE32Xvgk2uDqzizPUxhs59TrbIdw5rHZRN9ZeCTkC0vQNCvr
	 hz/DIvLQfxUdBF94sY+93SyK6TiuD+rb8HGYqWJJZsoZ7AEvLgrX3G1aO3jMzVbl0DvEw
	 ZcjDJ16PWJG4u7dI3+RelbJXkV5FUjIXSL/xnbjJWQv0TajKgTded0DSz8eeu9f3TAtfq
	 z+NLkVFv971JIgVagyGQdR0Xiyc5usuxra9q6ueTF9QwwFEbphh+NV5DodhF0tWvYmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zNJUNa5+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384C606A328
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:03:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1384C606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zNJUNa5+
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3282db206d3so2019289eec.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 11:03:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793819004; cv=none;
        d=google.com; s=arc-20260327;
        b=nxvn1c9tDL4uCnWdwGY0ddjd9PBUjtHBk/irlvUKk9pqXN6R2aVXZPU1V2yNtJ6IoX
         zRMRp+X4W7oWnDFLnRBkXJzh6vmKMKC5O83MX3suEXTV29q8xZ7pp7PhxRGBLyfb688C
         Llk6peekqF3kgJdb0/gbut+EXW5aA6JMXhdP2K/pR28UBIh+Dv3qYYHeZKNdKVel5AoK
         sId9GPDoO504/Bx2+jP44JhxPdyBIW5f5jQXCnkHc1a32HPUCzVQdceSFmz05w99inCI
         TFfLUMXCNydZAcUAPSEz3dnMtULPccdQHb8bsPGbnHUjbNCa5VoZD7drrOQAvghaSLCm
         kTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XCfh/r1pNC+HkePqhofPM4Oqn3XKbj2GBSYYca0Gv2M=;
        fh=6WgmnzbxP3ZkrpqdSeER0RSFlJnltCsX+QJ8fhx+g1c=;
        b=HX04mhdps6kOIxhpuRZnNrlofShEgfQX8hoScEmuDZZtqY1NzfREz1R6PMyjs0mhI9
         6n87masb41+ZCrntoc+7vti8hvs7DQRGrpA+p5r9GjnZeeuWLaJCZoJHEsQqJ3VIMNIG
         WhqC6e630MfBfMeOEgEs42CBIE1lU92ylaOILuFSh06jMLDkqoURFlTwOmEftyj6LRZw
         D5lrkEJ3hhq+G2Nfb2WO/ELWEIRPrFRRSrPkd8KSQdJH21S4xJmkoKI6PCWIEbXiG7hO
         IA+iMUDGzKDkz/bXukLKB3qk15ci9Yu17f96b+xOInvhtjKd1O4pTjvJVy1JmxHzbmYF
         rrqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793819004; x=1794423804; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XCfh/r1pNC+HkePqhofPM4Oqn3XKbj2GBSYYca0Gv2M=;
        b=zNJUNa5+LZP8jhdZzeITjtExZi25kS1D+0da85PEoG4ZDH0NU0CSWyzsH4B9f7CnPR
         Iuulz455yK2gUbgM+RGHOhd79GDIaVqag+wU7ve8AaSaT/IaJPg27d513U4W+usMPZBP
         u3lxAWMGdTP79PDUq6QD0E+38O1AZB5pczonbNBkIJUWlK8WmYMMt/9djs82sG1SKKwV
         WJKbY9YYwoSU9n7EovUYuUv0kj8nJrsAphJov4RJ1+wqEnuaCBhuZ83zTIyMot67kOHw
         Duff9zjkoH6jNDx3gTfWTU8LthUAJ3dlfUFNCPaBqtcftL6Hw0gK2aP8I72UimZNZHTM
         sT4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793819004; x=1794423804;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XCfh/r1pNC+HkePqhofPM4Oqn3XKbj2GBSYYca0Gv2M=;
        b=xYMWeo+p1/Y2gxzYEvE29Ov1HP3hEVHpTvTRAKR16DlzYnfhh/cDSjiTL5EyM/cxA6
         FQUeGJlsJvY2+qxNFKrnE9b79mkw6TZ64l7ib1bqawLtH19iEiC14EEcPqJmoAMRHRvM
         m8IQwtVirmoiZEUI8TrFe0fjFsemRaLxe5Ckkx3rvVUvFLebJLLkmLrFNUcyAofssa3g
         VhzEMDPkN5OFdBJmsXhflJTfPMPS7kaf82dnCSQpJ0id6sMuji6Syw6MdSjdwoPEW58S
         3l0d5XIO9r/jvvtkz4a+xTLomIDXe1NZXIHWsT0LiG0fiLGwCmo4IE/d48RLJlEofZOH
         kqFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxscJkQ4zngQ522GF4nZ8I4icCWl125XiDQjszoOuPgNtjDIj1KGSaFmfTFkTB/RRXqLQqhgvT0ZsZd4g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/4wbcz29gwF3D4TJ0WjsyAuQGiyq9IPE5D06FH0B1qIz64uvbo
	0d/mbNJ5NWBvv7vnXTRkWT37/kK7qhAZU5WowYiT0/A4nFqYRhp7dBqUixYwC+nikvEwNc9soQ4
	BhfLyWp7cIOzdW2UskRQCn0CPINeJQdY=
X-Gm-Gg: AYBFou3wm7j1ENKREruqvqtgFWJEkbJ0BBhqakM3uigxX0NrRrhLTSb2Ldb9X4S7p7i
	om2uYKA6fw9fXX6sc0zZb7N+75xNr8fHvyRJSDHTuAhHI87wdDUN+ATfPJfimTo6wXYpSl2m9m6
	//WBTOaSVKO20Zy+btycrBa/LE8zuH+GgTwdQt8EpAzScAIKQVbjn1GmOfHD8IUqcfaXVlf0PlM
	EgWIQMfxNQWKdt3L6xpDh5pBvjexXkoo1FG+sGoEM5quBbtehAfPI3hja6kKfAUFRBvEQFehKRB
	wUeBQ7F+II4jRvtT5u6ylssF5Sav7LbIwUTJXY8OpaFC4xOA98Q6lXKm7Oye8KB8xoLyv9ydW4N
	dLXB4f7QcTSVGsVeb32GCg4w/sjeQzupCK8/19GaqqUHipuICMihB4nNc4muhQfxWc0ZMuO3OB3
	DJjly5YC5EYYjxV4rDkNBmKbSY6NSD0vOdBuxQSRfj5Nh9od4=
X-Received: by 2002:a05:693c:8803:20b0:369:f0de:259f with SMTP id
 5a478bee46e88-36a424085bemr28275060eec.35.1793819003986; Wed, 04 Nov 2026
 11:03:23 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com> <20261104172140.GB4186782@suse.cz>
In-Reply-To: <20261104172140.GB4186782@suse.cz>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Thu, 5 Nov 2026 00:03:12 +0500
X-Gm-Features: AclHuK9hRBmH4NMhzWAeAAXoaXyP9CCszpmfue4Ccymk-88feTuPzb2KYVZGwTs
Message-ID: <CAEmTpZGTub1Q-b9G=k4+=+_fG81HitJqFw9kAsBFM6eUoFt8vw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: tag all metadata I/O with REQ_META
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Qu Wenruo <wqu@suse.com>, 
	Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 04, 2026 at 06:21:40PM +0100, David Sterba wrote:
> Remap tree is experimental feature in btrfs-progs, so you'd have to do
> custom build with './configure --enable-experimental', then
> 'mkfs.btrfs -O list-all' will contain 'remapt-ree'.

Thanks, that worked.  I tested the remap part now: btrfs-progs devel
(4f5956a) with --enable-experimental, kernel with
CONFIG_BTRFS_EXPERIMENTAL, a 2 GiB filesystem with remap-tree, DUP
metadata and single data, /usr/include copied in, then "balance -m"
twice and "balance -d" twice.  kprobes on entry and return of
copy_remapped_data_io() mark the bios of each copy.

Both callers of copy_remapped_data() are covered: the first balance
goes through do_remap_reloc_trans(), the second one mostly through
move_existing_remap().

Copy bios, with REQ_META / without:

                      without the patch     with the patch
                      run 1      run 2
  metadata, reads     0 / 56     0 / 74        70 / 0
  metadata, writes    0 / 112    0 / 148      140 / 0
  data, reads         0 / 288    0 / 288        0 / 288
  data, writes        0 / 288    0 / 288        0 / 288

The metadata counts vary from run to run on the same kernel: each
contiguous range of the block group is copied separately, and how
fragmented the metadata ends up after the copy depends on the timing
of the commits.  Writes are twice the reads because of DUP.

btrfs check finds no errors afterwards, no warnings in the log.

One thing on the way: mkfs.btrfs from devel crashes with any
"-O remap-tree".  create_metadata_block_groups() commits a
transaction before setup_remap_tree_root() has created the tree, and
write_ctree_super() then dereferences fs_info->remap_root->node, which
is still NULL.  For the test I skipped the remap root fields in
write_ctree_super() while the node is not there yet.
