Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95971DE8AD
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 00:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772151108; cv=none; b=gLJ+teSTTHRF3sgeXSJIfgmUNZyrm/StwJq+AhRo5xIiYPwjwifTJHVjOSSPAnYuifd/zW9whF/h8OphwErRk4knk3dFNxVYOZdR0SibEDhBcUX0uebcgnDxIxzMkuZASTzoNFDd0hd35T084PaXUTk+vOA/aAIqV+lgMH1MXcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772151108; c=relaxed/simple;
	bh=ZeUPB3HcPy3SGvLzDwvsj+W75tHGQF4BITEk6DnCCks=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SG6IeCA0B+/Dxa19/MfD7+0uPepIrOG1ajZFFoPH3RwxPNrZHJiFpZ5JQHDph1wkCl+z6tUN3QtH6qS1hcPbR4UpIVb0Ll2Zoew/Ob0GIA20BOKyKATFgYbzuslwGR9mDBU7XKYjtiXJR4Wc5IiJj+s+JNei8erU00IheZmYt1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFSEsnM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFSEsnM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220B1C19423
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 00:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772151107;
	bh=ZeUPB3HcPy3SGvLzDwvsj+W75tHGQF4BITEk6DnCCks=;
	h=From:To:Subject:Date:From;
	b=HFSEsnM2jlGciqqrKWWGomBrKTOeGcdyT5SHu0YoAlVx+VWm/Bxormwl2MIiV1Qwq
	 hn4k0d0vVuJ+aDVQ7d0THNhtaIMerhEEQLUp7Ra6hb5YA/YinO+FaBwYYFsJxXLOaT
	 q707wYmw3fR+x35A+f7s18E4+aWBTer1iUsCobCuebVgK9d7GQ0Ye13F90lHmRhenQ
	 zEeXl5HsDVcBCt1R8JLY2GBU20wzZApkjdhuXEvsXfCJaRqizuJ3HP2k2/lEm8H5Ir
	 W6FR5vFVSxp+7CDFGz00Oj28EVOtUPxuG5b8pTCLrLRblfHjbIRBcHuKXmbDZMffgg
	 mmRVfW+fpFI4g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: fixes for the received subvol ioctl
Date: Fri, 27 Feb 2026 00:11:40 +0000
Message-ID: <cover.1772150849.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Fix a bug that can be exploited by malicious users to trigger a transaction
abort and turn the filesystem to RO mode by assigning the same received UUID
to a bunch of subvolumes, plus a missing transaction abort if we fail to
update a root item, and a cleanup.

Filipe Manana (3):
  btrfs: fix transaction abort on set received ioctl due to item overflow
  btrfs: abort transaction on failure to update root in the received subvol ioctl
  btrfs: remove unnecessary transaction abort in the received subvol ioctl

 fs/btrfs/ioctl.c     | 23 ++++++++++++++++++++---
 fs/btrfs/uuid-tree.c | 38 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/uuid-tree.h |  2 ++
 3 files changed, 60 insertions(+), 3 deletions(-)

-- 
2.47.2

