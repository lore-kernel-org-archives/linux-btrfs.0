Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AC631716A
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 03:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791690474; cv=none; b=bO/w4sSB48MANLGkngrj0cM6CpxI64r9Dql2RG3vG43MEPQgLji7eaJjBRsqajbuoXaEEfbJv5awFvJC/ZEo+dEymdVvXh2TVE2jD986JeH83tM1kvxEFH0ueyt/W9610RwvUqRVv2xc3jIAmzphlELM2DwhRjpUv6/tlPrUYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791690474; c=relaxed/simple;
	bh=n0uiX78IPrTN/TLii59hko4ih3t30FEhDQIhTr+AN5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqQM0SMSmRIwz/jBfyWL7xaUbeYatpo7z8CHSzL5kHhhHHCRBYrIyNqFl0pGXEwQ2FGWvCBqSANmhItIXikwvwCzBUlWLu7r8ego3XHG0XpHrXisk3wYNnLLr8U63aRnxH87HiihRg54xMSPyV9SUonnvX0GmuCKEVgZkq74zN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; spf=pass smtp.mailfrom=cs.unc.edu; dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b=gf8Ywsc6; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b="gf8Ywsc6"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e706a6ba9so129345385a.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 20:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1791690472; x=1792295272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FB4MPXLOykFptRXKNBWjPGR4VJPoRGtDL9e2tNF9Rw4=;
        b=gf8Ywsc6VV9A/pv3FZsKNSX/6+/KFd/030OLVuGBQs7r/xkYLqiFkfgmkSGU6fKlby
         bXF5VqseYzBW0Mv1m0lzMueMjOBsLCvJMsPIeEUNBs+GvD9s5gLkPzYhbLNQgzb19BWi
         2OcFViFQCq/XtVwDkJOPe/IRRqAihyZTypqyWzrcoRGlZTNKILghnUvPbgFMz9ZvWifx
         jad9TGf77cq9oMD1KXWZ0WSA/adOvrmcvK8LW3QsFyftAwD8sQDXfiKPTJcaQvLPm1FO
         Zo60jaQQrWJtDYUAl6K+hfUI8P7iGhKjQvmBA2vft4otJpw5BlKcu0NGhTJPc6zJB5lJ
         qOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791690472; x=1792295272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FB4MPXLOykFptRXKNBWjPGR4VJPoRGtDL9e2tNF9Rw4=;
        b=SnqDKy9PkjYeeqVODkeT/zGVJf+TCvCMaYWhQx3IUTseuOw4WSrT4ApT6UOyzhqpBC
         qOp5YwtGJOBpCuUskJXWXaD7vdWcmdGzB+yUX3BcJXDIWHwdMy6/QN14VDYt0dE/KCCL
         lxJ0TP/PLHnflltHVgZfbPcMIiU4tZS0uhS7mzj2Y5JbPwMAq3Mgd0CZa9KpH7q1O5RA
         DgoG/LVr6xhQHFeOCSxAUJIdaBq6I2L33J7/t31UyYVvDwng8cgX1VJpYBsv0u6mAwI4
         LeiSp9oS3l2kdDG+pQR4x6fl70r8ttCp5VybZoszDrwPI4kaUBAgb7PtxYH6jLV1TcBJ
         68IA==
X-Forwarded-Encrypted: i=1; AKwUvBxmE0naPVxX77ZK/sE9SsalK1HiYapZUIkFbc3UYxeNORzf93WpY3sYz7shTp/7lTRvIjifXDEIx3/HPg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLjOKUobQko+AS7z8SKAJ0mFy0uTqotFKdoygyA5D/JSIemA3Ys
	n1OOFvc0ZHJ3xNXULBp97P8PRxg+0NJkGm7liBeWQ6vLgLToZAcugIxmyMH6Uu6OZQ==
X-Gm-Gg: AYBFou0rV0taigp9MoPWzc5nKF6fzAAUzk7diIY/Rg4HX90ra9CF7fJOxF/aZtndh3k
	4ssd/qfiH+WhTePvVGUM6f5bXh300HYj45tTs7qRb3bUSv2ZamE78DebUMCw/W4TM1JXsA7ss7I
	XHqc/PRJ/BNgRsIVm1qWN7zs2C7IZywwNP7ESlorT08Qq2Lley/gFNrgGX4NIGjaizMnWiCe06t
	jMkT8E20e388xAO52glejWZVQN9xwr8Rm76KVs1DtYgpN7YbjlwML4b7rvbGHDbTIzVOtWMxTmk
	tNecDwqsF6baWOxvPoknhywOLtvy/Ez5gfVEZTPNfMXU7MtOPQLmAM2i/akSSIRNc+7NomZ+h33
	1BMR7dwUF80xH4uvXPgObim65d5lZhw+wvH6cbLuTr3WfRUAl2tneZYzN9+/a0F8U9gN9TGwbll
	BhnUmmu9YKuJGlWvM1SQNUue/PZBZQrUzvwjeagE4F8CTs1qb5WIREKVFmSCaG8241Oa774qWJm
	HVmFsPfxtmj1yzJ8n959A==
X-Received: by 2002:a05:620a:890a:b0:939:3a81:326 with SMTP id af79cd13be357-93ebd25989cmr1027862585a.37.1791690471864;
        Sat, 10 Oct 2026 20:47:51 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb9847f37sm558267785a.10.2026.10.10.20.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 20:47:51 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix chattr failing on nodatasum files that have the compress flag
Date: Sat, 10 Oct 2026 23:47:31 -0400
Message-ID: <20261011034731.1054465-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <41987a33-f2dd-4ffe-b35f-d669d36dbcfe@suse.com>
References: <41987a33-f2dd-4ffe-b35f-d669d36dbcfe@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026/10/11 07:47, Qu Wenruo wrote:
> This is very LLM-like, and very LLM's objective-oriented behavior.
> Disclose it first.

Yes, and sorry for not saying so in the patch. I found this while
comparing the behaviour of different kernel versions. I used an LLM to
analyse the difference, write the patch and the changelog and run the
tests in VMs.

> Explain the reason why it fails.

chattr reads the flags and writes the whole set back, so FS_COMPR_FL is
in the new flags. btrfs_fileattr_set() then calls btrfs_set_prop() for
btrfs.compression, and since cf1afec09e9f that runs
prop_compression_validate(), which returns -EINVAL because
btrfs_inode_can_compress() is false for a NODATASUM inode.

> So when setting compress in the first place, the NODATASUM/NODATACOW
> flag should be cleared.

OK, I will do it this way: a new inode that inherits the compress flag
does not get NODATASUM/NODATACOW from the mount options, and chattr +c
on an empty file clears NODATASUM.

This differs from the documentation in one place. btrfs(5) says that
all files created under nodatasum have no checksums and that
compression is disabled when nodatasum is enabled. With this change a
file created in a +c directory on a nodatasum mount has checksums and
is compressed. Is that what you intend?

In chattr there are two cases where I would not clear the flag:

- The file has NODATASUM and already has data. The existing extents
  have no checksums, so clearing NODATASUM would make them unreadable.
  chattr +c would return -EINVAL here, the same as setting the
  btrfs.compression property does since commit 0e852ab8974c ("btrfs:
  do not allow compression on nodatacow files").

- The file has +C. check_fsflags() already rejects chattr +c on it
  with -EINVAL and I would keep that.

One more question before v2. Files with both flags and data can already
exist on disk, and chattr +A on them fails since 7.2. Is it OK to leave
the compress flag and the property alone on these files when only other
flags change?

Thanks,
Hengyu
