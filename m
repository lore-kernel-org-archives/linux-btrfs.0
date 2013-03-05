Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:53608 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753867Ab3CEUXa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 15:23:30 -0500
Message-ID: <5136544B.2030004@sgi.com>
Date: Tue, 5 Mar 2013 14:23:39 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] xfstests: handle new mkfs.btrfs -f option cleanly
References: <512D1E3E.9050907@redhat.com>
In-Reply-To: <512D1E3E.9050907@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

This patch has been committed.

Thanks
--Rich

commit 24fef70ef3fa0be047264b7a40b0bcf86533ec22
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Feb 26 20:42:38 2013 +0000

     xfstests: handle new mkfs.btrfs -f option cleanly

     I added an "-f" option to mkfs.btrfs to force overwrite
     of an existing filesystem.  Now on an xfstests run, new
     mkfs.btrfs requires it, and old mkfs.btrfs cannot accept
     it.

     So, add a helper which works out whether -f is needed,
     and add it to the MKFS_BTRFS_PROG env. var as necessary,
     so that it is an always-included option during the tests.

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


