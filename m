Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA473CC7F8
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617649; cv=none; b=ZHo3HiM4flkVft4irhP2y4j9XO1TATDEC3bT6a/vaek6s7ToHJ0Yg//28OCpQt+aYPkYPFyLQzn1Bbi83kHCPo9DkrYNDYd+27Cq1IcpBSuYVhIEhY20JmhTeiB3ux68oykN5WlQl9aZOMBBprqrc6kSAmMu6niZAD/X/4wKnkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617649; c=relaxed/simple;
	bh=dkg0MwKLg1iLy+Etq/q2Hvf0oO7DoeoyOqsWTmh7O0I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ur3d6HZhTvG5wLRBEBXx2r0pV/CgFyTJ4/BO9BM4QuXEU/keD3w3bC/k/FE9GmWNLqgZMAL75Cts08oULycJruc/9lN8zQtS3b3XBmuo4nLxQlBo/8BSSO1E4M09oDbyXhIgPYJbVWKdZFVGY7S7uSF8uvjY/itH7Vi9XgBo9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nov65+12; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=dEMl5/Wt; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nov65+12";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="dEMl5/Wt"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2Ywb92036557
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=V0ci
	pskccyeD14O9cgglEpzzEgLikHPr63hXXeLz4FI=; b=nov65+12Z9nhvKfiI0qV
	eXoQmZ4TAj4b64TSAR3NH99PnUfzMBqsxe6/1khBBZdrj/5onAt4B/VwCN+Kiy6A
	NN/d6mgRzMuc6waj8p4s5wSHDeMj12Om4Z/btXS2KYQIFK9EN2YygoE0Dhih3v5S
	BNcItmv6H4OmVqufi4INHTzL3voI33PRF7viUIpgXzvwKWVc9CHXxtDPDyqcGogj
	359YqGnwPs7P/qKrQNRNrHUvco4ja+DMSm8ofQwmLntnCcR+0R2SWMEKPtIphtwa
	0i7V82KSkZYUQOdJ23c3m4+vM3QrpOGPA6aqeIb+xSZDXeP0LCoAybb60QjVA266
	ow==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr3tv1cqd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:43 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91213a1aa68so5554586d6.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617643; x=1790222443; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V0cipskccyeD14O9cgglEpzzEgLikHPr63hXXeLz4FI=;
        b=dEMl5/Wta4nufqriZZlz2yErT85u/Dko8pkJzYF9+97d86ZMXr3MUbvcMxlnT6WbLF
         JUtNLryWgE6x3NCvPYoTv3vfDhDevlbPDbJuAKY2G5STJmSqPKyy/VjOJZoRnMReg2j4
         CrBx2Ql9Ug52wPs5nwkhnYI4xQamnS0VRMOcubuBXOCVcLbUH9Ycb6y/NL+P4upslDLI
         40L4moHxUD4Ruf1Pr8PbzOnY991GHXtXLcgI7A21vyJC/SaS021gity42W3su/2aq/LJ
         oHJhZ1hRcgfW3f9c7MWOJzMFcE3cW6b+HWto8gpBcW/dGIi4swHKJ7V/FJ9G2r5ZVjik
         Y6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617643; x=1790222443;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V0cipskccyeD14O9cgglEpzzEgLikHPr63hXXeLz4FI=;
        b=brhvH/KVYKtsom2Y0hn8G9XHFWplx2Kz87ean43YiyUFp+JzZYrnbQWXmwuvMOFmO9
         7xkTO9ZfBp5TqILbYxeHpl2kX+EYoxD9XdP7LalfEXswSt0u3hm22hjcnLxTDxd/LPOg
         kG2QChL6NnMFLACZFGtv7gD52c8C3wrIc7S024xjO083UAw9A/RQD5NWFCLaOa3m2gLU
         jN53pn05WGnGuYUp4DdzuHnmkSC90l5Bp/ipMizHnY/e0PA/kVqEzprPAwL3vtYZTAsO
         mVPB7+VTRep/77FrDkULPJn+5MP5QQJLhzMzyX0GLgb4G95SfI33RFTCeQ/3RaOzd9wF
         Aj9A==
X-Gm-Message-State: AFuF++kMg1YVny47wQc+maX4hkattDz9YjPnUsil4XdZBnC+e8HD/ocR
	RFroR0GrXMWSa/YdgaZCJRhgQNzVwXU+jljCB1sFJDX1K0K6Y+OEEKVnbliVPKl+pNuNS0hZksc
	+SO9F8j5YFLV+rWx3pP+vV5I7jM2vKt2mIFCqDkwrKUjZ7a1j4odPcF84la3Z
