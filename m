Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:56016 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176Ab3H1Pab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 11:30:31 -0400
Message-ID: <521E1791.5090005@sgi.com>
Date: Wed, 28 Aug 2013 10:30:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstest: fix btrfs/006 for 10+ devices in SCRATCH_DEV_POOL
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de> <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Stefan, it has been committed.

--Rich

commit 0d3bbd18942bfac464d18f88c0a3c100c67a24f2
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 23 13:07:13 2013 +0000

     xfstests: fix btrfs/006 for 10+ devices in SCRATCH_DEV_POOL

