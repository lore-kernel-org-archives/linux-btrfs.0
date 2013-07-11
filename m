Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51607 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3GKObZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 10:31:25 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3B2B19A0693
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 08:31:25 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
 <1373520339-13870-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1373520339-13870-2-git-send-email-miaox@cn.fujitsu.com>
Message-ID: <20130711143122.12026.78808@localhost.localdomain>
Subject: Re: [PATCH 2/5] Btrfs: add branch prediction hints in the read page end IO
 function
Date: Thu, 11 Jul 2013 10:31:22 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you have benchmark numbers for how much these help?  I hesitate to
bring in the likely/unlikely unless we can see it on the benchmarks.

(The patch does look fine though)

-chris
