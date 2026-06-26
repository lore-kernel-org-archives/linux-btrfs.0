Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD0437F737
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487134; cv=none; b=i3vMdf90zu8+yOSlfYC4lYg8Hu1zaJ24JmWYnqgVk76jXL/qEwI8QIgmqWnWRnwWyRwpqRvbWr87IuAHzIgF6Xn+Y/aYKkZhiMsQNz5IhBDWcNbHFhHTIbmwXsz3Sk1gIuc5QVYFuPzU4F3jB9B1q8cZoLof7/wyDMOIMfd5gvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487134; c=relaxed/simple;
	bh=o5Vpn06WgK66yNZF07Aer8lYugPgnyShzwRVpTapXQk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gtHTNsPCqECZkwKfjmyJsd+t6FYoK+PxRIUbJJx4Ow7pPXfdO6ADbsIwKKwxS7GlnTzRsznX4Jxm8kebYkdw1PEEePa7V6/CrE2hqBD3sukYhlGGmr8PcBShJsntfTWwUlZB4H92i/gd67qlFDNkUUiMtEJrrCfv5tOv1r7N4SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=FPCiKYOD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="FPCiKYOD"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4626fdc829aso688244f8f.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 08:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782487129; x=1783091929; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mB5+OHUIEPSbf8N1FunPva1gTx/Axh3cdH+BX9B+jDU=;
        b=FPCiKYODsSik3Drf4NfefciDHmmnVgQzkYiQyVEAuzDvvjDXekutAIVQq2nE9Dw6Ey
         KWihQn+OENYpjBEpMPbiOScDuZv+qXHtPml6IlFVo8ziH5yQ1JSS9v8QL3O6wv+ARPOr
         /+HKoaWZ9OM4gA/Q51d+dmd7wt6BtfUwWLX8SbGUenkjj11ibjW92du73n4VzjtWRv/X
         Cw55unHpDd9hZUp8yjiOJ13SPoGPB9QzD1rQmB+1gJu+b8++bYOQ4Kh/3T/Y4JtuaUuP
         XOuIAZ/o2mWb/N/E4FocMGJB4JC3lqZxAvwxq1G+X79fmVaq/vs+VOYJ1wHNkxMYXgx2
         LwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487129; x=1783091929;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mB5+OHUIEPSbf8N1FunPva1gTx/Axh3cdH+BX9B+jDU=;
        b=Oaio8JkYclbLZHRx7TKUK5p8ctfWsHkBqZ9guHCrnHkvbAfrMhhHp6NN7GHQ5TKQVK
         HBARHYa6D1ID3TqiygOxVR3Nf8ZTUMEAxSaQ8XwGOymjT1tF0aridJ1g7f+mAnk71SHE
         BbEXWIz+poUsUeAwCxjvL+K1QO9SnyBMGst/5DnBNguX2u+Dgtes4/Ob3Bw25W7jSMsO
         Sj8MK4TqW3dv4NFojhc+EvJ98hkaXjz/NFWVPiIsMQl/+R469Cazam5ssq1wBLohHq2g
         gaTrNJdzRhDdTN1fLSGNV9iGKNklHC+CYr0tdxZvti3rZLCICp/8X5u4HihTkXaov1LB
         PGxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8nYUuIqD2VlvFvbz/SjlMDtllnCCdlWQQ3GCa+hZU9NWck4KiB6vsiy3Rt+WiBZOJwSg6oVSs7GpL+Cg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZz9ERNRLHi0ax+SSyY5RFOqY7oqzVw/dtEz1+5gSkjRTzHWSY
	Y9qAXoXTNYzYw5cfWSpO0vvpNHLO9T7IdKuTk3BJ1qOJiZrrCuiKc91BJDJf7ZXDVSc=
X-Gm-Gg: AfdE7ckOv/0dzM3uIaCyO+VZng2GbzaqgNOqtkcm0UnW6IEVZcixSdZiiUrZRl2NFB3
	4z/K2iVWB9cZkaHDbpS/VOOo0unmDhtlifBJJ0WAC9JklUnhX5WDsD63phRtKsw5NsD7C8Pqm+9
	/MV+YKgM0jkiFAq88s7uhhD6BsLfEfeUnSlPqdJfn68nNNtTT4GTGA8eIwqHLbsohrBkwpl6prn
	yLcGYLH6/at+tDN4QDQwfcdFYnoSHJeqzfl5xmlDQOO6Q7hcjX9j3NKZLRckoso9p7WDcLGfjVt
	mjTXfOh/FQDENDEjluP0LSlQc4a/cRoGqmazayMYwar4/bOJ5Ov8iKNBOVaaE89IFY62EKflx10
	NyKGFbJ/iF1vCcMo5+mWJmHyUngPXGSYgRq6j2dtcajlNioZIpDv2lGnR5VlYwYUm1I9WogqYZH
	xfXyNl6YX5JZqjtOoObOhO3iZGfK/zeQ==
