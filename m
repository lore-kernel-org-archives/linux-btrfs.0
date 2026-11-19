Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082461;
	b=Uow3jQxfTvVfy6jF5DJvwZjNAy5vAOYOcU/4073xEHy4P8UPBH2RmOiQshq41i507Lgv
	 TPYXVMXSC6ZCih3isfMdhVqTf8wEObvWE42KVb1BL8t7c1pOxKNy9dgHQHA0wHDhAe5ir
	 mZlIgbX+NmnpvDXf+9kMADtKYLkAUdr7C7G1MeFFC6CLrYGAmGMf3bg5fD0jXzxT5JfjM
	 XWN5JDsagk72NDpKNdUMGzG4qGNFB3FFRHP4F8ERh+DePUXOabgQWI7mCE2WEDY+rAk8M
	 zi8qv69BcxtHWQ/eawQC5puK18q8ngKvd1br2Jg80vPhQEwyEkrhJclRDXFPI6woS0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
	b=vGb4YsWGxSeRNdZnIzdf3aQSi86qpixpI7F+BKyxin27c5Njc/LYCZHrP8yzhbdXsXka
	 TVfTRqXcUuh8LKweCf4rVs+lFe8e8qzeDcIvBgWDEvQWW/5ukAkxY7jfdpSXzN3vvTq1C
	 4faKrLVcw4hHiFGYS+MjQpAH/6GVRZ5EeJkuMv6DEPpLB7VQa5LKpjInISO8+KcUfLMTg
	 vXZns5/svnRm/AJubiYvY+0O4jBtVEE8qhr2E3IQMImimfvOpugY8ki72pSB59+/FQJQG
	 vJtoTU38eHmii/JnNr26kKDso6ff1pCt8aszkhOykvyqbgEENnp3MMyvfWULXgO4cpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI;
	arc=none smtp.remote-ip=209.85.208.169
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D60060A2606
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 10:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D60060A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3ab46699a09so18556631fa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 02:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795082459; x=1795687259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=qQtx8HcI9xOYAewqsC1qeKXYpNZYkorGxO+WUf8GNlozJTjTfjp6RYu0ME9dnQS7SU
         QlKY2a5rrUaalMRM2QkFx1q2fMNmh0+6Kx9oHBLriNElluMZgw2IJqtD+3DSP2pgxNzk
         2TmsS6xkE/qzDTWdZfTpZ+KAbD1lTDxAfFCzr6drsaxvmeBYV8fzzvm70Eui4lhqXTnh
         HgbHImFNfpvHwHXydOauwOfe17ING4Q6TVfyd4rcZEWzKr9mr4fzMJ+Vemn7/3JBMyOg
         1EBPQX8TZZCNUbaVOuHs0Ki+dm4jvN/9bSy06FQShgIIqQcy0wSxBtWSC2/KV4f07jNA
         MUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795082459; x=1795687259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=CtGaXBKCE8OKz2c+diqr/Qh6q5RPyWj6DNSB5O1sN6DIUd6xGqahRvs0JKOh6doOBJ
         JmH6uKuQLWvyg5YEMmq4FCFCNpAgVtNha6a8IZ4J+ttIMOWdIymB92+uj1a3mZwBWKhw
         ZOcR29/IJ2LRpp6cAAUl5ERpU3EbIsU8p73xs+DJ0RdnGszQrjg+67kK5VujS1Tni0fp
         BTwAYLfHGB8LGpXvvo7dfLCxdqU1CYPQppuVJ45qeYdmvNTWeVolxr9HgIZxlwuV6U6K
         AdQOey4RwTlNWLww/8WCEf3OcglHTcgxfHh+iuaOG4ZfYaJkjj8Wfr28wifGeBRpzHVP
         kFFQ==
X-Forwarded-Encrypted: i=1; AL+hErHcjAXcubOBa4EoWRbXFuxeSAA9o5DM9qC6JWNX08nPFmkZ/Z9/bMa4mo8R+WoCu+g8oTlDSfHkSDFDVg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+OKHIcidelquyDQ47fxQFwLaxqzXQkLZ6SvBMwtgF1nwO3Ku9M
	UjNmd1hipcPzZI92YknJT0N4qq7Kfmi+3kom9j3eGYRQMzUk2RlwJt9O
