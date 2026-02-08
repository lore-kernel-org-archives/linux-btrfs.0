Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E8432D7C7
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Feb 2026 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770580842; cv=none; b=L/T93Qlv+9FLf8rMn1Demb5eF1rct9DvxgXnXzvIMvAmOIsRFv62QqnoIoiOo2Jqb1d25HPbHiX8j/rnVLNCV/U3P7RaaQnSjenpOnUqsHhCPCQ6tWWPaAF42hvK0askzMkQhcAljBcls5RtpzwuX7CgvprTsyxZiRHfz6wIfgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770580842; c=relaxed/simple;
	bh=2Ix7vMmdhdyS36FbLFB404G3sQFrGouDNPRJM4YlDl8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hA0Y+xqdQMa7qXnL6seM9y0Z+SDA7OA28LsipoWMJJZ0yVyZkRDDUwdg4VxosuMJXFcrAhu13kmElfWh3EpfkAEwlDVxbpuwY37ujmKu9xOxsf0m03tg6fFEfb4AB3a95PQ5f/Y55sp5nlky5ITAjOk+PhmUnvijD8SEuXksFRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwN8PiKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwN8PiKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB26AC4CEF7
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Feb 2026 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770580842;
	bh=2Ix7vMmdhdyS36FbLFB404G3sQFrGouDNPRJM4YlDl8=;
	h=From:To:Subject:Date:From;
	b=KwN8PiKAr3/A7RBjLtd22YJmpsW3uyuNQ3Jeuxa3QQuuq+/Nye3cE7mZk5/35q9Ry
	 3C1ZzhdCJ+PYjj/TXZlPnBcDxKLMQS0eNlN8RkFyY9lTUW6vrTehhAJ2sOormbxEPF
	 hqL+Mn3PCvZJddLkvFsBfzAls6A167IK4CclehxzY80WTSFR1272AodN1fdH8FEtyr
	 grTfWKbalgUNpJZtX49BPQuaLiWV4k/mgcbiUDybvw+f1llFw56UB/CUUx7A4eMi2M
	 3N3Ybx9amWoc9BmzzEk3x5cl6DgaLhDaDOV7/CzbuaK2hxVRsb11hzmpG27sqPwuPD
	 zr9izURFCeoSQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: add missing NULL checks when searching for roots
Date: Sun,  8 Feb 2026 20:00:36 +0000
Message-ID: <cover.1770580436.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Remove a wrong but harmless expression before loading an extent root and
add missing error handling for some root search functions, which can
return NULL when using the extent tree v2 feature. Some places have the
NULL checks already, but many others completely ignore it. Chris recently
reported this with his AI generated reviews.

Filipe Manana (3):
  btrfs: remove bogus root search condition in load_extent_tree_free()
  btrfs: check for NULL root after calls to btrfs_extent_root()
  btrfs: check for NULL root after calls to btrfs_csum_root()

 fs/btrfs/backref.c         | 28 +++++++++++
 fs/btrfs/block-group.c     | 39 ++++++++++++++-
 fs/btrfs/disk-io.c         | 17 ++++++-
 fs/btrfs/extent-tree.c     | 97 ++++++++++++++++++++++++++++++++++++--
 fs/btrfs/file-item.c       |  7 +++
 fs/btrfs/free-space-tree.c |  7 +++
 fs/btrfs/inode.c           | 18 ++++++-
 fs/btrfs/qgroup.c          |  8 ++++
 fs/btrfs/raid56.c          | 12 ++++-
 fs/btrfs/relocation.c      | 30 +++++++++++-
 fs/btrfs/tree-log.c        | 21 +++++++++
 fs/btrfs/zoned.c           |  7 +++
 12 files changed, 276 insertions(+), 15 deletions(-)

-- 
2.47.2

