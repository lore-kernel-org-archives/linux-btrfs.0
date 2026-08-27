Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552DD347533;
	Thu, 27 Aug 2026 19:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787859071; cv=none; b=Ubvp6KWHeg61VfS/jRivud8AbzVAPkrJJUfofC4Ei1jzu41OHqbbhyCbGu5IYWsSRP1GSceSCvJ4NW5B5uxZSYB0u5MglFX6dar7c/RLmovQzRKGRho05Rb5xfGayM2Fe4bINbqhMvIdU5Qu+uw6xqA9qZ+dkGPfNbKwiszuv04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787859071; c=relaxed/simple;
	bh=dkM/eV2i8ziNqb0JFSIc3qrWW3dds31N8UuB4ZqUZ+0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PsRvQuRAAxcQqMc4HLT1XTAu88s3TrKP2z8dWZdQrpVH7F2iHjlJVGfAyBaI2l59K8PUeaPMQ9O47GG86I0RkcjKOvMsjPEPN4awA0v45YF2cpV6sCiSBOsvqVeddwU6GqHR1t0IhW0wO9/HVf5G4I1ASi0WB66zPgvIUQW7nT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Su7CpnaH; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Su7CpnaH"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RJM83G1856212;
	Thu, 27 Aug 2026 12:31:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=shF7wMAjN
	GRHtx3LeWbd0oPw0D1xUZvDE6iVECoHxf0=; b=Su7CpnaHwZkzK+bUj7bqW4DuG
	emV5msdzWh1nAeETEgWhYDMN//rxdFJ9IvNNuh25SYlgf7KWO0aeLcw+g0vc0DtQ
	QF8gQR3jhnAGEry6+PG2TmERTvN8hBTjWDNBWk5RoU7h4a6Xb1Jo0k6v2kbtp0Hq
	BChYNWkIZkywXkyCi9EU2jkQlRjrIJtypxLdFazgS39BYygj3jxg+gPNaxx6oMtm
	a25hrVCiHfjW6KH5zFc1YIIqvSY8457vkKXp1EGlciyWYGBzpaO3ucOrY2wwfgX6
	hBO2o2XroIpewyLOrFy777+AMb1JWTvxRfOtr04p0YzLOuO4FrFoGZmpm5BSw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gak20ksv5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 27 Aug 2026 12:31:05 -0700 (PDT)
Received: from devbig011.atn7.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 27 Aug 2026 19:31:04 +0000
From: Chris Mason <clm@meta.com>
To: <clm@meta.com>, <mason@kernel.org>, <dsterba@suse.com>,
        <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] Update my MAINTAINERS entry
Date: Thu, 27 Aug 2026 12:29:15 -0700
Message-ID: <20260827193032.786461-1-clm@meta.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDE2NCBTYWx0ZWRfX/AumBnfjYn1K
 JuFtNZPOzdWqS2U/edZ3NfusakdLDi8YBXtuA1+5bz7DBaUYwhNlGCIObMHqzVs/IdL3VTME/OM
 8htzN5VLzMcO6u9D671pWtlGxk1bsYs=
X-Authority-Analysis: v=2.4 cv=D6x37PRj c=1 sm=1 tr=0 ts=6a909079 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=4h92JMTCafKA-fb_NiOh:22 a=VabnemYjAAAA:8 a=FOH2dFAWAAAA:8
 a=stUR-zCGr9S5OmqkrUgA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: dBj6E2UZq9g8A3rgBEbw9KFLJ2onpxgc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDE2NCBTYWx0ZWRfX2f8XRKmIWhM/
 L0oj687U4MgVr4RGj1PCqmWTwh9hE9srnCBUgVD4qvTukRrE5YSPCMCmhqb1/bAKVsOLy+lYrIW
 469AeEELp/2cMzx+VHPtblU53Ok4pg3y/9FnOH7JZKXMm2t9WcasCFsRuYRFsboRGKhq+seFH96
 DlPaG/53y8E3xjJjqaQ/KZS9omKoL39jAuHTQa9eLnXQjPQbS7eECseM2iiOIQbki6pgjf4T1zp
 gFtqggVzmAmfRpu9bVK3b0AVIzAMUehIZkyjgTL1dsx4zYoe/ZYEPhWNAIzn2mibzsqXstkwDos
 Ag4pXPT1uBuPenciDrWFKk/SWfg10UleLFVtmJeFtzyjmr+neUG2k++Oo15dyg8+KOZCP1VyIKL
 pmbPSC5AQZcce6mMbD71mXJ5bRa3vcNmrok5xUn2nv0F2BoyyPkaMYvCB5QHehuIKFhcxJKCHKz
 NOQnfilcVWaRejC3SnQ==
X-Proofpoint-ORIG-GUID: dBj6E2UZq9g8A3rgBEbw9KFLJ2onpxgc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_08,2026-08-27_02,2025-10-01_01

Hi everyone,

My last day at Meta is Aug 28, so my meta.com/fb.com emails will stop
working soon.  Meta's commitment to the kernel and btrfs isn't changing, and
my own kernel contributions will continue as well.

This update better reflects that I handed off most of the btrfs
maintainership duties years ago.  Many thanks to David Sterba, and all
of the btrfs developers for their work moving the filesystem forward.

-chris