X-Gm-Gg: AYBFou2Inpx0MB3tHyxhQpvj8CaQdxyE5nzAqhG5ZuPNSDYEBpj+I3tvRKeJ/FQglAC
	77O7gGTXs7QcVehuXyOiq90JNGPjGiz7a7AFq5LajrPIgt1qcF61l2mHPlxHloro/RWFTCRld7F
	ejqU1mzQI7LjcqaotlED79ToAXfBjcZMvG6nPKv45Kw8cyLZT+9LkHt/53lxThgi/pPX+UQPw5z
	dNaiuOlfTh+AvSAe6d4KVuD/oUBab8Hn2xGjqWAyLh9xTCJy8ilP62LDSNQIOAkB3eYH9RHOo4s
	vaoU1JRYWvGGuoxeWVg0sWhKwcm2N9ygSidsmKOtybkljLPrR2g3b97YPhw/bMJFFDRUjmWKEVT
	vPGIyya0HlLolsaYdAVSnMYzllrzeJAmwJJjysxxi+PBUM5fkW+yfO41kpY8KQWg9Wm9QVV1lw6
	hXiNDyhlGzLb/+ZBo4SgvhbjB6nBe4qnhc7MdlE0df7MaEgzI7RQ19OEd7pWxXUuvsHqGOLV22Y
	91hbNwnQRv9hLnobx4B+T4QAvVf8wxwn3A3oVOLOWZYZ+QdoPSIb8ln7l1iww4/NV9PHCzoGK5d
	ffg6z6XbhFI9P51Asemn0Sjrphkz/TBKEEsogdjyBtWJ0PMERYNsPwe9c4fCo7nzF0VckHd0eyO
	kUNJK/VT/9YtfG3VhT/IM2kBSW+6aNzbLTIj6D+B+u6q1aapEoK4sdC58KZ8=
X-Received: by 2002:a05:651c:1987:b0:3ac:7ad6:2003 with SMTP id 38308e7fff4ca-3ae670dda79mr17356091fa.6.1795082459145;
        Thu, 19 Nov 2026 02:00:59 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxeervp7z67jbft6-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:352b:8deb:4901:b3ca])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ea7c798sm8419451fa.11.2026.11.19.02.00.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:00:57 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 11:59:43 +0200
Message-ID: <20261119095943.85048-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <av4Hn9u80fs8iHZ6@dread>
References: <av4Hn9u80fs8iHZ6@dread>
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

On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> I really don't care if it is exposed by statx or file_attr; checking
> the flag through either interface will be orders of magnitude faster
> than using FIEMAP to iterate extents on every file to find shared
> extents. My concern with statx is coherency - it runs completely
> unlocked and so can race with operations that add/remove the reflink
> flag...

Thanks, Dave and Christian. Given Christian's preference and the
coherency point, I'll write the RFC against file_attr, once the
question at the end is settled. xfs_fileattr_get() already reads the
flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
work. The answer can still go stale right after the call, as with any
stat result: a clone that lands after the read is missed, just as one
that lands after FIEMAP returns is missed today.

As I suggested on the 6th, the flag would take the inverted meaning,
so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
("no extents shared with another file"), read-only, in
FS_XFLAG_RDONLY_MASK next to the case-folding flags. XFS would set it
when XFS_DIFLAG2_REFLINK is clear, and ocfs2 when
OCFS2_HAS_REFCOUNT_FL is clear. btrfs keeps no per-inode record and
would leave it unset, as would nfs and cifs, so their files read as
"may share" and a du tool falls back to FIEMAP there, as it does
today.

overlayfs needs care: ovl_fileattr_get() reads the upper inode, which
for a metacopy file has no data extents. The overlayfs patch would
take the flag from the lower data inode, and leave it unset ("may
share") while that inode is not yet known (the lazy lookup on
data-only lower layers).

Christian, one question on the shape within file_attr: would you take
the inverted flag, or would you rather keep a plain "may share" flag
and add a mask to struct file_attr that says which xflags the
filesystem reports?
