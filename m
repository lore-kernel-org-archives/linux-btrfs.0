Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B64E3764
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864435; cv=none; b=UmB2p4/tr1i1deGRKWTsBeCOmkuRiblcMBd0vXvYXYvOiKnxQGNT36saPPb+bVOaZMUxHXNtKfAKNVGu9ITkmimQEoYu+DGs1ofyBLPEO1LD9qOuwStmSSuU4tjvrYnmV2317zCcigD2hPwDinnfpPCQxSCnjR6RdBe/8ia5WW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864435; c=relaxed/simple;
	bh=RKIvGAC5aA7ETUEsnndtSAg4dvW+8DMmz9SZB1EtRf0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCa2Ty70mMwOVEyNGxl6UDIExTbkOBM5ApqhChGVb0Xp29etdThOtTQdS9SsheZlHnEOWzpHxysBUDJ0bVeZsfQaHxkgGhr9pSipywPQNGsvgkDH06rVvJ2dEkPWCderKlMqpM45yB/RE7f7mMOV82H+UfNlnN/TXFY5lM6mDtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJuh9lQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJuh9lQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE70C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864435;
	bh=RKIvGAC5aA7ETUEsnndtSAg4dvW+8DMmz9SZB1EtRf0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QJuh9lQg4XaYTpAmPSKDydyHoD46dWz2dcB9P5f5vhuB7/oBbtD+Z+6AIuzK4T5nQ
	 PrIoPISdteprbOeRjzKC3403Xjrd0U40mCfo+GLlxFDheVrRYDWevscs7FHxg3otg1
	 /wk728gZz66wflfIEOFF55sY7iNqIltBpP2YjtsEpYstVmLcZ37njD2uRlGcmW3sk+
	 IltXHVHOC/4faN6ckrtrnhYvU3qZOUT6ktasiL6vhMK/gB30ABoA3+XBp+PN0bbw+F
	 enHEUdB4c9breTYvPHnuNd6QQIkf720oGsXk7mSe1oOBunGm97qLV1tEvEY9nH1QPz
	 OetzWPAg7el4Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/28] btrfs: tracepoints: add in_fsync field to transaction commit event
Date: Fri, 15 May 2026 18:00:03 +0100
Message-ID: <80855d2e7d7aae0d94c08e724676149b6711dd01.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Include the in_fsync value from the transaction handle so that we can know
if a transaction commit was triggered by a fsync call.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 include/trace/events/btrfs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4cec2f8838f5..4e077abd6704 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -189,13 +189,16 @@ TRACE_EVENT(btrfs_transaction_commit,
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,  generation		)
+		__field(	bool, in_fsync			)
 	),
 
 	TP_fast_assign_btrfs(trans->fs_info,
 		__entry->generation	= trans->transid;
+		__entry->in_fsync	= trans->in_fsync;
 	),
 
-	TP_printk_btrfs("gen=%llu", __entry->generation)
+	TP_printk_btrfs("gen=%llu in_fsync=%d", __entry->generation,
+			__entry->in_fsync)
 );
 
 DECLARE_EVENT_CLASS(btrfs__inode,
-- 
2.47.2

