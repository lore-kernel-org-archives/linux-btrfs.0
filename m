Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610584;
	b=r4EUua78rwH50Fgpp1dS8geMFMjSlaGa0TIRNwPkw24izMwgXXY0P5GrIAKEEwnoM7ID
	 p8QImU4Bb68a4cTPOjAxZSABVo8orXWk48LofuWvyDu1Bdx5mSwUIrqzbSpmWmrXCidiR
	 Bp603ib4Xv5UBJ3EZB2ZAW3ce1FZ0rlL9xFekoDAIZIaIBntLxGpMzXE7p+MKg1EABaAZ
	 jq5Cj3Ugvth8X+65ujYxkVrjM5Kdx+Ygr9vLM4S4g/5wlV/5epxt79f08Tjf7fsRc/lC/
	 PIDfME/smGEc89Fe+ElL45xHPJh48Os1nR5g3ZfS7McXQ1/G4kKh5GWi1gSbAoQNGsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610584;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=TguIi6LJJHsAiHktyRxIoLuxMSBrayG046+MGe+ZjUo=;
	b=2ki74Ore4my/ib34EgYrGhmqfsWXJTOFmrA9tTAAYNnGFhJQlCVqD6r9jT/zzNxFVZbB
	 7Pwer6NJ2VoSYmFAVtJReSb2viniMfM5qFhrksa2hHEavBX3V9Qh2KmhdRPFjQ9595t+k
	 ZQKjBXsHf+6S0nuC0xfYJfYYgDzdCHzG1HPnMNruKSgy7Ot/GXlB596tn65EyqrKu9Bwh
	 Ez6MRAA1+XQ3O6bBt5Z7Ul5AIVsI8PwKLa/4eZVke3DVUSll+G/LRiCPLQ09XChHv0KN2
	 pZCoG3s4Pnpk9kw5pVC378EWkPwlbd4Bu8ryy0XqLCDVg5N2QBrcp3lp2o0YeEsKT1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oyWcLhqX;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEC9606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BEC9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oyWcLhqX
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a357b1c649so3322422f8f.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 04:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795610582; x=1796215382; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TguIi6LJJHsAiHktyRxIoLuxMSBrayG046+MGe+ZjUo=;
        b=oyWcLhqXhxyH/xkVOeldEMZx/IyCmmKBl+60GFmyp2gEim6tjKhZK7zkuIpwb6cbZQ
         Q7C8BbwvKq4f5SiHLR17ZdccRc/rLOPpQowXoySk1RnkaFAp6mawcNSTtKk5lTfr6+/k
         MiaAFfYlCVhFZszlRC4/OMu7cHNaoMBf1m9WtayNl4CKqnRArz5uR+zvjbXMPlnbeNEL
         bpTZrj7L4HHnWCI15uxfxBpBDl95YY6c+F1yJ94uLmA69SuRYt3FZnd9qz4LnfAiqXQU
         ZgrjcxR9igI/PP5Zt+wTo/JHIl7Q9RrMSBqkZIQvqfwlnyQ0RkXCMbXOLZunCr/UjdRv
         9loQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610582; x=1796215382;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TguIi6LJJHsAiHktyRxIoLuxMSBrayG046+MGe+ZjUo=;
        b=j/GDgTQCaxqaGvmPGMj+d79U3TiyQrDWdvlIHUbsFBC2nk4/Y9/0HurfxQyCZb41/s
         W+AvB7VTj4q+QU7XZ7+cTNzW/EUjqzpNs5K0Rc04QI8zwRJ3+q1aYOAfrfU7lvODpbLz
         JTXdJO6k28CyvtSrJCPuxkvFRw3WWvlGNrUovfShInoOtcjAkYb1fHa4BaEogp/xy7ZO
         bJ7ccR9NzSWZc691SeQ8Y6oifYX9Bdx/ngj+UHVmaZVIO9xSiyEA67uYD37oMKleROAD
         uWiv8JtJ5GfMsiWxwz9FqKh9+rcsZGjYUOj9qbEtWjSR38w7kR1d4H8VZjr9wVyNRcQ8
         WwJQ==
X-Forwarded-Encrypted: i=1; AL+hErEPTuP/4koTCFnGn+9RV4wB7TVntlk3QBjRlV62s+6CcDC7SJy9fXNyYSCEciIRu5tsP49swXL0MQv1dg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+mZiq2bM2HcxkDiMDOlxSiCUyUxeOdn1DWaGOMbYXGu7QXhzG3
	KULUM1F3GOP/l+dSu5rXixlfsD3m2F/54uZM52iTD94YA+M7E+N560ee
