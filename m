Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62897 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215AbaAHVNz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 16:13:55 -0500
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
Date: Wed, 8 Jan 2014 21:13:47 +0000
Message-ID: <1389215654.23310.39.camel@ret.masoncoding.com>
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
+AD4- Reported-and-Tested-by: Fengguang wu +ADw-fengguang.wu+AEA-intel.com+AD4-
+AD4- CC: Kent Overstreet +ADw-kmo+AEA-daterainc.com+AD4-
+AD4- CC: Jens Axboe +ADw-axboe+AEA-kernel.dk+AD4-
+AD4- CC: Chris Mason +ADw-clm+AEA-fb.com+AD4-
+AD4- Signed-off-by: Muthukumar Ratty +ADw-muthur+AEA-gmail.com+AD4-
+AD4- 

Reviewed-by: Chris Mason +ADw-clm+AEA-fb.com+AD4-

Jens, please pull this one in.

+AD4- -----------
+AD4-  fs/btrfs/volumes.c +AHw-    8 +-+-+-+-+-+---
+AD4-  1 files changed, 6 insertions(+-), 2 deletions(-)
+AD4- 
+AD4- diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
+AD4- index 37972d5..34aba2b 100644
+AD4- --- a/fs/btrfs/volumes.c
+AD4- +-+-+- b/fs/btrfs/volumes.c
+AD4- +AEAAQA- -5297,9 +-5297,13 +AEAAQA- static void btrfs+AF8-end+AF8-bio(struct bio +ACo-bio, int err)
+AD4-                 if (+ACE-is+AF8-orig+AF8-bio) +AHs-
+AD4-                         bio+AF8-put(bio)+ADs-
+AD4-                         bio +AD0- bbio-+AD4-orig+AF8-bio+ADs-
+AD4- -               +AH0- else +AHs-
+AD4- -                       atomic+AF8-inc(+ACY-bio-+AD4-bi+AF8-remaining)+ADs-
+AD4-                 +AH0-
+AD4- +-                /+ACo-
+AD4- +-                 +ACo- We have original bio now. So increment bi+AF8-remaining to
+AD4- +-                 +ACo- account for it in endio
+AD4- +-                 +ACo-/
+AD4- +-               atomic+AF8-inc(+ACY-bio-+AD4-bi+AF8-remaining)+ADs-
+AD4- +-
+AD4-                 bio-+AD4-bi+AF8-private +AD0- bbio-+AD4-private+ADs-
+AD4-                 bio-+AD4-bi+AF8-end+AF8-io +AD0- bbio-+AD4-end+AF8-io+ADs-
+AD4-                 btrfs+AF8-io+AF8-bio(bio)-+AD4-mirror+AF8-num +AD0- bbio-+AD4-mirror+AF8-num+ADs-
+AD4- 
+AD4- -------------------------------------


