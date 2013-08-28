Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:59124 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754381Ab3H1PS7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 11:18:59 -0400
Message-ID: <521E14DD.1060808@sgi.com>
Date: Wed, 28 Aug 2013 10:18:53 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4] xfstests: don't remove the two first devices from
 SCRATCH_DEV_POOL
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Stefan, it has been committed.

--Rich

commit f1dce456c594a784afb723d1bc7c09056ab3d9d9
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 23 13:07:10 2013 +0000

     xfstests: don't remove the two first devices from SCRATCH_DEV_POOL

