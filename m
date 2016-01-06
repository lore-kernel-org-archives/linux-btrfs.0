Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21144 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbcAFXR6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 18:17:58 -0500
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        konrad.wilk@oracle.com, drbd-dev@lists.linbit.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 02/35] block: add REQ_OP definitions and bi_op/op fields
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-3-git-send-email-mchristi@redhat.com>
Date: Wed, 06 Jan 2016 18:17:01 -0500
In-Reply-To: <1452027218-32303-3-git-send-email-mchristi@redhat.com>
	(mchristi@redhat.com's message of "Tue, 5 Jan 2016 14:53:05 -0600")
Message-ID: <yq1d1tei9hu.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Mike" == mchristi  <mchristi@redhat.com> writes:

+enum req_op {
+	REQ_OP_READ,
+	REQ_OP_WRITE		= REQ_WRITE,
+	REQ_OP_DISCARD		= REQ_DISCARD,
+	REQ_OP_WRITE_SAME	= REQ_WRITE_SAME,
+};
+

I have been irked by the REQ_ prefix in bios since the flags were
consolidated a while back. When I attempted to fix the READ/WRITE mess I
used a BLK_ prefix as a result.

Anyway. Just bikeshedding...

-- 
Martin K. Petersen	Oracle Linux Engineering
