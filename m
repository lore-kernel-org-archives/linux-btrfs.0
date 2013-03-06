Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:52931 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753474Ab3CFNC4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 08:02:56 -0500
Message-ID: <51373E85.9050408@sgi.com>
Date: Wed, 6 Mar 2013 07:03:01 -0600
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

This patch has been committed.

Thanks
--Rich

commit 52f4953ac4a377f9f7fc870d2a81f30c3e5d3c7f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Mar 5 22:41:54 2013 +0000

     xfstests: Fix hang when mkfs.btrfs isn't present

     My earlier patch (xfstests: handle new mkfs.btrfs -f option cleanly)
     had a flaw in that if set_prog_path mkfs.btrfs returns nothing,
     the grep will hang.

     Test for that case to avoid it, and just return the empty string
     in that case.

     Reported-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

