Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794887562;
	b=yMnC86iKpGnOwkpsr62gIAWrL6jj+1WjeM8lgOR+3xFjV/RfZtcHH1mEFgC0GnotN21U
	 8O4XsLb3/60HoJ3sJ5kHlhdGnCyELVOSQI5xd/PMnr/jS6Td3sCFsnyuAIsHYT0wpZP/S
	 guH4gz0d36SUMHlBn+KkGukQT/rVRJoJegvxwaopN5pkzkYS6NLztCohlc+8njwTFDrWM
	 XAXH4Cfl2MYhpAYJINKdd/t1NArBb8bsonySwxxV8qIG2jBlF2fBFigJ4uZxTz8ZrN2w6
	 YVLWAtorAYZAZWEUEUOC9xGXNdSl1xEY/u8q5D5ppMDaInjw17cdL774VL7fpih7f0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794887562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=98ojD7Yqgp4+QWlLYJvCdz0SkGgcS1ZlQwaV98NWAJc=;
	b=TezuZpJOZ27LEXlrtFdu5Dt4G8unBgdezy/BnuhpXB61P1AVrVepsPnbzx5qfrsIE9+k
	 vlj71TercLLRVxHOto+AkdT8o/yf8mJEQZK1mWEYDfPjKlIjMrXYb24QY+FeuwC3+GHWJ
	 3mwURcLQXUPwm4K86V1gU6UBqohOPamA3UaaQmhRmr11RfcCwzk58M8PKkTq/e8eZ2wjD
	 G7e2kYp1Ib/leLuKgbSiDzv8pbXuZ/100pmptSpjYIlg6833clZLwmYbLOPEwaqQ6wTtM
	 CmntjoV+NEYJsPkwacFmQhXlVA6rIwN7A+dBgNxmSd1z4tLF7eaMLW82BpnGaqPnkHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vAUMfgRT;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFC2606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 03:52:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFFC2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vAUMfgRT
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-945e6d9ceeaso437545785a.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 19:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794887560; x=1795492360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=98ojD7Yqgp4+QWlLYJvCdz0SkGgcS1ZlQwaV98NWAJc=;
        b=vAUMfgRTe5L+FRb473+XUFiri9OlSQzM3Fwq2mGAYI/xsd0MceiGGUJcQ9xOa5PjfV
         MdSdmceyC8DFmiY/IDttc2iRbooc5gFbbe7uM2JHXUIiVem/1A53TjNfMj66fIf15WM3
         uBCuqJ892sii2nySQsGBZrHATcWI+f364XmPYEN+cvDRdsAZ/eteketmDA5hbuKJI8L1
         Y9AFSbHYVWyDhw7bE10JHga2gzr/Gv+VWJ/sUf1ZNlyznH4fdFJA6ul9wxOyh602Y5II
         t59+Wr+O/iFuuAW68ItNnWw/AfCuLPwWMO2xOpGVsCYj7jQXkAlS7zlm9OxVDRVx3Lxw
         K3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794887560; x=1795492360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=98ojD7Yqgp4+QWlLYJvCdz0SkGgcS1ZlQwaV98NWAJc=;
        b=X0sahwl+Y9QueNMh/x4gjCF69FEKCXSzXjflhDzaVQIbA8zxm2M4A8ZwY8gUNZwXJA
         EZYrG+W1rAJ9JWMIHu9z9Sq8aZcdqYVE+TOp4AIUPQdfzeQUVhWPppBOM732bW13JqDo
         PkQXNDigOfJDAT22AK236eLTEx9Vt4SY89oHTD+fU/IVxqSkU2MI5cAs7Hhmhk8+WLTO
         Fq7KUmS5z3ohVsjkq/OZ7dZL5kVdCnwwnx7Oixp3bwNcwGvFTRGuKnyGgvqf6UdgnGQD
         0E0sh+ugA8sjrrd9zYBB5w1Ck62ETm1Gp4/f2EZYscnJ0tpWKDMRv+adc0o9WGczD8Lc
         pdHA==
