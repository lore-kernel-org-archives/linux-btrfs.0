Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793686237;
	b=sUC7Hn6R3PaLbrEuEJ8FJogeAfY7iHyD9zcNEXeOVuKR7qBinydW+37YeBnTEKZtIJsu
	 rfk46IvQKkTnCnvAye5E+/RhT/Odf2R6DW7KD0Z6TjwDUsnjECvQmGv8GtbW4RvA2ag3C
	 U6Z3Elab/TTWDDHlQ4vqJMSP/VKjg7L1OXnzFE4FLsScLJwOMUBkfIkYLbJz3qgBIzRFd
	 4GStpefJwoPuQj9NI4XH3Fj2m51HRHErn9nMqh5KFFUew/kvfGH3+AwKWlaGYdP6wRYV7
	 8piYI+tUFTGP2ZvGyvvzZgXzyXidC18lzJC56rSZyfL/S4IzBc00xOAp0uup6ITlbtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793686237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KFsSEq0aVdJiuWqCXjRsBsH/M8MUcBlXiOUuWRY98v0=;
	b=khwxvNY+2CwSMRMOe5UvOAMYl18sx1eILkVsWCRCKtRjM5o7yL2+m3Kn+k3AaZ6V36SN
	 FmSnPUg2gRV1Z+UQ6ttbKo1s+QMELmEXjNe3LZswjxWFzH2BNwHG8wTIdSWwfW8+VXy7u
	 8yj2WWcRNG95OmmHKJnFq3JCbm1PRzdkEzhk62F7O5NVRa8M94Tv14n6sQccxffdWgngR
	 TRrzkAgCVhlTTPIdSES7Xane32mnAY1Ia00cUdr9fvT372oxmvxzPWnP5hosL2V2WoFDp
	 uWZRmhTWYgm5BVpv16Cej07e5bloAO1ty6MBk1Zdluv8PnDVJqTOI73oCHjbWHDyydA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6544606A32C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 06:10:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6544606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91b9e758c50so4602646d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 22:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793686228; x=1794291028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KFsSEq0aVdJiuWqCXjRsBsH/M8MUcBlXiOUuWRY98v0=;
        b=dVKg+QM7TdJgDvPFRaY38a2lY3jCT8T3KR7+8m5gJsxM9VCBYa7/HJKMJtiyfJK1O8
         +Gnfanuh65RUjNXRznrW4CtbLeAZDc5iC+6yZM1qWVWgsURm6144zsqt+eNgFeJKrTm7
         yI+6zUSIly1nLpYRUm3mUAZuHhMnC5GhDNve6oFk7vjX0lg3tk3jUAwoJV54EExSdVrt
         dp1Kr7MtxVlpjegF1lBZUU5w9xk3EuxH44AOCB46YcBuM8EPCiSrdRG23AeEmUSmVeYX
         KEkzYIk9v9JokiZbj5MnHr245Njo5soUMLHRtnmS11WD5fM9/U3eYweOS0GABoxA9ibZ
         CJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686228; x=1794291028;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KFsSEq0aVdJiuWqCXjRsBsH/M8MUcBlXiOUuWRY98v0=;
        b=YMikaQCKWCw9ozdTkzRYGP7zputf4pnunLZmiVWSh/UKX5BUyhxadUgyAktb0JI7D7
         kjm+Wev6t8YkOJtGAll01twqLYLzTohQI3nPR5cYvMWZ9jcBaW1gZ+mP2cCQ6G0uh7JS
         8dEVgOPWU1J9I+7OK+pRy8AeLFDreY1rUTvlOG8fm716rC55JvpHjugD2lrFzJUCvUmS
         KPtEJR7DzfFeMNXtimYW4mXHQvcrImUIg3yF4X/PGLCD12QVBj3AnQwJcpATkPshKSlq
         eqeTZiyqsKan3fqHHkfh33XrNfmDODFIJa9RI9bHsMTiF66Az/zclyyZEib+0cX3XXDF
         1Xbw==
