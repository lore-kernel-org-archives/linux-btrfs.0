Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12693 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751737AbcEJBQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 21:16:15 -0400
To: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Idea on compatibility for old distributions
Message-ID: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
Date: Tue, 10 May 2016 09:16:04 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David, Mark,

In the recent test for new btrfs-convert backward compatibility, I found 
that cmds-fi-du.c uses FIEMAP_EXTENT_SHARED bits, which is not present 
in kernel of old distributions like RHEL6 (Sorry, didn't test on 
openSUSE equivalent).

Unlike e2fsprogs, we can check its version with pkgconfig, any idea to 
avoid such compiling error?

And further more, without kernel support for FIEMAP_EXTENT_SHARED, will 
fi-du work anymore?

Thanks,
Qu