X-Forwarded-Encrypted: i=1; AL+hErF4pvt3vsT7hvLMF4WZi0ocPAgQPfuH3fTBSeRNw4pKQULQDqqiGPlIglUXYLt4hS7glT+yK0nApdqqbg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/vA0dcnPkqHiGsjaV4T6yecsPl1yOqz4kvEpmvyddF8vakoD9T
	w9JB9S1sMopaT1DrUlId542sfqbHvVF3krHMilFs32Xt4cI4eA6ZW5kf
X-Gm-Gg: AYBFou2bPRBNxsOjnONip2zuRoIKLTVZ1TqB3Pf+9il9U9/VN1xi9P2esUX0nmiLvqC
	qRZC0sXKnOSdg+J7b6HcUIcpepXATPbrYDrsoi9kbPLvTLFL4snQtuuoN3nnen7nML/ws4Bq4Z1
	1hd9f+IxtyZct8JUxwYTuEtjUsK2IBV30xyxLuYR8kAu78wZpaH+gEzBVzu79f/VN4bx+389IBG
	V/7srxfxGC+wXINz6VVYMZVjjJh/VmkfLdaCP4zKMxfgPMeoTaFPH6hwl7CRU6tojsdf3FIvibB
	mZQqoe2tUaOmkMNt3nEo8+ornqrevZmA/mVwVXZZg7MuFNWitpz5CkdbpVz8h3aSZrgkVRz884V
	6SOojUKCI61B2eanwr+lr6+2M+sA63MoVja3B2b3O7zR1Vz275hNERolTxatD8fFHXIXEAoT75f
	objyEifKNCE/lSbTSNsZUWUtL0nMP+IMFI6uAQbMsuMHVmYtnlWjw5Nyoxz9eCaup914kkCRXn9
	bNlvJFpV5r6kcw9bqOvKCYF1uYyFNU5vKd7UEfpPC91eHj40jp2nVj3VmgWO9ExfaSbyz3PHNb1
	PjeAROt0Qf2UZ5Symj1pyMAwz6PFoELwoKnZNzP7gFb4xDIhSXhUDcBPIxSAaSMAgRH3bmIR8if
	zjnvY3vNErDW6mEcdwWIFsGGJPKWS5IbTGt31R+2Gqib/HKTJ3Eg5CWhhB1k1ZnbVGwczP9m1
X-Received: by 2002:a05:620a:6f01:b0:93e:653e:6981 with SMTP id af79cd13be357-9494ba5556bmr1927137885a.11.1794887560598;
        Mon, 16 Nov 2026 19:52:40 -0800 (PST)
Received: from localhost.localdomain (c-107-3-155-154.hsd1.ca.comcast.net. [107.3.155.154])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d70489sm100944006d6.21.2026.11.16.19.52.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Nov 2026 19:52:40 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yifan Feng <evanfengff@gmail.com>
Subject: [PATCH] btrfs: tests: zoned: fix NULL check of the active bitmap
Date: Mon, 16 Nov 2026 19:51:55 -0800
Message-Id: <20261117035155.86323-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
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

test_load_zone_info() allocates the active bitmap with bitmap_zalloc()
but then tests zone_info, which was already checked a few lines above.
A failed allocation is not detected, and the NULL bitmap is then used
by __set_bit() and by btrfs_load_block_group_by_raid_type().

Check the active bitmap instead.

Tested in QEMU with the bitmap size temporarily changed to UINT_MAX so
that the allocation fails. Without this patch the kernel oopses in
btrfs_test_zoned() with a NULL pointer dereference. With it the test
prints "cannot allocate active bitmap" and fails cleanly.

Found by searching for a NULL check that tests a different pointer than
the one just allocated, with the help of an AI coding assistant
(Claude).

Fixes: 1ba19a6ea9f2 ("btrfs: tests: zoned: add tests cases for zoned code")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
---
 fs/btrfs/tests/zoned-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index 2bc3b14baa41..bb9969210444 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -65,7 +65,7 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 	}
 
 	active = bitmap_zalloc(test->num_stripes, GFP_KERNEL);
-	if (!zone_info) {
+	if (!active) {
 		test_err("cannot allocate active bitmap");
 		return -ENOMEM;
 	}

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.39.3 (Apple Git-146)

