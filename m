Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbaFKOGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 10:06:05 -0400
From: David Disseldorp <ddiss@suse.de>
To: fstests@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] xfstests: add cifs.ko server-side copy helper
Date: Wed, 11 Jun 2014 16:05:42 +0200
Message-Id: <1402495544-12865-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation for adding cifs.ko support to xfstests, this patch series
extends the cloner binary to support SMB2 server-side copies via
CIFS_IOC_COPYCHUNK_FILE, in addition to the existing Btrfs COW clone
functionality.

This could be split into a separate binary if deemed necessary, but
given the code overlap, I though it suitable to share the same source.

Feedback appreciated.

--

David Disseldorp (2):
      src/cloner: check filesystem type
      src/cloner: add CIFS_IOC_COPYCHUNK_FILE support

 configure.ac |   1 +
 src/cloner.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 114 insertions(+), 10 deletions(-)
