Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:43343 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753790Ab3JPT70 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 15:59:26 -0400
Message-ID: <525EF03C.10102@sgi.com>
Date: Wed, 16 Oct 2013 14:59:56 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, <xfs@oss.sgi.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: fix set-default test in btrfs/001
References: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been committed.

Thanks
--Rich

commit d4bc9576f09992dfc76eb34bb1aca3e80eaee1e7
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Wed Sep 18 20:48:27 2013 +0000

     xfstests: fix set-default test in btrfs/001

