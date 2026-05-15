Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E964DD6FC
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864430; cv=none; b=Vmn/Jz4eTQhZS0zFdrAqXLuLier+Ej9/uJFhd8K6jEx9UjaXzgvZE7hCgha+iojv4QNgUigeNmujJkQJ3saw910QqQJeJpw3+yGtvpoY7MowvR0QCp3Ht/Tbx541yAZmK3W80aVhrFMUc7lwzqDUKLNgUd9qAAgBSTIexwZfzjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864430; c=relaxed/simple;
	bh=CFLSqTDXvm3VZkDbZg7Qq++Z3OTgzEQe1aj/s2wSaIk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IFhHCMG/j6A5EXXcCHRIqYx+tSMUFr6GqR1wQd9H6fDiJDTf3NpZCLhHPV1COZSa8agrrNx0by6ldOMwPj3aVPbcEyxURac4czcd7XuiYgEGocnKLoB+Utkasq4G9GfPpsXHn2q3L3ZrvJ3G4IHnbHEKmm8X0L9qVyKBkaY+cZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+Erhp0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+Erhp0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E758C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864429;
	bh=CFLSqTDXvm3VZkDbZg7Qq++Z3OTgzEQe1aj/s2wSaIk=;
	h=From:To:Subject:Date:From;
	b=n+Erhp0GyX9oigFGgOz3vqmSjOPWtcSeX0AblqpsydIkgMCNuzpkEf12swzryQpvu
	 8yQwsvaeQjTfSMfS27RURq8u/OW5Nbe3gUUlyr9UhKoT+6nf2foFF3UZdLaBA05v+t
	 15FrJZ+22SoahegJeZs5raWn7rv74i9WWwpWL2k+46JnbyvuPbibNrmCNWmFq1u+f9
	 qh1ITQmsVfr1kKzmia2KzTyOi0cnbUQqo2XBHpIQ7SYnToV22q5jwRrctfZ5bomGQl
	 jZca7N38M18Dv9PhiazgGGXNvHEnKJ5oakaQ2oOByGqhOtkjWworDCfuifd4inQPny
	 FFz/OjB79+8cQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/28] btrfs: add trace events for fsync and inode logging
Date: Fri, 15 May 2026 17:59:57 +0100
Message-ID: <cover.1778776706.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We don't have any useful tracing events for fsync and inode logging
operations (which also happen during rename and link), except for a
tracing event triggered when we enter an fsync, but that alone is
useless to debug fsync bugs.

This patch set adds several trace events and improve a couple existing
ones in order to debug fsync related issues. These are based on most of
the custom trace_printk() code I have used over the years and were useful
to debug bugs.

A few cleanups are also included in here.

More details in the individual change logs.

Filipe Manana (28):
  btrfs: tracepoints: remove double negation in finish ordered extent event
  btrfs: tracepoints: remove pointless root field from transaction commit event
  btrfs: remove call to transaction commit trace in warn_about_uncommitted_trans()
  btrfs: remove call to transaction commit trace in btrfs_cleanup_transaction()
  btrfs: tracepoints: pass a transaction handle to transaction commit event
  btrfs: tracepoints: add in_fsync field to transaction commit event
  btrfs: tracepoints: add trace event for transaction aborts
  btrfs: tracepoints: add trace event for the start of a new transaction
  btrfs: tracepoints: trace transaction states during commit phase
  btrfs: stop checking for greater then zero return values in btrfs_sync_file()
  btrfs: remove redundant writeback error check during fsync
  btrfs: tracepoints: add trace event for when fsync finishes
  btrfs: tracepoints: add trace event for btrfs_log_inode_parent()
  btrfs: use a named enum for the log mode in inode log functions
  btrfs: tracepoints: add trace event for btrfs_log_inode()
  btrfs: tracepoints: add trace event for btrfs_log_all_parents()
  btrfs: tracepoints: add trace event for log_all_new_ancestors()
  btrfs: tracepoints: add trace event for log_new_dir_dentries()
  btrfs: tracepoints: add trace event for add_conflicting_inode()
  btrfs: tracepoints: add trace event for log_conflicting_inodes()
  btrfs: use simple assertions where enough during inode logging and replay
  btrfs: tracepoints: add trace event for log_new_delayed_dentries()
  btrfs: tracepoints: add trace event for btrfs_record_unlink_dir()
  btrfs: tracepoints: add trace event for btrfs_record_snapshot_destroy()
  btrfs: tracepoints: add trace event for btrfs_record_new_subvolume()
  btrfs: tracepoints: add trace event for btrfs_log_new_name()
  btrfs: tracepoints: add trace event for btrfs_sync_log()
  btrfs: tracepoints: show inode type in btrfs_sync_file_enter() event

 fs/btrfs/disk-io.c           |   2 -
 fs/btrfs/file.c              |  19 +-
 fs/btrfs/super.c             |   1 +
 fs/btrfs/transaction.c       |  12 +-
 fs/btrfs/tree-log.c          | 273 +++++++----
 fs/btrfs/tree-log.h          |   7 +
 include/trace/events/btrfs.h | 886 ++++++++++++++++++++++++++++++++++-
 7 files changed, 1074 insertions(+), 126 deletions(-)

-- 
2.47.2

