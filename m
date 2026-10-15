Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7F525A67
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075438; cv=none; b=Xzc6ELDkJsE92kjebLvUFgE5kez+3gFD6EwWRkoJEQEPJNbhw4V1S59eBOZMoFvAkbcqztBuWIxtghp0OiaX9tNRKZWcfFAbxkyJ7/1pNr+fmr84bio4jVaLSftC9RxCgUmU1JxaZjLCTVY5Lr2QcDvyZFhEAjVxTnRYB5jEw+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075438; c=relaxed/simple;
	bh=Q8kMUvkchi8ZXnZWlunY2gvD2w3lqlTZB1VbWriL6IE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GoXPYsu/Kf4zI2KCzQ7uegCCkP6YcBZ1P+HAW6o5r6S/eMcCxHxlMNVCqqC8GUBBXZWcN0Dr5ymnjV0Qk2DYXw8x2JnglxWaUgyL0UNYsUqWdpzpt67E0WP16Ai8Lu77J8uBaeUf7H4ACSdZkxw4J//HVI1DTFxY6gnrbSpnK8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ae5L4K7k; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=wX8jMrL7; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ae5L4K7k";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="wX8jMrL7"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYGuE1739572
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XRlN
	+xnNjSQu33S8Vq/FCqmhKpj0NiuWIv/8X+QT1Sw=; b=ae5L4K7kl0GOgJAgiqmy
	2HxVZVIkC9Q7+GjntnTJ5NO9VyXEOVyGdVZRBpoNWEMf5z05cjEtmdT95hH49KtC
	CLW+9W49c0hJTm/AtjTBj2ophj2PyhlU/827fFXXgdBlX1/CL+7Tz1hYUZvqcfDn
	RCHrwVZYNpDteMC1XG/aoy7lXnhFh2ojU8sqyqXd0P1bFj9cwbO3RqwbFK4qRqr3
	kR7hGuU+vfWRKAvNEHd68ifdFX4Z2WWhRN2e6S8JoTo2egVn0cqzNTFjvJd+Tg57
	ElzBA1rahWsp9rHdrpL3kiihpnjKCn9oxQqb/QPaMjtJugJ2ixrNr9xX/2nDuuUP
	uA==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hah7jd4nq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:54 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91b7e7d5f56so96919366d6.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075434; x=1792680234; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XRlN+xnNjSQu33S8Vq/FCqmhKpj0NiuWIv/8X+QT1Sw=;
        b=wX8jMrL7FXMvlRzoKMcZwUPJwtM+dWZR6nukbKOsPFWZ/lmq7d4cb9q3UZDeUplJAc
         Wdvh06XmtFljhtSyc84ezmcHA3Ye89h8fLzWpIIWPnBRRPyGUXl7f6yuUdEKQtVMhNWl
         M9c/41H9RTpRJAbwQa2dB6zMjqamGRzbX/0rEn2NcY71kubVgL6CLx8ZE1fsjBtFMSRo
         tJWi64FQRNML5nFpNCOY4bLlxOV1YRLkh3c89I0YQ0dJzO9mrFe2oZ2XfXR5StjgE29P
         m1tIkFdfTlRVYgzlaWgk/fHw9ON3tzeOQd4zyp20YTS3bBXzZY7lrVZSJUMu1mflupjb
         kYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075434; x=1792680234;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRlN+xnNjSQu33S8Vq/FCqmhKpj0NiuWIv/8X+QT1Sw=;
        b=v4onsSn7WmJZZeoXQHeNL+ZGtxirsm1bBgQR5b0GkAzZ5VCFDwU8m9nDQxXk331NWZ
         YUxZkwQ9mgeX6NoZGKxQXeF5+0yqP6owVZ7QsBPpse/0siziv3vagyJSpxtn0mwHk6nL
         9+oJBHKMABGtW/7uzx1xQygs7Ic2FArA1Ow4FiZtX7zR/1IbiJw7QcyGIPhdDke1BbsK
         XDluNskSmF40v1QVHug/KxsmEOQJxwxcRqIPitOhOZ/jAKnUhlzVu+qujtmDCKzOBkla
         DSCXDrnrVseoJaEKohcgMXuQEt4PSqb+LPzGiFF2r5NdtB19AlXx3R5DsUXCftNGFnYA
         X+cg==
X-Gm-Message-State: AFq9FYJqwnm4BEDYdp3relSyvwfIrXX4mZm9n4QzNokZdw/v7yE7vaDQ
	zjEg1vs2MumbUVDUDsmf41uBMHNJW+1+x54RsQTPNQFLHkYWoTSmzqa7ci8qAvwDSBaX2hTxmgR
	SyscA+qKJNQUnXCAelaTxV7mw1RAx8TkhIa/e8sf9geBIKIy6Hi2BKdaD7R/4
