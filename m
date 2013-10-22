Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:42458 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752699Ab3JVVRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 17:17:15 -0400
Message-ID: <5266EB58.1040808@sgi.com>
Date: Tue, 22 Oct 2013 16:17:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: wipefs new device in btrfs/003
References: <1382370796-12391-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382370796-12391-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been committed.

Thanks
--Rich

commit 4896f63ef5dddcfe9759cbd369b5fd35084ac193
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Oct 21 15:53:16 2013 +0000

     xfstests: wipefs new device in btrfs/003
