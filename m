Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E36838237B
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733815; cv=none; b=L8NSYaJQrqofj5mKFHQ0Ml0ux3vTi2YzqJ5Spt25S39cuq2Cs3YTRjo9lq+bZY3angZwGyTzT7CJZAdJ+7N1sZx/UUoJd0VZChMFbvv2I0nB81SHTslEGYyAFLHXpv69PBlm6fLPhfEcan7+WuuAN/oD1sn361BpsyEEeXxfV+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733815; c=relaxed/simple;
	bh=Hkc9N/wQnPcy5buqwz6C0KvUQNctJoFaOYafrURHzho=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LrUx3d3ZDeTlxhn5m2njmAj8cJt2VZOafeY1fViX88dQHHAG3lbUk1qpOsP/RVHmdIBgLCy6+SSPJWGgty4Cu83WfMzz+T44ssdZM3wDP6vPkgvFnmZMLDXyHJ1b3OF3dnxnuGoaAYwjh4YZ6A4xfdclsCKFUxcwdH4lBi76gzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Dju04wNc; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GG/lBvVG; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Dju04wNc";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GG/lBvVG"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686Ltcvk1641123
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KC9I
	uSFqPl2DT5AtFsBj64BwQeweoIQ/q7eyjkLDXpk=; b=Dju04wNcmnCDsyALxLYg
	e/ZsiP4lJ5+iN4XqUgNZrKyLkIVYi96HAjhBEkSHvsgzy7hXH32HwEwINO9FeeJP
	VARsqPIcSQvlULQxkDyQD4X2AObqnj1ftHqw9u7LcD4JeLhLDD0WkB1gremLpYXu
	DIB6jciiF+8y04JCzViePOz9HIqoOPxH6duqmWwkW7WFJzzSQLdtgMKUscYjFBRE
	j1lod/a+4qm9b1MJV12nC0khHPYPUe64RQWTAqjYmeYQ32sVON5E7QvfFpoO8tR5
	+OcLTR/8QWqsDmJjhjYmWaM8BTdPP6dnLmdhwYN4cSNUqvuTpjqtPebWOV3Y/jwb
	PA==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ghfab8d3q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:56 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e7de22fddso67762906d6.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733795; x=1789338595; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KC9IuSFqPl2DT5AtFsBj64BwQeweoIQ/q7eyjkLDXpk=;
        b=GG/lBvVG4RRo2Lm/nu+aouq4Xajo0iEqnWzxTySJZDiTjabkER8oGmntkZNiBx65tM
         hia9Mj1irw77GDfW/R7ihlInumHYtY1477WsvvE/209HNyVpppOL1FyJh6nUzANN/Q0I
         s1ooF4YekFOxrqjPDvoJwPan8Rt3tmXOfXC+KTYK/0OSnzkVxjkVSUD1d6x7ckCe098Z
         JA5OgH6xRqVxYO/yKHadW5/XyrzKbD5ITGg06roACER0sD8Dui6LAXn9umBvWE3MNft6
         5cUjmcJfSx7gYkv++NF0HPjDAuKt+bWgcW7HgmHIUeC9RR1EPdChFegisAMP/gEzs62t
         XYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733795; x=1789338595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KC9IuSFqPl2DT5AtFsBj64BwQeweoIQ/q7eyjkLDXpk=;
        b=nB8mD3a4CWQrTALj6WJHguub7w04sWJ4xeCl3Riki1/qKp2YV7sonum9qwT/wepALe
         BJHbXTnXDtcUYhG51wSR7xRcjd62DeAYGbMikcfhIUgtXefYwIc0MWuNXhT3hmycFiJ+
         alccKwN4jZkDyPxLRmcanicc/lzrE4RD+6UX0p2y+iCtF5YcUNRS8r8i3HewqCzbU5+B
         T/CU2kXh1Dn0hMjR0s+fl/QXnq8tz0/ETQ1Wrjm18oA2fTsrkEE8uXpDtWDU8GrLoJ3c
         SI4u/UP+XL4+CdTQJe2HTxrYZt6WIt4ueVCoS2b0ND9D7jL4S/TH+DuHQF2L0eM5ByLS
         4wxg==
X-Forwarded-Encrypted: i=1; AKwUvBwlqyQCUGdTaetgeJbwYwovc5jtt3iQ6sOb3Efnxduy4qnZ6yg1HB7Vvs2khPEZrjdun0NbwbERWhTi+Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kUH+hlGj7AkxyuKMpll8eLPOgCWh2ImRwjzJgiUmANvXTb1Jnq
	4QOClxYsDar5u5a2XhWX5X2JMnCsJGe7692jTxeJ0Vbx/WHrVSpBMU/YpOD1TE74VnJyPjJjdHe
	nLeajaTXmsgCe0qCBA93DKzfmGO1eAbUX9uO7lzC+blA5poLeeq59FITNn5X1
X-Gm-Gg: AYBFou3RO2yPO1DpQl4QVaElfMZrsiVfqbdOJGEH8uBBVTk/5V07C4BZFcP+Ny8k/pQ
	rEq1LS0WzbpYrekKxQ/zCOCNbo+SlDu+J9k8w+ssgd9r8FkzuG2brieIYIrVuy3gdBifYK1gM4r
	zz9P6JuWCMYjGzMCFYPNDHFDbsNeT4pi6ycLqWdaMdWyD9ix7TrZM16xumQzJVHSAANBRNQHo2U
	mA0YxISrWMO1H8+F9b2Ed0ogCQmJ1AVUub9LC2MtR3p+O/IG0OmQrwMrHCCsyltsx5Ppd/frG5x
	qfoEzbcbiQGfg/ykKgI8wtlJ7DUAre4x5VZsbZZonkbCi/AFAhjBJBb7XVZ7TeeY2PSApAieR7H
	pv1RJjAGBMDrP5y03G2y2PEQ2Y5LitXb7zsmUROvDMNrbQus/
