Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48750 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3AXScS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 13:32:18 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so5602698pbc.17
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 10:32:18 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 24 Jan 2013 10:32:17 -0800
Message-ID: <CADU+-uD1HTtLd3t2VmpChQm00xvAxg3wcd+pWYD9Q_WcMtF0GA@mail.gmail.com>
Subject: Please revert 2794ed0 (fix permissions of empty files not affected by umask)
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Please revert commit 2794ed013b3551cbae887ea1b93c52aaacb7370d. That
patch was meant to be added to btrfs_create and not to btrfs_mknod.

(It was indeed later added to btrfs_create on commit
9185aa587b7425f8f4520da2e66792f5f3c2b815, so that's already OK.)

btrfs_mknod already has a call to btrfs_update_inode later in the code
so I don't think the duplicate is really needed at that point.

Thanks!
Filipe
