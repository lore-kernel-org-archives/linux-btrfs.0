Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22099 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753007AbaAGU3z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 15:29:55 -0500
From: Chris Mason <clm@fb.com>
To: "muthu.lkml@gmail.com" <muthu.lkml@gmail.com>
CC: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Date: Tue, 7 Jan 2014 20:29:47 +0000
Message-ID: <1389126617.23310.19.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	 <20140106221036.GE9037@kmo>
	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	 <20140107055318.GA19016@localhost>
	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
In-Reply-To: <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-01-07 at 12:15 -0800, Muthu Kumar wrote:
+AD4- Thanks Fengguang. Final patch with added comment. BTW, fengguang
+AD4- mentioned that git-am has trouble with the inline patch and +ACI-quilt
+AD4- import+ACI- worked fine for him...
+AD4- 
+AD4- ------------
+AD4- In btrfs+AF8-end+AF8-bio(), we increment bi+AF8-remaining if is+AF8-orig+AF8-bio. If not,
+AD4- we restore the orig+AF8-bio but failed to increment bi+AF8-remaining for
+AD4- orig+AF8-bio, which triggers a BUG+AF8-ON later when bio+AF8-endio is called. Fix
+AD4- is to increment bi+AF8-remaining when we restore the orig bio as well.
+AD4- 

Hi everyone,

Which git tree is this against?  Just Jens or some extra code too?

I'll run some tests here.  My original patch is below (it's slightly
different from Muthu's).

Btrfs is sometimes calling bio+AF8-endio twice on the same bio while
we chain things.  This makes sure we don't trip over new assertions in
fs/bio.c

Signed-off-by: Chris Mason +ADw-clm+AEA-fb.com+AD4-

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7fcac70..5b30360 100644
--- a/fs/btrfs/check-integrity.c
+-+-+- b/fs/btrfs/check-integrity.c
+AEAAQA- -2289,6 +-2289,10 +AEAAQA- static void btrfsic+AF8-bio+AF8-end+AF8-io(struct bio +ACo-bp, int bio+AF8-error+AF8-status)
 		block +AD0- next+AF8-block+ADs-
 	+AH0- while (NULL +ACEAPQ- block)+ADs-
 
+-	/+ACo-
+-	 +ACo- since we're not using bio+AF8-endio here, we don't need to worry about
+-	 +ACo- the remaining count
+-	 +ACo-/
 	bp-+AD4-bi+AF8-end+AF8-io(bp, bio+AF8-error+AF8-status)+ADs-
 +AH0-
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..786ddac 100644
--- a/fs/btrfs/disk-io.c
+-+-+- b/fs/btrfs/disk-io.c
+AEAAQA- -1684,7 +-1684,7 +AEAAQA- static void end+AF8-workqueue+AF8-fn(struct btrfs+AF8-work +ACo-work)
 	bio-+AD4-bi+AF8-private +AD0- end+AF8-io+AF8-wq-+AD4-private+ADs-
 	bio-+AD4-bi+AF8-end+AF8-io +AD0- end+AF8-io+AF8-wq-+AD4-end+AF8-io+ADs-
 	kfree(end+AF8-io+AF8-wq)+ADs-
-	bio+AF8-endio(bio, error)+ADs-
+-	bio+AF8-endio+AF8-nodec(bio, error)+ADs-
 +AH0-
 
 static int cleaner+AF8-kthread(void +ACo-arg)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef48947..a31448f 100644
--- a/fs/btrfs/volumes.c
+-+-+- b/fs/btrfs/volumes.c
+AEAAQA- -5284,9 +-5284,17 +AEAAQA- static void btrfs+AF8-end+AF8-bio(struct bio +ACo-bio, int err)
 		+AH0-
 	+AH0-
 
-	if (bio +AD0APQ- bbio-+AD4-orig+AF8-bio)
+-	if (bio +AD0APQ- bbio-+AD4-orig+AF8-bio) +AHs-
 		is+AF8-orig+AF8-bio +AD0- 1+ADs-
 
+-		/+ACo-
+-		 +ACo- eventually we will call the bi+AF8-endio for the original bio,
+-		 +ACo- make sure that we've properly bumped bi+AF8-remaining to reflect
+-		 +ACo- our chain of endios here
+-		 +ACo-/
+-		atomic+AF8-inc(+ACY-bio-+AD4-bi+AF8-remaining)+ADs-
+-	+AH0-
+-
 	if (atomic+AF8-dec+AF8-and+AF8-test(+ACY-bbio-+AD4-stripes+AF8-pending)) +AHs-
 		if (+ACE-is+AF8-orig+AF8-bio) +AHs-
 			bio+AF8-put(bio)+ADs-
--
To unsubscribe from this list: send the line +ACI-unsubscribe linux-fsdevel+ACI- in
the body of a message to majordomo+AEA-vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

