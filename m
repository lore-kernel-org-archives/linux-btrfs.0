Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:55360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab3DVOfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 10:35:53 -0400
Message-ID: <51754AD0.3060507@sgi.com>
Date: Mon, 22 Apr 2013 09:36:00 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: remove recursive include in filter.btrfs
References: <517386CC.8010406@redhat.com>
In-Reply-To: <517386CC.8010406@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Eric, V3 has been committed.

--Rich

commit e771c54c45a5c475bedbc5a2d6becc05be940dba
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Apr 21 22:51:54 2013 +0000

     xfstests: fix common filter include in filter.btrfs

