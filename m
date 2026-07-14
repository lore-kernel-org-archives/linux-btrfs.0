Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41658379993;
	Tue, 14 Jul 2026 06:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009550; cv=none; b=OA2p7sTnlHMG9k+xwEfv9jDsgzIzKEW9y7LffygehL2VkcBmV0uozXLWIv3UbOYUfvPlL28GtQSzvV+swuC6P5xR859o8uTuD6gcvmvfM4I8ANQlLNK74qNbLTlwNqyzy2uFTOhDkF4VzCZnT2V/qLs6NFVBlbZnR6YpfJEomOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009550; c=relaxed/simple;
	bh=I3sdBKAmO0SeY2zt3MOvcRQ7WfaeQzmVcrmsn/51Cz0=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=mIgb2fJ2GpEjdSVUyVPamxiYbZ6xnPO/qsi/ba6DP2RoPKHAyZhqUzD8njFYneSrmqueCXuukSau4OqAKHaF6kCskwBlq5b9WH9hylqxUL9E68dLnpdvFz1M5kJmaGbGsLpaQ3D1jrS4AWSG/0s4Mcd4jWD2YJp1kjPNcT35CnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=dM/Kez1Y; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="dM/Kez1Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784009537; bh=BA4hvoA8aBr7w9Iq8BFFKNw4ZJlJqNVxyv/ObUEiY9I=;
	h=From:To:Cc:Subject:Date;
	b=dM/Kez1YgprS2QaXTzwc40V0ZAYsJMUFGCzwVw4etVjHHEpyii4ueL0D2tI0YWtTa
	 EQqFp3owzyToSQr/7Ha7jjhxUslgZ59XGeC0uvcfzvoDWOv8kTED8S6LJPX+5v9De6
	 e37GnrFxPXhyHfSGTeYrYsefKgTNrxbwrDTix7Bg=
Received: from ikun ([221.176.157.250])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 2C6982AA; Tue, 14 Jul 2026 14:11:06 +0800
X-QQ-mid: xmsmtpt1784009466tzbuyr115
Message-ID: <tencent_3DBB43FCDD4420406266A92678AE15833C09@qq.com>
X-QQ-XMAILINFO: NVJ0hJNx7N5SXgPSVEYKvni7SKNNDTyuJ3Qqcv9hJv22lr2p1GofsdiiQEsPiq
	 RS74FEyFfMvETbj4Ev2S0EgdTj8P9ZvfVjk0ehuDOlagp0m9F4HTOSTGBJ9H7xCbFSfkVt6VsnGo
	 f6amhXYR+EgeQfg4XZ8kYkd95ewrCuAfarmAhPG1nFCE41+mkyTPvRUrzdT+zH+g5CigwPAOrHQ1
	 LXNtmg+h3LFBLz8Mgumu/gEIS/HaZEqMaPPEhrUgBo9Df9SlITmCj81G6dW7/50cy9yizXeTzTc3
	 kLVfQ+cZKu/DsslLVhWDGKS7gFmRbcdftHDRRDOGqkEDT06I1qnXG3cTq81ahphv7fyCwBi9rz2I
	 kS2yzrJzN7nWrNt0DlIbOcojzx/6oE2zWTCrSdX8GWfUt/7H6w7DHDZ1XYYXiESE4cDYRJs/5aMS
	 1O5Gi9yCuLbNx1Udvq1Xnj3kTlakbuSD2boofqxSDweAOkkNKSzhzIwseo+oGBLHSdQebTNTrHl0
	 u0lk+iTfrMO0/eGoJ8BHecrcSR8C2UzgXSpZE22rPjCCyhi7gIGObtQ3/3o28xU1QI4xGd1HIjhd
	 zbcsaYt2ZVb+ZS6ftSvzYcz83d4n7jMTCt0yMar3vHUMIBmEerKeJzvvqyqUWMp+1INXtfBD9amO
	 r3gvzu/5jw+Q57o+Jt0ceB1PiCCoIir7SiU0Oopc6chHpzF/2RVgNdK/ZeT11TKmgXn1hdewYObI
	 2yguolkcx7kVtWLvVtifRCXnzpb/qwYoM+xKwDZ0TIOYmRjMB0Af/ic0hCIkHqSkrPJfNekw2M/n
	 9ylzwS2zPVdT2X/lNkZSMvx2OMRvnyCbojdfmDvDKCj/9AyAJw3anCBeq/bQP/i4NKJxrs1NuVCP
	 h14212d3ADQppu6YiYC27XoI1pcp6sw7AFpXtW/gMNjkGMZSQmxxSsjbdt8HG9INZaV1FqGQ8ZF5
	 4V4ri04y2MmduNOON1P3qagAru0UOk2iTwB/jWQ//fG+pe8X7vMEecm3dDbrLZl6RDESHqhl9KLa
	 vQ93bCYPmfjPfoMN2eAhNJ7P/gthhQyncmfxVIAr5f2bMN7bSC3K6hBUUMCb4=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH 0/3] btrfs: fix failed sprout device add rollback
Date: Tue, 14 Jul 2026 14:10:34 +0800
X-OQ-MSGID: <20260714061037.1014-1-3497809730@qq.com>
X-Mailer: git-send-email 2.52.0.windows.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes the error path for adding the first writable device to
a seed filesystem.

With fault injection after the metadata chunk creation in
init_first_rw_device(), the newly created block group is drained by the
transaction abort path. The problem is not a local block group reference
leak, but partially installed device state left behind by
btrfs_init_new_device().

The failed sprout device can remain linked on the transaction device
update list, latest_dev/s_bdev can still point to the failed device, and
the mounted filesystem can remain in the partially initialized sprout
fs_devices state with no open devices.

Before this series, the injected failure triggered:

  - WARN_ON(!list_empty(&device->post_commit_list)) in btrfs_free_device()
  - a NULL pointer dereference through btrfs_show_devname()
  - ASSERT(nr_devices) in btrfs_statfs()

After this series, the same injected failure returns -EIO from the device
add operation, the pending block group is removed by the transaction abort
path, btrfs filesystem show still reports the seed device, and umount
completes without the above warnings or crashes.

Guanghui Yang (3):
  btrfs: detach failed sprout device from transaction update list
  btrfs: restore active device pointers after failed sprout
  btrfs: roll back sprout setup after device add failure

 fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.52.0.windows.1