X-Received: by 2002:a05:622a:6203:b0:51c:f3:34e3 with SMTP id d75a77b69052e-53054962126mr222231841cf.28.1788733795321;
        Sun, 06 Sep 2026 15:29:55 -0700 (PDT)
X-Received: by 2002:a05:622a:6203:b0:51c:f3:34e3 with SMTP id d75a77b69052e-53054962126mr222231461cf.28.1788733794785;
        Sun, 06 Sep 2026 15:29:54 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:54 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:30 -0400
Subject: [PATCH 03/10] btrfs: tests: use eb folio helpers in extent buffer
 memory checks
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-3-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=2030;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Hkc9N/wQnPcy5buqwz6C0KvUQNctJoFaOYafrURHzho=;
 b=zyP1Otl9DtQs1g8FRbFXY4ZcLAv4fMzrlgC+7GqkKpwLKAjzopBK74GyXn46YYwn9IXfcdhfu
 7vtAK9PsZA4CPe6zooKDIIBXIap8HX5liFoDR7ysbK00hm0CBEZOxj5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX328DU4CILBe1
 KPgfomgO6xU1V6T+QzF8cDkU/VvUby1WV2CyXrFkMA0yhJK5LjN2rDAPMXKLqJrcshydi1wLHnn
 5rTcBD40E9Vn57tJ9M8pKYAmS8W8fFcgU7XGY3yFmlBPPMSW0DAlvxxgDJk8MlZ1S9PX6K7cIHP
 d5ivvYS8Hlx7ociUvaSrRAcy1c6Zv/SaaZK/2sSbCD+JLAfM3nAUXnTG7rUTOChHQEsnG2QUlR+
 3vfkAJYBAsgdoUHTRFwysJn+ox5Wthdr+xxakMvXLf4sB7SGP8Lq37KKqWWSepptvvxeXdCLXSr
 Afv5ORyDwaX94kB0YK9CxkqCYDGDHtT6r6hC6QSYGGMPYoqsdcb+ZmEeTiUtt6aoa3Jk89ONJer
 jYS1eI/t7b8MGSGJL43nYRdfbLcu+trAkCDCz4iYJgSrDmhztQ+DOD/gdKAwcs9OM1lHsBPsN2Q
 3Xu6vBhPq01i6yS41XA==
X-Proofpoint-ORIG-GUID: 4unHm5WNmu6xV9TbvMPlbTVFKUUFqiiq
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX4HBYla3BfdSD
 IMR5YQGmOq7Nt4lg+SOyprH1yIOjLLr38PJJ0w9Mo62vpYLZdo9LF6NvfEegqRzY9b9MlgURmHw
 JRyUSZaUz/CISk6ziQTbLn15gdJpMfyFvBgrAuNAjRAwwBOYbv32
X-Proofpoint-GUID: 4unHm5WNmu6xV9TbvMPlbTVFKUUFqiiq
X-Authority-Analysis: v=2.4 cv=GMw41ONK c=1 sm=1 tr=0 ts=6a9de964 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=5XjfI53T0xRJ3RmVdd8A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 lowpriorityscore=10
 clxscore=1015 bulkscore=10 impostorscore=10 suspectscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609060252

dump_eb_and_memory_contents() and verify_eb_and_memory() hardcode one
page per folio instead of using get_eb_folio_index() and
get_eb_offset_in_folio() like the rest of the extent buffer code. Use
the helpers and folio_address(). This removes the last struct page usage
in the file.

No functional change. The tests only run with sectorsize == PAGE_SIZE,
and the test extent buffers are backed by order-0 folios.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/tests/extent-io-tests.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 3056dd934b54..7a68b321608e 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -669,8 +669,9 @@ static void dump_eb_and_memory_contents(struct extent_buffer *eb, void *memory,
 					const char *test_name)
 {
 	for (int i = 0; i < eb->len; i++) {
-		struct page *page = folio_page(eb->folios[i >> PAGE_SHIFT], 0);
-		void *addr = page_address(page) + offset_in_page(i);
+		const unsigned long idx = get_eb_folio_index(eb, i);
+		void *addr = folio_address(eb->folios[idx]) +
+			     get_eb_offset_in_folio(eb, i);
 
 		if (memcmp(addr, memory + i, 1) != 0) {
 			test_err("%s failed", test_name);
@@ -685,9 +686,12 @@ static int verify_eb_and_memory(struct extent_buffer *eb, void *memory,
 				const char *test_name)
 {
 	for (int i = 0; i < (eb->len >> PAGE_SHIFT); i++) {
-		void *eb_addr = folio_address(eb->folios[i]);
+		const unsigned long offset = i << PAGE_SHIFT;
+		const unsigned long idx = get_eb_folio_index(eb, offset);
+		void *eb_addr = folio_address(eb->folios[idx]) +
+				get_eb_offset_in_folio(eb, offset);
 
-		if (memcmp(memory + (i << PAGE_SHIFT), eb_addr, PAGE_SIZE) != 0) {
+		if (memcmp(memory + offset, eb_addr, PAGE_SIZE) != 0) {
 			dump_eb_and_memory_contents(eb, memory, test_name);
 			return -EUCLEAN;
 		}

-- 
2.39.5

