Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp11.hushmail.com ([65.39.178.133]:43993 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2FGOq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2012 10:46:26 -0400
Received: from smtp11.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp11.hushmail.com (Postfix) with SMTP id 81C7A1CC436
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2012 14:46:24 +0000 (UTC)
Received: from smtp.hushmail.com (w5.hushmail.com [65.39.178.80])
	by smtp11.hushmail.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2012 14:46:22 +0000 (UTC)
MIME-Version: 1.0
Date: Thu, 07 Jun 2012 06:46:22 -0800
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Two questions about update_global_block_rsv()
From: "WeiFeng Liu" <weifeng.liu@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120607144622.96FFDE674A@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Help two questions about update_global_block_rsv()

update_global_block_rsv(fs_info) {

...
block_rsv = &fs_info->global_block_rsv;
sinfo = block_rsv->space_info;

num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
            sinfo->bytes_reserved + sinfo->bytes_readonly +
            sinfo->bytes_may_use;
 
if (sinfo->total_bytes > num_bytes) {
		num_bytes = sinfo->total_bytes - num_bytes;
		block_rsv->reserved += num_bytes;
		sinfo->bytes_may_use += num_bytes;
}
...
}

1. I don't quite understand the lines:
	block_rsv->reserved += num_bytes;
	sinfo->bytes_may_use += num_bytes;
	
why aren't they like these?
	block_rsv->reserved = num_bytes;
	sinfo->bytes_may_use = num_bytes;

assuming that nothing else is changed, and we just call
update_global_block_rsv() for several times, then block_rsv->reserved will
increase constantly, and so sinfo->bytes_may_use; can anyone tell me what it
means? I mean if nothing else is changed the two variables should keep their
values unchanged also, is that right? a bit puzzlement to me.

2. Is the meaning of sinfo->bytes_may_use that bytes which is available for use
or that bytes which will likely/unlikely be used?

thanks

WeiFeng Liu