X-Received: by 2002:a05:600c:4fc7:b0:492:3fb5:4697 with SMTP id 5b1f17b1804b1-492668628d6mr104155135e9.5.1782487129411;
        Fri, 26 Jun 2026 08:18:49 -0700 (PDT)
Received: from alchark-surface.localdomain ([5.194.92.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d998esm24860736f8f.24.2026.06.26.08.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 08:18:48 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Subject: [PATCH v2 0/2] fs: btrfs: add support for readdir
Date: Fri, 26 Jun 2026 19:18:20 +0400
Message-Id: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNyw6CMBBFf4XM2poyhIqu/A/Doo9Bxhgg00o0h
 H+X4trlSc49d4FIwhThUiwgNHPkcdgADwX43g53Uhw2BtRotMFauSRdVEI2BBbVOLK+sr5G1LB
 tJqGO33vv1v44vtyDfMqRbPQc0yif/XAus/evPZdKqxBOTWnRVWdTX7snTxPJcaAE7bquX08Fr
 Fq+AAAA
X-Change-ID: 20260625-btrfs-readdir-8beac3ac5220
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 u-boot@lists.denx.de
Cc: =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, 
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
 =?utf-8?q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
 Yao Zi <me@ziyao.cc>, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2041; i=alchark@flipper.net;
 h=from:subject:message-id; bh=o5Vpn06WgK66yNZF07Aer8lYugPgnyShzwRVpTapXQk=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWTZzfB9L1IWc3Cmn/i089E8E6zrYm7yl2tYFh5u3PsyQ
 HJRs3hBx0QWBjEuBksxRZa535bYTjXim7XLw+MrzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 aKRjrGPEwMUpAFPNV8rIsOQ7Ww0bi/6hqftPtT58Fng/2XZNiF3PIesUed8/zjMK2hj+yia9cC0
 Vjp3jpfPwugH7s5hnp1SPFrRsahBvUBSO3DSfCQA=
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Btrfs in U-boot currently uses a custom callback for ls and doesn't expose
the standard opendir/readdir/closedir interface, making it harder to use
in generic code. One area where this would be useful is in discovering BLS
type 1 entries [1] on a Btrfs filesystem.

Add support for the standard interface, and implement ls in terms of it.

[1] https://lore.kernel.org/u-boot/20260604-bls-v1-0-4ce6d1ee4711@flipper.net/

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
Changes in v2:
- Cache subvolume id and inode number instead of looking them up on every
  readdir call (thanks Qu)
- Split out the dirent type conversion between btrfs and U-Boot filesystem
  convention into a helper function (thanks Qu)
- Drop redundant check for XATTR entries in btrfs_next_dir_entry (thanks Qu)
- Remove btrfs_ls and show_dir which nothing calls after the second patch
- Use container_of instead of type-casting struct pointers
- Link to v1: https://patch.msgid.link/20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net

To: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
To: u-boot@lists.denx.de
Cc: Marek Behún <kabel@kernel.org>
Cc: Tom Rini <trini@konsulko.com>
Cc: Alexey Charkov <alchark@flipper.net>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Simon Glass <sjg@chromium.org>
Cc: Timo tp Preißl <t.preissl@proton.me>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Yao Zi <me@ziyao.cc>

---
Alexey Charkov (2):
      fs: btrfs: implement opendir(), readdir() and closedir()
      fs: btrfs: use fs_ls_generic() and drop custom implementation

 fs/btrfs/btrfs.c    | 199 ++++++++++++++++++++++------------------------------
 fs/btrfs/ctree.h    |   7 +-
 fs/btrfs/dir-item.c |  76 ++++++++++++--------
 fs/fs.c             |   6 +-
 include/btrfs.h     |   6 +-
 5 files changed, 143 insertions(+), 151 deletions(-)
---
base-commit: 19eafbadf20f56c1a24abe6b5e8774e776894261
change-id: 20260625-btrfs-readdir-8beac3ac5220

Best regards,
--  
Alexey Charkov <alchark@flipper.net>