X-Gm-Gg: AZFdTZdAPR70LcnRnoDdy/kcjEEohfl41cCI9VtxHQ+HvDlcyFkt8kgJAIZh+dl7ep+
	MKMCc6Uldia4sx9isA3kGlJqgM45xFauqWIO1TuxbCx9uZOFHRiehYYjae7a2FRcM75cQ5FmSQt
	kHwQWJV+PLlfF7/faRo8dhmsGcYepAKdG7kuaqXDfxLbbzw6bQaTfjWTC6imBw4fsMQpV9AXVq/
	omA/BRopxHf/au/lQkFy2Mif+cc/Im+ereOSpSHpTjrhIuUXBV+xybG22oa6BNfkEWyrKbPhGPd
	q+CNCE1iBYt79vGlRUl0l7oc3E2CWkzG7luejP4Kg+E2Bl8upoYV8jmRaxk8x/AnwfXGflyS5WL
	pKhRvB1UOZv5A6N/8Vek9EOrjbDFGT9gsWKpz0eCbdmn2aY/Ve7dxpnvihVB9KMji0xpRK88uox
	YWUD7cLI4K/NlBCWsctUURVebVIXzx7yLKxoiCkbFm6p6YrqogwnlG9aaga8CFCbPxxtvmxXWqV
	0HQC5eYTaf2CSBI87R9yinoLqjG/h70Ixezonq3xljd/Ilv3HfgWjpifVMy4c28gcZ3QaMo/t5b
	kGPNFjRX66p+2q+yyOAqqDM1ePdlLnYdGqbrXx042qfFQMK1xVd89ZANwtrlMdjFnGGvngcPd0S
	vtKQUxs7bI/EXY6d/a1Ci5KZw+xhVWU5zWqhQbUO9glqF7vYsqiq7fVyxtncZ0+nGyaR02PtrkD
	m63s7wkBUUFl+KQF/CldAu/VAgv/cbp/H3okBrypBbd/KEnGPmw7ITMg==
X-Received: by 2002:a05:600c:a11:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4bb888120famr364559235e9.16.1795610581794;
        Wed, 25 Nov 2026 04:43:01 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-7575-e1e3-dbaf-96fb.ipv6.o2.cz. [2a00:1028:8388:a84e:7575:e1e3:dbaf:96fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442995sm536486045e9.2.2026.11.25.04.43.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 04:43:01 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Joao Marcos Costa <joaomarcos.costa@bootlin.com>,
	Richard Genoud <richard.genoud@bootlin.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Tanmay Kathpalia <tanmay.kathpalia@altera.com>,
	linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] Avoid 64-bit divisions that need __udivdi3() or __umoddi3()
Date: Wed, 25 Nov 2026 13:42:53 +0100
Message-ID: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

U-Boot's private libgcc does not provide __udivdi3() and __umoddi3().
v3 of the mpc85xx LTO series links mpc85xx LTO builds with it and added
both routines [1]. Christophe Leroy asked why the callers do not avoid
'/' and '%' on 64-bit operands instead, and Tom Rini asked to update
the common code [2].

Patches 1-4 avoid the divisions that make the mpc85xx LTO builds call
__udivdi3() or __umoddi3(), in btrfs, squashfs, mmc_berase() and
get_win_cnt() of the mpc8xxx PAMU code. They do not depend on each
other. Patch 5 removes fs/btrfs/dev.c, which nothing uses and which
holds another 64-bit modulo. Patch 6 converts the remaining divisions
in btrfs. U-Boot never runs them, but builds without LTO still link the
ones in the RAID5/6 code. My reply in that thread announced these
conversions for v4 of the LTO series. They are sent on their own
instead.

Patch 2 and my big-endian fix for squashfs [3] conflict in
sqfs_read_nest(). I will rebase whichever of them goes in second.

Build tested with a buildman world build on a fork's CI, and sandbox
test.py gives the same results as before. Run tested on qemu-ppce500
(btrfs) and qemu_arm (btrfs, squashfs, mmc erase), and on a Turris 1.1
with the mpc85xx LTO patches on top, which boots from an SD card and
loads files from btrfs. The PAMU change is build tested only.

[1] https://lore.kernel.org/u-boot/20261119133310.22732-5-pepe.schlehofer@gmail.com/
[2] https://lore.kernel.org/u-boot/20261119200924.GB3176972@bill-the-cat/
[3] https://lore.kernel.org/u-boot/20261125095537.37979-1-pepe.schlehofer@gmail.com/

Josef Schlehofer (6):
  fs: btrfs: Avoid a 64-bit modulo in __btrfs_devread()
  fs/squashfs: Avoid 64-bit divisions
  mmc: Use div_u64() in mmc_berase()
  powerpc: mpc8xxx: Avoid a 64-bit division in get_win_cnt()
  fs: btrfs: Remove the unused dev.c
  fs: btrfs: Avoid the remaining 64-bit divisions

 arch/powerpc/cpu/mpc8xxx/fsl_pamu.c |  2 +-
 drivers/mmc/mmc_write.c             |  2 +-
 fs/btrfs/Makefile                   |  2 +-
 fs/btrfs/compat.h                   |  8 ++------
 fs/btrfs/dev.c                      | 25 -------------------------
 fs/btrfs/volumes.c                  | 19 +++++++++++--------
 fs/btrfs/volumes.h                  |  9 +++++----
 fs/squashfs/sqfs.c                  | 21 +++++++++++----------
 fs/squashfs/sqfs_inode.c            |  5 +++--
 9 files changed, 35 insertions(+), 58 deletions(-)
 delete mode 100644 fs/btrfs/dev.c


base-commit: 79497816056122c49b3b135e14cbac59374e636c
-- 
2.54.0 (Apple Git-157)

