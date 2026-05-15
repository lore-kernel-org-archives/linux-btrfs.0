Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC97D4EA369
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864430; cv=none; b=LKTYQCoead/KeBo0c+Eug1taH8zXCZtbaH7IOKgmnAfBz6d6DFxX8wKR1L5PGtKqAEGjPwH2z6UHMV6E0/sfiYXJ4ZG/1up7B1D2/+M4yTuyPi8RcbnV0TKwbtKdcBUhCsbHb8FDVOz9FSizeebEhXVpNp9ijgz7q2IVdIGtBZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864430; c=relaxed/simple;
	bh=d1Z/Z8oZj0JotOD806Zqa7TIQmdKOM3QOBCvtP3vMAs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmHXGhH1yxDiP2uJZV66iLSfFAk336092RDsaf1/b/f4B+oWhNOHydR9hM3FtMkaWyUjO/NVnKm+7eiPVSmjPOX5fxwqbgjaHU2G7o7QHxCHTELYv2IdNj0EJZr+5sC6LzMm0p2wYdXmLcfzlD3McKfjPeU1Cno1ulNILDed9SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ouKbcPZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouKbcPZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A3EC2BCC7
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864430;
	bh=d1Z/Z8oZj0JotOD806Zqa7TIQmdKOM3QOBCvtP3vMAs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ouKbcPZnk+Q8V9SOBM1Rz5mlPEBZytCF8tvWxxcJyEVsixTzBrPX2pZwAshCqTLWr
	 UTZfd6Rf60TcDIQUqqvcYfLafQxbb255oAWbhkvfBzC6HXbogD/V4ty4+yd1Wl88MT
	 sUGP7EHKtNWEe1bGCN8Xw62mEUGJwf8CLRW76EbzkHyX6v1xW6knHjTldsmw3RoogI
	 Lc/+0YkR0FaxDHC76UUFVdF6l3HlGgfP6qnSLwvy5JQj++EVcv7zkIscbyVN/7tLzj
	 nhgeH1fBKIdQHIkFkgfy780wcuTeMf+LtTm3owBl5p3PXx36nEYKv+zP8UhmHfRgla
	 Infh/vSiK8ZTQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/28] btrfs: tracepoints: remove double negation in finish ordered extent event
Date: Fri, 15 May 2026 17:59:58 +0100
Message-ID: <4dd64f0e9a2f3a90ebcd23f83880b10622bf21e5.1778776706.git.fdmanana@suse.com>
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

There is no need to add a double negation (!!) to the update field because
the field has a boolean type.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 include/trace/events/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ec1df8b94517..99ae9c923070 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -670,7 +670,7 @@ TRACE_EVENT(btrfs_finish_ordered_extent,
 	TP_printk_btrfs("root=%llu(%s) ino=%llu start=%llu len=%llu uptodate=%d",
 		  show_root_type(__entry->root_objectid),
 		  __entry->ino, __entry->start,
-		  __entry->len, !!__entry->uptodate)
+		  __entry->len, __entry->uptodate)
 );
 
 DECLARE_EVENT_CLASS(btrfs__writepage,
-- 
2.47.2

