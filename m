Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB14F3F6613
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812432; cv=none; b=lwIqk33vXwqRT/+R3/f2B5LIDsy0F7O03HLHGXhYqmm6v2hUsoROrXnYqPlpCJEC6/XRR5qztd1tlOnTjYUXnxOuFmI1I/uVPN3mIe42q8YWa0gdJYWbnowDWQauI3iLO/nE9OFNW9LPDPr+Ps1GGeyYTLqU0nA+Cr9gwPUKAJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812432; c=relaxed/simple;
	bh=D3OoCLzA/WlOhaCyWWm23X95M6jgekSWZ6V3R3jvD8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f/cMLK3GSuZb/GLpsKUG6VDd1EuCExuchXvz8LJz1ZgzqC+rQdTq02C2cbUyZBikpyI3UNAamjaW6WmE1sjUocB6MZztNtP+q+wu9Paya4XzcJv5GIdJVOd7mtx9CCmwe5TfUq3OHcTIO0y4ot6yMMI4ia0laUeG50kASrsWmIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Pr4HMSDX; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=er9XSFpK; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Pr4HMSDX";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="er9XSFpK"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IcqAX3013098
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=hoZN
	7B/J8KWpxSnwN7ipdzq/CJN/u6peLjXlm5haPME=; b=Pr4HMSDXFtAozv5UdcG4
	SATaRJrwIHzMiyuwmYtwklrdo/oi/xsEr1NgUOaB+Zz1P5ZH8Fpwo2wCYgUzvCZO
	O5IeiWk6yz8tPV47biZV0nYHhU7ut2rcQNVacoLzRAq1ClCnraVWyRT93tFY9ptC
	mUrHlfp9IK4QF+f3Qo6BsPjFf5stFjuG3QfzDY84LQxrD09vbBj0vxZjzqmq7WEz
	XioQIiDM/VQ+vGjYWxO5SUWg69M69+hJ5nmPjOqRplyjrEkm2B+IPQgKAj+tovt/
	VE6piwDl4XNGsGzX4ljGIVx6SN8JeJAZ1S6A42sVRPg4NSpuCq/JrIg8FKWEjcCl
	UQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghf7qnc8y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:25 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9102f07f2fdso82627606d6.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812425; x=1789417225; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hoZN7B/J8KWpxSnwN7ipdzq/CJN/u6peLjXlm5haPME=;
        b=er9XSFpK6tZOL7+K8DYbq8ZhIZO5kejWu69Xfhj0n62Mb36KkOzNvSpaagc5k1A5Wj
         dSaKs8Fw3Q8MID2+vf3QvS4gXYZOidghFt7F3md3l/AJRK9NkcenhOtSf3QjEjekwrME
         TwuA34Py5Ksb7DE74j0H8FKtyUMNtkToIJnIEcSwc5h5aC6CCJMU/e+Mt1o2W+TP5XrK
         FfN2ZQb15YAoH0dwp99kZOFV+ZurfZ/6/vZ5PYeIjSA0hmJ9Wb0kR6eTT5KTTZF2ssiP
         gsYG3BA0XUXXGBDA8b3HlrzTzF6+NjMjlA537JhCps5BLE3hT4OgKg2Cr0tXER5M4tE+
         X8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812425; x=1789417225;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hoZN7B/J8KWpxSnwN7ipdzq/CJN/u6peLjXlm5haPME=;
        b=LhSWYkz54AZNagVmVEaHTdwGCXKVUBq6trBNOq0vsbwCja2xoOITfhqylL/7d1DOJ3
         aFRwAQpNLw3nyD3MttqH0JyTJ8SHeNm+x7Hrc9q9xeoG2myxhx0pfqFMSvc77XmT6kvC
         LTItl7pLrrWVjd1gM8PzfluA3D/p/EW+aPzSBFuk57LA0ZwkIH3HmbHRMRcxR4UHGKPf
         nwNR3yhz3KrZfQ7FConfzItEXyJDOC1qmL2Tbl+OloaSb0DcHai0exshRhF6RSVsXyW9
         9LMmCjVBFbQQT/REgUt8P/kpsl1Fcpbbbu5GBDrreqMyZrhtvts8woRzTXjFZGnM3eub
         Xr2w==
X-Forwarded-Encrypted: i=1; AKwUvByWsZtHZ3gEpZZBAE7gPcO0XkQhGIhG71j9Wu4r1dP2fa3tgn5LMYaBt2MLvq0xvCNNO9apA6tgAl3/PQ==@vger.kernel.org
X-Gm-Message-State: AFuF++k+bdBD3ifI41N1U8a8CJoHDQ827OOWsR2+gBDG4Zb1puwgWOmO
	jpwykEjyvODR/AxWKep99oaU9RnehmNLQqsGirKLvFKT9Wr/1JLxh2OTogLFGAxXASBJHU6wa+Z
	JXhonCG81HiOxgy0lIHdhRpAYKayNqBn5EpKkzrlMCz4zBiaemlpqGOvlNaLEmzDvYOgbfDI=
