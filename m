Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:51604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758856Ab3DDL7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 07:59:39 -0400
Message-ID: <515D6B3C.5070104@sgi.com>
Date: Thu, 4 Apr 2013 06:59:56 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: <xfs@oss.sgi.com>
CC: <linux-ext4@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] cleanup duplicates in all tests
References: <20130403173245.376605011@sgi.com>
In-Reply-To: <20130403173245.376605011@sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the review Eric, this patch has been committed.

--Rich

commit 0efd4f4d483a725212f531bc2ed964de2766b1cd
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Wed Apr 3 17:31:49 2013 +0000

     xfstests: cleanup duplicates in all tests

     There are duplicate blank lines, comment hash and lines
     containing duplicate seqres= declarations, remove them.