X-Gm-Gg: AYBFou1bl+spbsp5kkUNwcT/NJOnB5O6s6HG7u2KXNdFZ+6LgWodmY+0g72Uk9fQjmD
	9gKiZTmvv3vbq2oSM2GPDucGk/BQ24E/anKliMkoJa8hklpYAWD+U3EV/AmrAe1NeocHyb96WU7
	lg5w3BN+2fzzhVleWwlBlsORSv8bPNHYyYY3hcrXEiMi73eXj0rmnnMUL7CI/DIRHIN4fjUDfuk
	KOylRlfzyPxxJnstoIdkijWgPTgwFTVQSbLiumsCpOb9GwBYw5SalAcxIIlh9agbTOftqOFKcxj
	BT7JCkR9MVaXqc1V2yQbhFBGVXIII20ppHMgtGOWGhDIl4DQYDesxUzFma6v1lL2LBSB45Cx3i/
	/be2lGMv5X/4OQmNUanSiKK+CDT3IBIgpwVcpE3lJ8mu6
X-Received: by 2002:a05:6214:2468:b0:919:7cbb:63b4 with SMTP id 6a1803df08f44-91b554f087fmr322481636d6.13.1792075434067;
        Thu, 15 Oct 2026 07:43:54 -0700 (PDT)
X-Received: by 2002:a05:6214:2468:b0:919:7cbb:63b4 with SMTP id 6a1803df08f44-91b554f087fmr322481266d6.13.1792075433624;
        Thu, 15 Oct 2026 07:43:53 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:52 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:31 -0400
Subject: [PATCH v5 18/19] btrfs: stop reading free space inodes from the
 commit root
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-18-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=1979;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Q8kMUvkchi8ZXnZWlunY2gvD2w3lqlTZB1VbWriL6IE=;
 b=tLdzBU+HXbTY2A0NmgWoEaMDYi7noNEo3UbDuTro48jwMNw8+1h8/6tv7jKfFvCV+G3ovariB
 Z/IMiUXRQFmDvrXvVwzRCnvP3fj+H3cEq5EIAZz3GxKEd1t7J223g+l
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX/kWD9/srZlu0
 aaoQ8EFLB9FfN5byJDddM9L4XDYFYc7yuXgpPvcnWwLsDmjr3ZftWX92janLSf6dWrlzHUg04TV
 VHM4aVQsZ8Xrl2Fyez5p+JSVlX2dPfT8SpFGcs3fwMuxmhaf6Sll
X-Proofpoint-GUID: Ni2dRRDzSHo8UBbTWI6V01Vs3VUJE5kJ
X-Authority-Analysis: v=2.4 cv=Q7RHcI2a c=1 sm=1 tr=0 ts=6ad0e6aa cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=F-rX_8kjA07mH5tGMmcA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: Ni2dRRDzSHo8UBbTWI6V01Vs3VUJE5kJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX+effB12OmiWP
 tjI6FFAo2opin0aNLICO/FBSw4N8D61DsxTcrcDSYtXTP4TvQagu14JEGcoM/e/WmqHifVuAEsL
 c1Nj8NjnhEyIb1Wi/4aGsbNwl5gpsN85avUjXPrQ/e5MGmBJk3PNgcAj/45NFKlhKxysYC/PZqW
 c7PS8B8HwgtRtZRYEGHMxPHSl7bP4WGTowhulQpGuEucgVEpaiAHmi1xhXjledjfjys69UXJQcH
 l9oSVJKkVSDHZUKm9vj6bKcJAt4h3Pxf9oBt2RsoeX9XwAs+Bubu9+qojJlbGRtZ49REAW/6Ltn
 +wFP+4A41rFGcj+pcVYLbuHVdg4K1MFEJ/E1yHOnbasFmfhur+k0Q+CfoxdmDF1f4v46Ww86iw2
 DQ2SYLjRsRReHLoDsdSXUIqIg+hlFMuSFG30ZTGKZFeizXBBKVzjPAIsN34LA/7TO8zO82xhwNh
 01bWoaL+fAiGaSIAkgA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 phishscore=0 impostorscore=10 adultscore=0
 lowpriorityscore=10 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

Free space inode data was only read when loading the v1 cache, which is
gone, so btrfs_get_extent() and btrfs_lookup_bio_sums() no longer need
to search the commit root for them.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/file-item.c | 11 -----------
 fs/btrfs/inode.c     | 10 ----------
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ae1fd4da38d3..ff8f8cad00fc 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -396,17 +396,6 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	if (nblocks > fs_info->csums_per_leaf)
 		path->reada = READA_FORWARD;
 
-	/*
-	 * the free space stuff is only read when it hasn't been
-	 * updated in the current transaction.  So, we can safely
-	 * read from the commit root and sidestep a nasty deadlock
-	 * between reading the free space cache and updating the csum tree.
-	 */
-	if (btrfs_is_free_space_inode(inode)) {
-		path->search_commit_root = true;
-		path->skip_locking = true;
-	}
-
 	/*
 	 * If we are searching for a csum of an extent from a past
 	 * transaction, we can search in the commit root and reduce
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fd8962000096..b071ed59a583 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7232,16 +7232,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	/* Chances are we'll be called again, so go ahead and do readahead */
 	path->reada = READA_FORWARD;
 
-	/*
-	 * The same explanation in load_free_space_cache applies here as well,
-	 * we only read when we're loading the free space cache, and at that
-	 * point the commit_root has everything we need.
-	 */
-	if (btrfs_is_free_space_inode(inode)) {
-		path->search_commit_root = true;
-		path->skip_locking = true;
-	}
-
 	ret = btrfs_lookup_file_extent(NULL, root, path, objectid, start, 0);
 	if (ret < 0) {
 		goto out;

-- 
2.39.5

