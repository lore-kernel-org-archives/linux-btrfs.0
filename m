Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbaIKOCU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:20 -0400
Message-ID: <5411AB68.7020506@fb.com>
Date: Thu, 11 Sep 2014 10:02:16 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <rongqing.li@windriver.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix a overflowing boundary writing in csum_tree_block
References: <1410254376-6357-1-git-send-email-rongqing.li@windriver.com>
In-Reply-To: <1410254376-6357-1-git-send-email-rongqing.li@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2014 05:19 AM, rongqing.li@windriver.com wrote:
> From: Li RongQing <roy.qing.li@gmail.com>
> 
> It is impossible that csum_size is larger than sizeof(long), but the codes
> still add the handler for this condition, like allocate new memory, for
> extension. If it becomes true someday, copying csum_size size memory to local
> 32bit variable found and val will overflow these two variables.
> 
> Fix it by returning the max 4 byte checksum.

Thanks for the patch.  I'd rather not silently truncate the copy down
though.  How about a one time check at mount to make sure the value in
the super is reasonable?

-chris
