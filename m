Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:44030 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753326Ab3JVU5Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 16:57:25 -0400
Message-ID: <5266E6B1.8090106@sgi.com>
Date: Tue, 22 Oct 2013 15:57:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH 1/8] xfstests: fix btrfs/002 to not use the scratch dev
 pool
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch has been committed.

Thanks
--Rich

commit 122fba38be096e63d15e31d45372a1e344fa67b5
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Oct 18 18:26:23 2013 +0000

     xfstests: fix btrfs/002 to not use the scratch dev pool
