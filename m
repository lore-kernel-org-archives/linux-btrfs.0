Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46571 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3IWSTu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 14:19:50 -0400
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 24 Sep 2013 04:19:48 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 22E592BB0040
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 04:19:45 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8NI37P362652638
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 04:03:07 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r8NIJilZ010690
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 04:19:44 +1000
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com
Subject: Re: [PATCH] btrfs-progs: cmd_find_new: Sync fs before searching for modified files.
Date: Mon, 23 Sep 2013 23:49:40 +0530
Message-ID: <1766936.92AMv0DYCJ@localhost.localdomain>
In-Reply-To: <2363441.CTgOPvMvZp@localhost.localdomain>
References: <2363441.CTgOPvMvZp@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch was tested on a kernel with "[PATCH v4] Btrfs: fix sync fs to
actually wait for all data to be persisted" applied.

Thanks,
chandan

