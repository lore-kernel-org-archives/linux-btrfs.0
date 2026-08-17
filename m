Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD9A25B09E;
	Mon, 17 Aug 2026 02:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786934354; cv=none; b=NuHjdHM54as48CvtKlwondgDr5Ln5PlfX3+Fw7AR+4NwT2VYveEndgg8yhurO/Br/j0dEr4UQiQkgkwlYx9P7mUCrsGTJCJJT53EKDWQ2FMEbRlEenJKYwA1EEZ6V4KJuVZwFTY46xdumT7OnKAmmNIOuFXjSr7nToboFl3ojNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786934354; c=relaxed/simple;
	bh=GegpXDcutpDDvj7DpMEeBigmoYhrFQQxpe8x2m85to8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u0uFsKlJA3JmZ2wGIc62lhUuKi0JCn949hJgaT9jXtji1o2MgnMM2BPiuDIsimQSqNv/AtLZwgipCV79XVwxqY5Uo/QEADw9gnRsNf0TVB61AlQF7Nh6/WEvUHqxtKrsUg80UoN0cvw08PisLwiCjFcSYsGk7niBVYpth35Hd1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=TH/2KIti; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="TH/2KIti"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1786934255;
	bh=h+6Q0J6JCA+a12KGJ99TS9qmbev11ZbTu4xdbQoRAV8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=TH/2KItiFIT39x/EKXeDbeFX4eJbVrjrFezYPOn08UoT34tc0s0UD31WH47vj+Cfd
	 NLUsoL9bcDRF1MXSwCw5bKAJAw5OVs6eiY3P8h0s+d9yDzX0UwhRVYi++Faj2sOfvW
	 EznXp1wzpUnCFiCBQv9hj6P0AekwRApPjvdYXLJ8=
X-QQ-mid: esmtpgz13t1786934249tb85d61e4
X-QQ-Originating-IP: Gc55HQvq+MeE1hB4MN3PpgJNEfVR7gnm2TzdvFrXBgM=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 17 Aug 2026 10:37:27 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3959441994811052823
EX-QQ-RecipientCnt: 9
From: Yichong Chen <chenyichong@uniontech.com>
To: lkp@intel.com
Cc: boris@bur.io,
	chenyichong@uniontech.com,
	chris.mason@fusionio.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	willy@infradead.org
Subject: Re: [PATCH] btrfs: remove verity Merkle folio from page cache on error
Date: Mon, 17 Aug 2026 10:37:26 +0800
Message-Id: <20260817023726.1731478-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <202608150828.VDr6P7DT-lkp@intel.com>
References: <202608150828.VDr6P7DT-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MnHj12EHtzRtY/hfoabY6lbBnAgbgMSWbcUZCdBFCCs5h820o4tWBE6s
	wv/iNs68lUKxijcUMn/Y5w2aQN8QrdPaqZFPe/fqbt3iChMwbX6YVIRq5ZG1TrYL7nJ6qZE
	ST+xR4JR5VUHzRtHSEx3v0nuXE2A2FtHM5hhtaJVJQeJ0orjkhp88GXYQKb/ODYaR0stf2u
	HL3htlMJc2qEnpu67l/m+NzBTpoChO/sEqupU1JnoKAgFf5tXreGmA+Z2su6giVBOum893c
	9KCUr/1ysIjEdPTsAn000ilYURbJZGqXaqkRUjIrYX/QM2Hu/d2WN9sew4V1NyE3vhPAtsA
	tsPMirGCaytLEw8JsKDFZKl7sQ2UszFQRuzHH1MzXvfjFryUdgW3S+iSU3hexTij0DZfsz3
	MoIdGlj8VxvdBFWTBE6cNnMl9nSlUdPMEdeZOHfENclSChJKaJEA+me5Bo4JkHgVsrf2Nv4
	iNokk5zl/ktY93tjtbc3yAB7TicvQGTyKjNuzDlaq4h10OmeVaIu2Z0/lmT95aty6umiurE
	gzUPSp3/GgldmsIFkU8RX2Sgg8Hrk6lzU/QAWeXnZR0B5Z8qsJrc6paNwt6SEcpbpphBK0a
	9433ORz0OjWBh7AB/z5iJfW6M2procRJXwYoO7M53/5ou5i1V2lkBscqPtc3ZHr9qVM06Gd
	jFj8qGDUgz5LTO2Vx32MBJ6tKWH7pBe37RFwKjCYR6KYPs43uaV/GM7hrmww2leJohPUADK
	a+03NNq5p95WR6G9LwddH+ZBsYodiSCshvVkOScmSLwg3HDMwLBlk0tlPr7hr2SNdRK1Jfz
	ajANf7a+3JgVXHq2K0Fn0ldHfaE6CgE+19pZS8cGBm1QY/esOyCYsR+rynnfe0lSbWzGmXV
	/DzeQbQXZRNl7K3x66KEPwm4meISuU8gusNhgbIGjvFCNRBQMlNpnz/BI7olZ/X45UtGSS/
	TAsgoOdX6nOER0osB3rAxmwz0ZG9nnUd+0BSsG1kagUxhNZZzUXM04mtEk5hK9pB9UcoLeO
	kHgSiWUYnmLZXrNvpsxWGFa/RSkdFiFAkWMCVaF04AyMl81Rou
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Hi,

Thanks for the report.

This was a problem in v1.  The patch called filemap_remove_folio(), which is
not exported and therefore breaks when btrfs is built as a module.

I avoided filemap_remove_folio() in v2, and the patch has since been reworked
further.  The latest version no longer calls filemap_remove_folio():

  [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle folios
  https://lore.kernel.org/all/20260722025435.1493093-1-chenyichong@uniontech.com/

Thanks,
Yichong