X-Gm-Gg: AYBFou2F2HZNCC50ejZBujJhgOt5XkpSXm0n5RgI+E0lbgWChEleVM2Ymg5/DgCYR3I
	829muOM57jPlf8RAZAdT6LFbQPTnC0pl618PSCXTzPLtUitA9jNPF+TAwH4J5wW6lr7FtVNUQ4X
	PmaD6GlsffkRbPpfrUZhj72nWaz+vu+9nhGlZEAS4EmfVxMnaBzBgVCS8AFGVFQ1sOJhoLSwxHr
	Es+H0XcD8UtHsc7fN+jHIv3IBoienBTg1lgfysu/z/QRXj7pndto2MCTE9f/oHQX8R3bGi3+NhD
	E0b1wWeI0SjH3AqaRaIHxqXmyZM9dNLwBAi8Y2OYXiOqmOTCvOIKUE1jYWycIhBBUSSu48cTZPD
	CXoEdIQV5hg7JxlGFz4kFbMeaprkSkbYbSXJmM1bg2xhO+w==
X-Received: by 2002:a05:6214:27cc:b0:912:d20:9b1c with SMTP id 6a1803df08f44-9123d623eefmr113520646d6.0.1789617642640;
        Wed, 16 Sep 2026 21:00:42 -0700 (PDT)
X-Received: by 2002:a05:6214:27cc:b0:912:d20:9b1c with SMTP id 6a1803df08f44-9123d623eefmr113520116d6.0.1789617642226;
        Wed, 16 Sep 2026 21:00:42 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:11 -0400
Subject: [PATCH v3 15/17] btrfs: stop special-casing free space inodes in
 the delalloc accounting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-15-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=2215;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=dkg0MwKLg1iLy+Etq/q2Hvf0oO7DoeoyOqsWTmh7O0I=;
 b=crUukIonHY8WCi0LJPxP0bKL+Bb/MxcEvBr0jgqWwBVRwDsLb/1e5hnD1DHxun3ZG/cGb2Uaw
 zCNpVDHVqPlCpxGcwOPwMvoSvJNA30NlVZ9HRIJAU9y04GEusPF74zd
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX0OmF4w0UXpTW
 KzudeuNel/98ZDgomlzvLO7RhG1r7sTemt2Y1bwtZ2dQP9KoanaARV8n/DCh8A/8a8m/vYJi56f
 09dMvMAfpInT6UqmCmhFoUaEOD+0OSxzYp0eKrB5WQHFqFEPze504kGiu0DDD5tmWYnAmU6fH6G
 NPB0MVR19Gx8YwKYpHRQWoSRgnVGjnQZHpVkXoRs86Fbt86LR3Rukj2X8YQHFW3KknzhqQmXQ1p
 QifAP3IbY/1MF2+ua66i93SAecrTBJUbv8JXaz1XgXkljwXbtbcSvOxSMxlx4pFsuVya8B5OeCy
 F3CpNxOS2en+3UnYwZM2rPG6FdN65iA21jnTPKfS2MRbUIGnNDoVHqYbc2EVQfnw2MJq6DVwx4G
 b+EdLbTmpbjBvd2eCfRjdhbTRPprcigfSS7MvKDp+jmJMhrWk1Ae+I13ltTG/9WZlQoGO1Eo+HG
 6vSH4/fdjyuXWmiAK8A==
X-Proofpoint-GUID: tzr7iBZIAvrdkZZQpw2uvzo5wwPjBeio
X-Proofpoint-ORIG-GUID: tzr7iBZIAvrdkZZQpw2uvzo5wwPjBeio
X-Authority-Analysis: v=2.4 cv=JIeuIMKb c=1 sm=1 tr=0 ts=6aab65eb cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=bn-TaVTt-omw3cABb-QA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX5qPNHHKL9URO
 GVmxX24r57UTtDVSkNKdmDyrzSwBTqA6oPhSd69rcd6xtdbvIJP6PO+ijGEEshp7jJqC/o7X/eu
 XH513INnDGqdxZSQa5/uGa65jAJT09v9kJms74j6sETCQTDkeUEZ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 lowpriorityscore=10 suspectscore=0 malwarescore=0
 clxscore=1015 spamscore=0 bulkscore=10 priorityscore=1501 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170047

Free space inodes never have delalloc or outstanding extents any more,
so they don't need to be kept off the root's delalloc inode list or out
of the outstanding extents tracepoint.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/btrfs_inode.h | 2 --
 fs/btrfs/inode.c       | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 26cc5d1aca4c..795bb222a2d0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -402,8 +402,6 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 {
 	lockdep_assert_held(&inode->lock);
 	inode->outstanding_extents += mod;
-	if (btrfs_is_free_space_inode(inode))
-		return;
 	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
 						  mod, inode->outstanding_extents);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8292174b550..89b50d4e0400 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2614,7 +2614,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_clear_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && prev_delalloc_bytes == 0)
+		if (prev_delalloc_bytes == 0)
 			btrfs_add_delalloc_inode(inode);
 	}
 
@@ -2672,7 +2672,6 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 			return;
 
 		if (!btrfs_is_data_reloc_root(root) &&
-		    !btrfs_is_free_space_inode(inode) &&
 		    !(state->state & EXTENT_NORESERVE) &&
 		    (bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(inode, len);
@@ -2690,7 +2689,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_set_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && new_delalloc_bytes == 0) {
+		if (new_delalloc_bytes == 0) {
 			spin_lock(&root->delalloc_lock);
 			btrfs_del_delalloc_inode(inode);
 			spin_unlock(&root->delalloc_lock);

-- 
2.39.5