X-Gm-Gg: AYBFou2fRCGtyeIxf59rTIlmnv7aDmtU826h02Ba+QCvGBpq7eT0hASC0aeEqgTECwP
	c3gweX3euj380wltLqX2JZPZqBXM+TzPz+wB8HURV2Ki3lMO/eMRjG33pYOc3LlBnqdRQXzHKrP
	4WENbhuyMKP+yYQaq9r0SpC+EG/1sV8gNlyCW2Ljw/Qo4u90oQJ/XUzTg5OBhS7IFPHw2EDkgGH
	JfWx/blOJ5NMd1HkG6VbTDPlLEYCajOa5rMQPGqfZhjrwFyINSV0mczwbCC64ld6SLPdlM/HfP6
	XGTEok3y94ay4Q1okdcBoDFlQ9JFo14XFSI9ffVHdxKW0RVcZCkg08OwdW751YDS5btSX3gLM+y
	f/zoLAaNbSG7gGoXkQmTwUW0Dc5o4XfRVpcB845TtLD4=
X-Received: by 2002:a05:622a:1106:b0:530:514f:3c3d with SMTP id d75a77b69052e-5309121d7fdmr30809841cf.11.1788812425429;
        Mon, 07 Sep 2026 13:20:25 -0700 (PDT)
X-Received: by 2002:a05:622a:1106:b0:530:514f:3c3d with SMTP id d75a77b69052e-5309121d7fdmr30809441cf.11.1788812424859;
        Mon, 07 Sep 2026 13:20:24 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 16:19:57 -0400
Subject: [PATCH v2 3/7] btrfs: tests: use eb folio helpers in extent buffer
 memory checks
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-folio-conversions-v2-3-b5fe79f7607b@columbia.edu>
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=2069;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=D3OoCLzA/WlOhaCyWWm23X95M6jgekSWZ6V3R3jvD8I=;
 b=/Y5DThE71Fqh4Inl9uJz9mS6vyWbyH++5OFw3vN3dRa9ojK/V9gBE4fmJf+FPqf6Nue9Rggdb
 oCNsgGJrUBJDAOHXheVo9mmHgXL2lM9dbnVs2Q3kgcYSszDh45vE67P
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: RrUaklUswk_QxaylegbeD_zueh9-AVvO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyMyBTYWx0ZWRfXztgr/3GZvFbr
 to8g9e56PQrfxdoLU2Z+4nIdyi2j9AqeaQuBhmyRJeh7kRQUs28oEXNbIBYGNwyhd0vfUdJOPkh
 VrFzJB8UsC8nUPejdO/J9eKufbLjY713KyrLnTtMmOtYUEIDP7TP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyMyBTYWx0ZWRfX9AQ4X6cMb0JC
 pprgIq1lYUH1SQ7oYOib4muC7eJsHEY8l3DYsYV8cK39HxQKs3a0FYHOtNZCxgw3tS+Ot3i2Lce
 yAOGE59jkaPLG/Syms3ljLd5BJSZLKLf4ZeZ5bQnfIiTiZTljUQ7Ri9pWz9Q5yMR+v7WA10enEg
 ouRNQltOCwNHKG9fpRKoGjSByi1pSWO4zmZu/lEojBlqt+4oraUuX/g61B/pwbj8KCqqICb+rkh
 WG/AefanneQpeNFqZNjBDMaQ8+a2wVNfPNzzqCM1jE8GB4uTzDEnV3a+cG+/9Pwai2UKSSKCIlO
 7pVNGjOGg6MAe3HRMpayfasCIEC8Vjenhbnu9h5XCyhhFITyw9nY8bWjPHYswwbEPCp499DSyoh
 vC6fdbsWLHIszNsfbnu2NZPP1YnjbVPKRqZyfndSMitjbyWXKBWOZuVjfsbB2kfQgz/+XMRIJsu
 5aihEi8Yvn00H75pDMQ==
X-Authority-Analysis: v=2.4 cv=N94Z0W9B c=1 sm=1 tr=0 ts=6a9f1c8a cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=iox4zFpeAAAA:8 a=Vu0au1qQRFuq_hTP11wA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: RrUaklUswk_QxaylegbeD_zueh9-AVvO
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 suspectscore=0 clxscore=1015 impostorscore=10
 malwarescore=0 lowpriorityscore=10 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070223

dump_eb_and_memory_contents() and verify_eb_and_memory() hardcode one
page per folio instead of using get_eb_folio_index() and
get_eb_offset_in_folio() like the rest of the extent buffer code. Use
the helpers and folio_address(). This removes the last struct page usage
in the file.

No functional change. The tests only run with sectorsize == PAGE_SIZE,
and the test extent buffers are backed by order-0 folios.

Assisted-by: Claude:claude-fable-5-1
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/tests/extent-io-tests.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index e7aa8bc04706..777caace717e 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -674,8 +674,9 @@ static void dump_eb_and_memory_contents(struct extent_buffer *eb, void *memory,
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
@@ -690,9 +691,12 @@ static int verify_eb_and_memory(struct extent_buffer *eb, void *memory,
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

