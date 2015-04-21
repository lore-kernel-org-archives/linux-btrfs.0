Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:36306 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbbDUFsn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 01:48:43 -0400
Received: by qgeb100 with SMTP id b100so63693187qge.3
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 22:48:42 -0700 (PDT)
Received: from ?IPv6:2001:470:8:414::10? (wolf.welp.gs. [2001:470:8:414::10])
        by mx.google.com with ESMTPSA id h14sm681813qhc.46.2015.04.20.22.48.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2015 22:48:41 -0700 (PDT)
Message-ID: <5535E4B8.9000909@gmail.com>
Date: Tue, 21 Apr 2015 01:48:40 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 0/1] btrfs-progs: optionally restore metadata
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changes since v1:

* Documented in the manpage
* Added to usage() for btrfs restore
* Made it an optional flag (-m/--restore-metadata)
* Use endian-safe macros to access the on-disk data.
* Restore the proper mtime instead of atime twice.
* Restore owner and mode
* Restore metadata for directories as well as plain files.
* Since it's now explicitly requested, errors are fatal
  unless ignore_errors is requested.

I tested this on the array I'm restoring, it looks sane to me.

Thanks to Noah Massey for the patch review, and Duncan for the
prompt to add owner/permissions to the patch.

Symlinks and hardlinks are beyond the scope of these changes, I'll look
into them if this looks good to everyone.
