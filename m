Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38200 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224AbaAIOwk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 09:52:40 -0500
From: Chris Mason <clm@fb.com>
To: "hugo@carfax.org.uk" <hugo@carfax.org.uk>
CC: "wangsl.fnst@cn.fujitsu.com" <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs-progs: make send/receive compatible with older
 kernels
Date: Thu, 9 Jan 2014 14:52:27 +0000
Message-ID: <1389279172.23310.50.camel@ret.masoncoding.com>
References: <1389264758-9495-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	 <52CE8CDC.6030408@giantdisaster.de> <20140109121606.GI15634@carfax.org.uk>
In-Reply-To: <20140109121606.GI15634@carfax.org.uk>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-01-09 at 12:16 +-0000, Hugo Mills wrote:
+AD4- On Thu, Jan 09, 2014 at 12:49:48PM +-0100, Stefan Behrens wrote:
+AD4- +AD4- On Thu, 9 Jan 2014 18:52:38 +-0800, Wang Shilong wrote:
+AD4- +AD4- +AD4- Some users complaint that with latest btrfs-progs, they will
+AD4- +AD4- +AD4- fail to use send/receive. The problem is new tool will try
+AD4- +AD4- +AD4- to use uuid tree while it dosen't work on older kernel.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Now we first check if we support uuid tree, if not we fall into
+AD4- +AD4- +AD4- normal search as previous way.i copy most of codes from Alexander
+AD4- +AD4- +AD4- Block's previous codes and did some adjustments to make it work.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Signed-off-by: Alexander Block +ADw-ablock84+AEA-googlemail.com+AD4-
+AD4- +AD4- +AD4- Signed-off-by: Wang Shilong +ADw-wangsl.fnst+AEA-cn.fujitsu.com+AD4-
+AD4- +AD4- +AD4- ---
+AD4- +AD4- +AD4-  send-utils.c +AHw- 352 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--
+AD4- +AD4- +AD4-  send-utils.h +AHw-  11 +-+-
+AD4- +AD4- +AD4-  2 files changed, 359 insertions(+-), 4 deletions(-)
+AD4- +AD4- 
+AD4- +AD4- I'd prefer a printf(+ACI-Needs kernel 3.12 or better+AFw-n+ACI-) if no UUID tree is
+AD4- +AD4- found. The code that you add will never be tested by anyone and will
+AD4- +AD4- become broken sooner or later.
+AD4- +AD4- 
+AD4- +AD4- The new kernel is compatible to old progs and to new progs. But new
+AD4- +AD4- progs require a new kernel and IMO this is normal.
+AD4- 
+AD4-    No. Really, no. I think I would be extremely upset to upgrade, say,
+AD4- util-linux, only to discover that I needed a new kernel for cp to
+AD4- continue to work. I hope you would be, too.
+AD4- 
+AD4-    You may need to upgrade the kernel to get new features offered by a
+AD4- new userspace, but I think we should absolutely not be changing
+AD4- userspace in a way that makes it incompatible with older kernels.

I'd really prefer that we maintain compatibility with the older kernels.
Heavy btrfs usage is going to want a newer kernel anyway, but this is an
important policy to keep in place for the future.

Especially since Wang went to the trouble of making the patch, I'd
rather take it.

-chris

