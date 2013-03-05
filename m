Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:51549 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755397Ab3CEWs3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 17:48:29 -0500
Message-ID: <51367610.3070804@sgi.com>
Date: Tue, 5 Mar 2013 16:47:44 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Eric Sandeen <sandeen@redhat.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: Fix hang when mkfs.btrfs isn't present
References: <512D1E3E.9050907@redhat.com> <513674B2.9030900@sandeen.net>
In-Reply-To: <513674B2.9030900@sandeen.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yup looks good, thanks for fixing it Eric.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Having some network issues, will pull this in tomorrow.

Thanks
--Rich
