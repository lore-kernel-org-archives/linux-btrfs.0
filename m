Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39671 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753718AbdEISBe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 14:01:34 -0400
Subject: Re: [GIT PULL] Btrfs
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <88747a65-7407-fcc5-4111-962440c082c8@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <0b469484-84d0-f986-34dd-b9d87849e260@fb.com>
Date: Tue, 9 May 2017 14:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <88747a65-7407-fcc5-4111-962440c082c8@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2017 01:56 PM, Chris Mason wrote:
> Hi Linus,
> 
> My for-linus-4.12 branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.12

I hit send too soon, sorry.  There's a trivial conflict with our WARN_ON
fix that went into 4.11.  I pushed the resolution to
for-linus-4.12-merged.

diff --cc fs/btrfs/qgroup.c
index afbea61,3f75b5c..deffbeb
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@@ -1078,7 -1031,8 +1034,8 @@@ static int __qgroup_excl_accounting(str
  	qgroup->excl += sign * num_bytes;
  	qgroup->excl_cmpr += sign * num_bytes;
  	if (sign > 0) {
+ 		trace_qgroup_update_reserve(fs_info, qgroup, -(s64)num_bytes);
 -		if (WARN_ON(qgroup->reserved < num_bytes))
 +		if (qgroup->reserved < num_bytes)
  			report_reserved_underflow(fs_info, qgroup, num_bytes);
  		else
  			qgroup->reserved -= num_bytes;
@@@ -1103,7 -1057,9 +1060,9 @@@
  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
  		qgroup->excl += sign * num_bytes;
  		if (sign > 0) {
+ 			trace_qgroup_update_reserve(fs_info, qgroup,
+ 						    -(s64)num_bytes);
 -			if (WARN_ON(qgroup->reserved < num_bytes))
 +			if (qgroup->reserved < num_bytes)
  				report_reserved_underflow(fs_info, qgroup,
  							  num_bytes);
  			else
@@@ -2472,7 -2451,8 +2454,8 @@@ void btrfs_qgroup_free_refroot(struct b
  
  		qg = unode_aux_to_qgroup(unode);
  
+ 		trace_qgroup_update_reserve(fs_info, qg, -(s64)num_bytes);
 -		if (WARN_ON(qg->reserved < num_bytes))
 +		if (qg->reserved < num_bytes)
  			report_reserved_underflow(fs_info, qg, num_bytes);
  		else
  			qg->reserved -= num_bytes;
