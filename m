Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34747 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbcD0DvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 23:51:17 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
	infrastructure))
Subject: [PATCH v2 0/3] block: avoid to call .bi_end_io() recursively
Date: Wed, 27 Apr 2016 11:50:47 +0800
Message-Id: <1461729047-22837-1-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The 1st patch handles bio error in dio_end_io() which is only
used by btrfs.

The 2nd patch uses bio_endio() to call .bi_end_io() in dio_end_io().

The 3rd patch avoids to call .bi_end_io recursively in complete path.

xfstests(-g auto) is run over ext4, xfs and btrfs with this patchset
and no regression is reported.

With this patchset, lots of stack space can be saved in bio complete
path. Even there was stack overflow report in bio complete path, see
details in 3/3 commit log.

V2:
	- introduce patch 1 & 2
	- deal with running bio_endio() from process context, and
	makes generic/323 & generic/224 of xfstests happy on btrfs

V1:
	- change to RFC
	- fix when unwind_bio_endio() is called recursively
	- run xfstest again: no regression found on ext4,
	but generic/323 and generic/224 cause kernel oops


Ming Lei (3):
  fs: direct-io: handle error in dio_end_io()
  fs: direct-io: call .bi_end_io via bio_endio()
  bflock: avoid to call .bi_end_io() recursively

 block/bio.c    | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/direct-io.c |  8 +++-----
 2 files changed, 58 insertions(+), 7 deletions(-)

-- 
1.9.1

