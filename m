Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:56957 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753951Ab3KLOMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 09:12:40 -0500
Message-ID: <52823762.4040704@sgi.com>
Date: Tue, 12 Nov 2013 08:12:50 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <xfs@oss.sgi.com>
Subject: Re: [PATCH v3] xfstests: add regression test for running btrfs balance
 and defrag concurrently
References: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been committed.

Thanks
--Rich

commit 6bd85c0a995af4df28b354450e6df658257b559b
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Thu Oct 31 09:34:22 2013 +0000

     xfstests: add regression test for running btrfs balance and defrag 
concurrently

