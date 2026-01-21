Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE834963C6
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013061; cv=none; b=PFNmTRnSikmT4nxCYP2ak44couDRO/s5lvRJVPmumMxgNI4dI4uhMKQTe/dZE3O15aL4GnyhTtNlo2snkesosIgxIUZLVjDfJPf37SNkOlaJ2Cx16iosIFQ1ixMYutD69oxveHfRO7TO4OsdTC/8xvbL3+LjdkADoMVrwqm/nFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013061; c=relaxed/simple;
	bh=AFX21W9vR8YpM42S6GNoRm6OKklQMMJbuHfdq6MEIbU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcAi7xBWekxE1SDOg7Wqc2UewSjbujyE/FHSyOnVRXWH4PabRFn1DHn3UPyWuTlg2MZAEZhFIZdCs9+jQOczX8KyYFLuZiWrSQzYuYy8cvZKsLid5uqoXFYq8ZW1HIGWzM0w6wzIYXViJCwnUtCWK+c8j3Tbou+i0ZdzwyraehY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fju4TvC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fju4TvC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412C5C19421
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013058;
	bh=AFX21W9vR8YpM42S6GNoRm6OKklQMMJbuHfdq6MEIbU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fju4TvC/NICi00m1nm32HLeg0wSVL5tsMVMPwrJznoD0r7LHR+Hg7Oib0G+3vEnol
	 LfVKrCkL5yFIz6Yh24+sWrxdLCRw0EXy7NiAmtxVwdxKcmWGc6qnlsT56l5nQ8EAed
	 7bQAEifsTC74t8DEnGJwOk4J1pKm8HpTfnOuLGhNw+C5NtBvJScEBGwHOrnqWEGz+V
	 ROCKkVINuRxxIJht6S+Q38pmT2Ih/apa9GcTFuAHuOsCs7D7bahxyT0lnoVoSmwSt4
	 TpjwXDFOSz99wxYjJYzUyLScJDkn0K0mMKGboV4BucprMx58qEzqisJEcm137IkIxC
	 CF6HmhwnKiJ/Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 11/19] btrfs: remove out_failed label in find_lock_delalloc_range()
Date: Wed, 21 Jan 2026 16:30:37 +0000
Message-ID: <f48362da81ba92808783c06d91f07691f5da8741.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'found' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dfc17c292217..3df399dc8856 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -440,8 +440,7 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 			loops = 1;
 			goto again;
 		} else {
-			found = false;
-			goto out_failed;
+			return false;
 		}
 	}
 
@@ -461,7 +460,7 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 	}
 	*start = delalloc_start;
 	*end = delalloc_end;
-out_failed:
+
 	return found;
 }
 
-- 
2.47.2