X-Forwarded-Encrypted: i=1; AKwUvBxd/vb6t93/45lEMB0gNFhVb5BM22RMAcLjOzvXYXBJc1nWlu8lX6VIGdlPNP6UWo2+H9rHQfgEFTUvyQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+8/sJti5CadoMZTbVVd2w116FhihA+17wGllu4kzvE2uX6EFTO
	7F/29V8KhdgPdybPwrR1++PEa1rbzSY92NJUf3IYT/tzqs9cdV7vR3nrjm2208uOBXyuSV+adnW
	aoey7OhmN
X-Gm-Gg: AYBFou0Bcf6uMTF4o93Opl4HBtvCH5hpn27RTf0R9QFOtzCKVRG00WG+6qyhUxliY78
	OhrUZBYMe2YZsZDXqp0Wek5zQrkiTv1NrGO68YV8kTohMcWSjj9BswTHBKQan3ib7YaQ3WN4Slh
	526fm1ZR9xl2VgyC/Pvg0viDRw3P5ea0wBs4L1llohmR9RODV52FBFC6YdEBHB4SEt72Hr7VUeI
	PlnCDX9XpvikFDnaBrZN8i8CNjtl1X3qbbcgnJKzLcupDCXpzjRKECE0ODsGVFuaBhq5y2F1kzs
	ba+ZEFkHjj8pqNUEER4GDTGwdKQAbbtLeJ+8E54IWtUTJkSNc5XXAFUXTtbXnFOzyhSiKbp7JDX
	wYIW9fIFJfgrTb8DQb/c6mHvVXFyl3m2iRMHoy9E3yRqJBOLSRuyypvak4kbwNzvN3NcWIz/vob
	2op5Ws7o5BWKm6O1rwwUng5lt0ozYpH8ClWbjUXz9pSBNzsb4U1kHCnWut0npQKLOhKpHRxJ6DC
	/rdVbkoj/LGK3zSd6U8JTBMIYsdqb1hE1qhSRwTWBA2z5S9Wh3C7wCtRXJhToasY2UG3ki5UxZL
	ooU4jZAIWa318++cEHwleJXzcFgpmiNOcVvF9i/pKkw7hja4sIdRwlbMA5jUCng=
X-Received: by 2002:ad4:5ccb:0:b0:914:3120:b7c3 with SMTP id 6a1803df08f44-91ca4af982emr184100466d6.7.1793686227688;
        Mon, 02 Nov 2026 22:10:27 -0800 (PST)
Received: from localhost.localdomain ([2600:1011:b1ae:f075:aa26:e161:414d:7ec7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807d8fasm109173076d6.41.2026.11.02.22.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:10:27 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: wqu@suse.com,
	boris@bur.io,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>
Subject: [PATCH v2 0/2] btrfs: tree-checker: reject simple quota metadata without SIMPLE_QUOTA
Date: Mon,  2 Nov 2026 23:10:19 -0700
Message-ID: <20261103061021.2213691-1-smish149@asu.edu>
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

Found by fuzzing. An AI tool helped with the analysis and the patches.

I reproduced both problems with crafted images on for-next.  With the
patches, the tree-checker rejects the bad leaf.  With patch 1, btrfs
then mounts the filesystem without quotas.  With patch 2, the mount
fails.  A clean simple quota filesystem still mounts, writes data, frees
extents and mounts again.  The fstests group qgroup has no new failure.

Changelog:
v2:
- Remove the paragraph about fuzzing and testing from the commit
  messages
- Remove the Fixes: tags; keep the stable tag, because kernels without
  f2363e6fcc79 can write this state
- Patch 1: add a tree dump of the status item, remove the code comments
- Patch 2: move the crafted image from [BUG] to [CAUSE]

v1: https://lore.kernel.org/linux-btrfs/20261103034932.1790235-1-smish149@asu.edu/

Siddharth Mishra (2):
  btrfs: tree-checker: validate qgroup status item
  btrfs: tree-checker: reject extent owner ref without simple quota

 fs/btrfs/tree-checker.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)


base-commit: d6f76ca0a70d0c814731394a625ff0dc1feb390e
-- 
2.54.0

