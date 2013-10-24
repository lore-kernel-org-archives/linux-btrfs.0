Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:39536 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752063Ab3JXAOw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 20:14:52 -0400
Message-ID: <52686678.2010200@sgi.com>
Date: Wed, 23 Oct 2013 19:14:48 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests btrfs/020: test device replace on RO btrfs
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1382527446-16053-1-git-send-email-eguan@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been committed.

Thanks
--Rich

commit 5b8e9ac03259a11de8fd84d939f25a2cbbafab18
Author: Eryu Guan <eguan@redhat.com>
Date:   Wed Oct 23 16:44:43 2013 +0000

     xfstests btrfs/020: test device replace on RO btrfs
