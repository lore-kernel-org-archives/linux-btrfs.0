Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab3ELPdz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 May 2013 11:33:55 -0400
From: "Richard W.M. Jones" <rjones@redhat.com>
To: mfasheh@suse.de
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/0] libbtrfs: Set SONAME to "libbtrfs.so.0" (instead of "libbtrfs.so")
Date: Sun, 12 May 2013 16:33:43 +0100
Message-Id: <1368372824-15700-1-git-send-email-rjones@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the original version of "btrfs-progs: libify some parts of
btrfs-progs" by Mark Fasheh, the soname field of the internal libbtrfs
library was set to "libbtrfs.so.1".  This doesn't match the filename
of the library (libbtrfs.so.0.1) which is unusual.

However in the version which went upstream, the soname was changed to
just "libbtrfs.so".  There doesn't seem to be any mention of why this
was changed.  This soname doesn't follow the normal convention, and
confuses some tools that we use in Fedora to handle shared libraries.

This patch changes the soname to "libbtrfs.so.0" to match the filename
and the usual convention for sonames.  It would also allow a future
version of this library to make breaking ABI changes by changing the
soname (eg. to "libbtrfs.so.1"), but allowing callers to use either
the old or the new version.

Rich.

