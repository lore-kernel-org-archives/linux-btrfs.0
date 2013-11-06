Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56116 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3KFXP5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/16] btrfs-progs: Several more static analysis defect fixes
Date: Wed,  6 Nov 2013 17:15:39 -0600
Message-Id: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These all apply to the integration branch in Chris's current git tree.
(Which saw the defects rise by from 55 to 65 in the last l6 commits :()

This beats back the defect count again.  Compile tested only, FWIW.

Thanks,
-Eric


