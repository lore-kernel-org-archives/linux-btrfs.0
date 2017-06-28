Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49590 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdF1Ony (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 10:43:54 -0400
Date: Wed, 28 Jun 2017 07:43:48 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20170628144348.abvqowzmeveyzssn@merlins.org>
References: <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com>
 <20170622025330.GX5303@merlins.org>
 <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com>
 <20170623040601.akpyyvh3dgry6nn5@merlins.org>
 <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
 <20170623161750.r7utffpsmyl5tcik@merlins.org>
 <20170624023409.GT14690@merlins.org>
 <0d93c1c4-1feb-b589-0c8f-1fced7b77686@cn.fujitsu.com>
 <20170627231146.GA16192@merlins.org>
 <20170628071026.GA21006@lufq.5F>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="p6nmbphd35rhhsup"
In-Reply-To: <20170628071026.GA21006@lufq.5F>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p6nmbphd35rhhsup
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[cc trimmed]

On Wed, Jun 28, 2017 at 03:10:27PM +0800, Lu Fengqi wrote:
> Because the output is abnormal, except for the relevant DIR_ITEM and
> DIR_INDEX, I can't find the above mentiond INODE_ITEM and EXTENT_DATA.
> I wonder if the file system is online when this command is executed? If
> so, please re-execute it offline again; if not, could you apply my
> patches re-check it again?

The filesystem was offline and I had those 2 patches applied.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

--p6nmbphd35rhhsup
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="p1.patch"

>From lufq.fnst@cn.fujitsu.com Mon Jun 26 03:37:46 2017
Received: from [59.151.112.132] (port=50126 helo=heian.cn.fujitsu.com)
	by mail1.merlins.org with esmtp (Exim 4.87 #1)
	id 1dPROn-0001kT-Ud
	for <marc@merlins.org>; Mon, 26 Jun 2017 03:37:46 -0700
X-IronPort-AV: E=Sophos;i="5.22,518,1449504000"; 
   d="scan'208";a="20491849"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Jun 2017 18:37:30 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 2694647E64CC;
	Mon, 26 Jun 2017 18:37:30 +0800 (CST)
Received: from lufq.5F.lufq.5F (10.167.225.63) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.319.2; Mon, 26 Jun 2017 18:37:31 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Date: Mon, 26 Jun 2017 18:37:24 +0800
Message-ID: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.13.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.63]
X-yoursite-MailScanner-ID: 2694647E64CC.AB674
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
X-Broken-Reverse-DNS: no host name for IP address 59.151.112.132
X-SA-Exim-Connect-IP: 59.151.112.132
X-SA-Exim-Rcpt-To: marc@merlins.org
X-SA-Exim-Mail-From: lufq.fnst@cn.fujitsu.com
X-Spam-Checker-Version: SpamAssassin 3.4.1-mmrules_20121111 (2015-04-28) on
	magic.merlins.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=7.0 tests=BAYES_00,GREYLIST_ISWHITE,
	RDNS_NONE autolearn=ham autolearn_force=no version=3.4.1-mmrules_20121111
X-Spam-Report: 
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	* -1.5 GREYLIST_ISWHITE The incoming server has been whitelisted for this
	*      receipient and sender
Subject: [PATCH v3 1/4] btrfs-progs: lowmem check: Fix false alert about file extent interrupt
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail1.merlins.org)
Status: RO
Content-Length: 1811
Lines: 52

As Qu mentioned in this thread
(https://www.spinics.net/lists/linux-btrfs/msg64469.html), compression
can cause regular extent to co-exist with inlined extent. This coexistence
makes things confusing. Since it was permitted currently, so fix
btrfsck to prevent a bunch of error logs that will make user feel
panic.

When check file extent, record the extent_end of regular extent to check
if there is a gap between the regular extents. Normally there is only one
inlined extent, so the extent_end of inlined extent is useless. However,
if regular extent can co-exist with inlined extent, the extent_end of
inlined extent also need to record.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---

Changlog:
v2: Just fix reported-by
v3: Output verbose information when file extent interrupt

 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c052f66e..70d2b7f2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4782,6 +4782,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 				extent_num_bytes, item_inline_len);
 			err |= FILE_EXTENT_ERROR;
 		}
+		*end += extent_num_bytes;
 		*size += extent_num_bytes;
 		return err;
 	}
@@ -4847,8 +4848,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		      root->objectid, fkey->objectid, fkey->offset);
 	} else if (!no_holes && *end != fkey->offset) {
 		err |= FILE_EXTENT_ERROR;
-		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
-		      root->objectid, fkey->objectid, fkey->offset);
+		error("root %llu EXTENT_DATA[%llu %llu] interrupt, should start at %llu",
+		      root->objectid, fkey->objectid, fkey->offset, *end);
 	}
 
 	*end += extent_num_bytes;
-- 
2.13.1






--p6nmbphd35rhhsup
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="p2.patch"

>From lufq.fnst@cn.fujitsu.com Mon Jun 26 03:37:41 2017
Received: from [59.151.112.132] (port=50126 helo=heian.cn.fujitsu.com)
	by mail1.merlins.org with esmtp (Exim 4.87 #1)
	id 1dPROj-0001kT-Tq
	for <marc@merlins.org>; Mon, 26 Jun 2017 03:37:41 -0700
X-IronPort-AV: E=Sophos;i="5.22,518,1449504000"; 
   d="scan'208";a="20491848"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Jun 2017 18:37:30 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id B3C5047E64D5;
	Mon, 26 Jun 2017 18:37:30 +0800 (CST)
Received: from lufq.5F.lufq.5F (10.167.225.63) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.319.2; Mon, 26 Jun 2017 18:37:32 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Date: Mon, 26 Jun 2017 18:37:25 +0800
Message-ID: <20170626103727.8945-2-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.13.1
In-Reply-To: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
References: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.63]
X-yoursite-MailScanner-ID: B3C5047E64D5.AC56F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
X-Broken-Reverse-DNS: no host name for IP address 59.151.112.132
X-SA-Exim-Connect-IP: 59.151.112.132
X-SA-Exim-Rcpt-To: marc@merlins.org
X-SA-Exim-Mail-From: lufq.fnst@cn.fujitsu.com
X-Spam-Checker-Version: SpamAssassin 3.4.1-mmrules_20121111 (2015-04-28) on
	magic.merlins.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=7.0 tests=BAYES_00,GREYLIST_ISWHITE,
	RDNS_NONE autolearn=ham autolearn_force=no version=3.4.1-mmrules_20121111
X-Spam-Report: 
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	* -1.5 GREYLIST_ISWHITE The incoming server has been whitelisted for this
	*      receipient and sender
Subject: [PATCH v3 2/4] btrfs-progs: lowmem check: Fix false alert about referencer count mismatch
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail1.merlins.org)
Status: O
Content-Length: 915
Lines: 29

The normal back reference counting doesn't care about the extent referred
by the extent data in the shared leaf. The check_extent_data_backref
function need to skip the leaf that owner mismatch with the root_id.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 70d2b7f2..f42968cd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10692,7 +10692,8 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		leaf = path.nodes[0];
 		slot = path.slots[0];
 
-		if (slot >= btrfs_header_nritems(leaf))
+		if (slot >= btrfs_header_nritems(leaf) ||
+		    btrfs_header_owner(leaf) != root_id)
 			goto next;
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
-- 
2.13.1






--p6nmbphd35rhhsup--
