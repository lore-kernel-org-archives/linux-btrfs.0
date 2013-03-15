Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:51482 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751419Ab3CORL3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 13:11:29 -0400
Message-ID: <51435658.40309@sgi.com>
Date: Fri, 15 Mar 2013 12:11:52 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: enable test 032 (mkfs overwrite) for btrfs
References: <5140A2BC.7010800@redhat.com>
In-Reply-To: <5140A2BC.7010800@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch has been commited.

Thanks
--Rich

commit 99eb53da9c08148132cdf3cd401b248e6a0d96c5
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Mar 13 16:01:00 2013 +0000

     xfstests: enable test 032 (mkfs overwrite) for btrfs

     Now that btrfs has an "-f" arg, we can test that it doesn't
     improperly overwrite other filesystems in 032 like we do
     for xfs.

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>



