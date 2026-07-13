Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C58394498;
	Mon, 13 Jul 2026 07:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783929045; cv=none; b=MR1cko1+IhyCy5sAQvrbfx8bJ5wo4B1IavhE4JZO3V7a1sIzsEuJcOWGpckIwHqnO+VrQZ5Bamz2+yUDLCiD83FavVsxVEYahILcj8T4vlrgoT9u0SQHqNuGG3xTEMG2A98zxnk0nCBAbbkZaHvT5gZK0DBKRcNltJd7Nfdg5H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783929045; c=relaxed/simple;
	bh=dhHdvMniZ+p1YnsqUE07B8nR78DS0Ma9U7S7/PbD6Ws=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hmPSEmPNJ0jbMqmegG45W8Edq4QvYHZ7yILVYiTBsBTS5rEcRRzdcZWxe0MqqgJT8kL2nny+dQS+B6BoxLxKnb8Dcuk82HK5avXRprag7BYtQgcMp6XopObs+h98tFVDwxPVfvyITne9STRZ4nSWe3cJK1266Tw2n8RdNZyTRuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqmsSsbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqmsSsbg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 962EDC2BCB8;
	Mon, 13 Jul 2026 07:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783929045;
	bh=dhHdvMniZ+p1YnsqUE07B8nR78DS0Ma9U7S7/PbD6Ws=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=dqmsSsbgunV18IK8TNJYJW3V8Q+owMa31GhJT1yIPx8iuGFe3kpEXKFcOhowORRQ/
	 zSOJZ5RsDDKQ0//gLFgdaivHhMV0G6mFd+MMhmdubHx+PId/QAisB2hDHFxrio/IB2
	 lGbx64On6hJeT49+MrUXIGcoqvFaj7vwqDV2kymUd7zo230Vs6dJ/LxSYccmzp5n6f
	 DZniRSUYy6Kmut2d+wJQe3XmIZncplEDyc7AICTFHvFIjIJMlVqLU2HJbCsmHRTznA
	 vB8cr6byMS/zFRyForYd9cveHUYKZrcp/XdQQZFP2yPh7U76xT6PaVJbj26gw+0JK6
	 gyDlHcN5tuKDQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75586C44501;
	Mon, 13 Jul 2026 07:50:45 +0000 (UTC)
From: Daan De Meyer via B4 Relay <devnull+daan.amutable.com@kernel.org>
Date: Mon, 13 Jul 2026 09:50:42 +0200
Subject: [PATCH] btrfs: fix GET_SUBVOL_INFO after compat refactor
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-btrfs-get-subvol-info-fix-v1-1-a58cc55b3696@amutable.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0Jm7SSFCopXMS7aOoUabclMJSaEu
 9vq8r389zcQ4kACl2YDpjVISLFAe2jAzSZOhOFeGDrVDerUarSZveBEGeVt1/TEEH1CHz5Ioz4
 rPXZD3x+h9AtT0b/v6+3PJXmQy/WwLqwRQssmurmql5FMDPv+BTjRLYWWAAAA
X-Change-ID: 20260713-btrfs-get-subvol-info-fix-e93803926554
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daan De Meyer <daan@amutable.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783929044; l=1552;
 i=daan@amutable.com; s=20260712; h=from:subject:message-id;
 bh=vVP53OuHGDy40sn2DMIfpWSsyPYGBiXasZnLFp5kRLU=;
 b=J1JUl3xjGtwRu5ju27HPgoCd1IqtuwlM60B54A/8pkbbE2YCre0ueg8zBojWxW8JajFX8UqiT
 YZXzfh8RG94AAn3Rj3MrSssZcQicQY9hffI0/1JT0Usju83t8353woC
X-Developer-Key: i=daan@amutable.com; a=ed25519;
 pk=I1l+WwrtmzRgofA5SQ1wTuJi18fjh91w+f5uRkFeZEA=
X-Endpoint-Received: by B4 Relay for daan@amutable.com/20260712 with
 auth_id=868
X-Original-From: Daan De Meyer <daan@amutable.com>
Reply-To: daan@amutable.com

From: Daan De Meyer <daan@amutable.com>

btrfs_search_slot() returns a positive value when the search key does
not exactly match an item. This is expected here, since offset 0 is used
to find the first ROOT_BACKREF for the subvolume and the actual key has
the parent root ID as its offset.

Before the compat ioctl refactoring, the native handler still copied the
filled structure to userspace when the search returned 1. After the
lookup was moved to a shared helper, both native and compat callers
treat the positive return value as a failure and skip copy_to_user(),
leaving BTRFS_IOC_GET_SUBVOL_INFO unusable for non-top-level
subvolumes.

Reset ret after successfully validating and reading the ROOT_BACKREF so
the helper reports success and both callers copy the result to
userspace.

Fixes: 538e5bdbc899 ("btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO")
Signed-off-by: Daan De Meyer <daan@amutable.com>
---
Fix BTRFS_IOC_GET_SUBVOL_INFO for non-top-level subvolumes after the
recent 32-bit compat ioctl refactor.
---
 fs/btrfs/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..ab6c17716026 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2042,6 +2042,7 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
 			ret = -ENOENT;
 			goto out;
 		}
+		ret = 0;
 	}
 
 out:

---
base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
change-id: 20260713-btrfs-get-subvol-info-fix-e93803926554

Best regards,
--  
Daan De Meyer <daan@amutable.com>


