Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B113A48ED;
	Tue, 15 Sep 2026 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481890; cv=none; b=pQCy+L4MlJn9uWRO5O5o+nYdgYjUHN2Kb7fMXrtF84WGB52wt1mqIDXRoMlBK0MmYjTcafpNM05VI1keBFsVZisro99WmEeTK4sjSsBqJn3HCnRLEYqxohsS5V+PABqwD/QVLO49uJWIFgBcWkpe75jG/JivSs7jbdA8oefF7JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481890; c=relaxed/simple;
	bh=7vCsz/AWWa2VE65Y3Mq86s+Dxv56e2eCaTq73jQ/8E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eK7jbB5lYR/FOVnd8dPuvM+ZLm4b/ZS0MiIAU+QLu7bQNQ+86jtAGZL3HWY3+4PLhjpHu/XT2RXsNWJqhmp9ScDTJAm2qqpbHcZ8cxjDZ34ehg/PLYghVEmVnmCe3QzOgWpONvgW1R+VFLF1j874a4WMJXWNJ2Rt+b0bjGpLHos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=h0EQ5hr0; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=TY4oAn3L; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="h0EQ5hr0";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="TY4oAn3L"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FD1Yar512493;
	Tue, 15 Sep 2026 10:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=w5GVgycm9iio
	WtYxRz5DrhYEDVBsXdghCzEm73f+FCo=; b=h0EQ5hr0Gkk1GWi3llS95wMhSA+q
	KQ6GpU/+x1pFgUl9ETJkpXw542iVyk5uP6bRxDTqtWnb7HMBbg9P8QylvTuqpkuI
	z/ZfHvDIK33czICZYMUJs0dWf1Q890IXiJzHoIpo5zwv0+wHnMyqre6jryRe1aj/
	08jUtyy41cpY0nIBqCWM4KpCxv+GOBQXEYrXxsJArURdgjQBxCKwWHGq5rGR9xMU
	+75Dl/uczuQEZ15RxIItSd7wxmWiowvkuz3WcEZeTPkwWR+at0ueyebUinJ4mu++
	6FNS5+07QYLHbbWxkQFWpx5mp/OcjVPUL7l/lXLIfmGGt2BJBnQZqkwLJw==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn1w7uskc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 10:18:07 -0400 (EDT)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FDxS9I3661268;
	Tue, 15 Sep 2026 10:18:07 -0400
Received: from esapsmtpat02.us.dell.com (esapsmtpat02.us.dell.com [143.166.211.150])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq4m0k5v9-6
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 10:18:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789481887; x=1821017887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w5GVgycm9iioWtYxRz5DrhYEDVBsXdghCzEm73f+FCo=;
  b=TY4oAn3Lwt7DtpduwOlIoj6hzCMQZyF5Wh9MqJFnhxXjm2PPLEzBpME4
   U6I5Mb6r0z1I/qjtJsyR+8fZ94s3WeIZtBlVW77fabQ8ZPzNNZjsx+B3Z
   v97yjuISJtINjeTtPkF8y3FtyOlOS8Oz5iEEoZupp1h/Dt9hMw04Kf/nM
   aWAE1AI37/fB15qDj34APpDMXbAAylXRyj/fyJ0dK6IhEBufxDBYPFORn
   1CaediGJtk8oXV8gmf8x5GsK2VdVte0kXoCRTt+SMVboxOp3gCy+UMiDm
   4tNIbcKGIvp3Xai0nsjXVyEm+DCZkkzm2KCR8naQqECf3kbi5CX6rCOF/
   A==;
X-CSE-ConnectionGUID: aidQTG6ZS36tKW1It9tOOg==
X-CSE-MsgGUID: e7ry+5CHRCiaL2cbgQhXHg==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat02.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 14:18:04 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Qu Wenruo <wqu@suse.com>,
        quwenruo.btrfs@gmx.com,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/6] btrfs/273: add missing _require_scratch check
Date: Tue, 15 Sep 2026 14:17:44 +0000
Message-ID: <20260915141745.4299-6-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
References: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150207
X-Proofpoint-GUID: bFTMMYtpaGQXhw_gEuik3Pm2OdSUA5vq
X-Proofpoint-ORIG-GUID: bFTMMYtpaGQXhw_gEuik3Pm2OdSUA5vq
X-Authority-Analysis: v=2.4 cv=e46T2qp/ c=1 sm=1 tr=0 ts=6aa9539f cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=i8a7nF7jFa3EbZrjgrQYpA==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=m3zZTHMLHbwB7Lmtoed2:22 a=iox4zFpeAAAA:8
 a=JF9118EUAAAA:8 a=iLNU1ar6AAAA:8 a=Njldb1lUeYC0AmfNj4gA:9
 a=hlJyneSgMmFPbskH-t2w:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=xVlTc564ipvMDusKsbsT:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfXzMaSe3Qmoglk
 c9Ge2jx0vh/64efmCrFtjnbJIQfgV+O7bfFerxbYolQxstEWrN16iKYPR8GgXFVWnxQcLVoT9UX
 QVgxFqFH95P50O6Chw2OFwHfXHj2/u4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfXyYklYhA6E2sG
 9vHkrhNsKcYE7WheuetVhbFXgrnEwSydRcXX8QKC2tGGY3nU1O1J21lTDZl1IJpu1X42F3dbCxT
 J0ZUwIXqVwtN586SWUpNWqHg1MupdkOUvuJQiF2W1v8l4f/FcrWD5CZdNjhctbaoa1FQqgQ8g6H
 /ELpQ/G+/V0E6uI+/wfihBdab+zK9THBFGYCWavR+C1fJVAFH5TA6+Bwe/liksTzRzN4ojyJsh9
 /ZSI0xyh7/mHDM9xLntb/8nu4xLJ7MhCNpwKpRpAMk4EX2aAh7Y6tJw0WynrscR6DoUmFKdU/Os
 HqUZ6GuYpB1bbOjY68sFVg/4pPLaaEaOr8KyOL7xEaqAEHIbH+F/lLmkHeODCzB7dIpnv+asiOQ
 rNmGCunC51+bh/LZnRh6p58O/ghdUWa4eA6HdrT0oj4QTuW7ctNQhmy8EVLXuha+5V0doWMO2NF
 Jo0JHgItp7wNJ9lzErA==
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150208

The test passes $SCRATCH_DEV to _require_zoned_device() and mkfs/mount
without first requiring a scratch device, so it fails messily instead
of skipping when no scratch device is configured.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 tests/btrfs/273 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/273 b/tests/btrfs/273
index 60c3967b..197cfb02 100755
--- a/tests/btrfs/273
+++ b/tests/btrfs/273
@@ -28,6 +28,7 @@ _fixed_by_kernel_commit 2ce543f47843 \
 # which is further fixed by
 _fixed_by_kernel_commit d5b81ced74af \
 	"btrfs: zoned: fix API misuse of zone finish waiting"
+_require_scratch
 _require_zoned_device "$SCRATCH_DEV"
 _require_limited_active_zones "$SCRATCH_DEV"
 
-- 
2.55.0

