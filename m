Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50077 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2IKWQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 18:16:41 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Tue, 11 Sep 2012 16:16:41 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id AC6E63E40040
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 16:16:37 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q8BMGc9H241020
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 16:16:38 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q8BMGb4a018094
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 16:16:38 -0600
Message-ID: <504FB844.7000307@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2012 15:16:36 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, mcao@us.ibm.com
Subject: Re: [PATCH] Btrfs: create a pinned em when writing to a prealloc
 range in DIO
References: <1347392531-10863-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1347392531-10863-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2012 12:42 PM, Josef Bacik wrote:
> Wade Cline reported a problem where he was getting garbage and warnings when
> writing to a preallocated range via O_DIRECT.  This is because we weren't
> creating our normal pinned extent_map for the range we were writing to,
> which was causing all sorts of issues.  This patch fixes the problem and
> makes his testcase much happier.  Thanks,
>
> Reported-by: Wade Cline<clinew@linux.vnet.ibm.com>
> Signed-off-by: Josef Bacik<jbacik@fusionio.com>
I ran some basic tests and this seems to have fixed the issue.

Tested-by: Wade Cline <clinew@linux.vnet.ibm.com>

Thank you,
Wade

