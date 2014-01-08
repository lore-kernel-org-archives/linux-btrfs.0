Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35675 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273AbaAHUQz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 15:16:55 -0500
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
Date: Wed, 8 Jan 2014 20:16:43 +0000
Message-ID: <1389212231.23310.33.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	 <20140106221036.GE9037@kmo>
	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	 <20140107055318.GA19016@localhost>
	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
	 <1389126617.23310.19.camel@ret.masoncoding.com>
	 <CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
	 <1389210102.23310.31.camel@ret.masoncoding.com>
	 <CAFR8uefXjN_nzHWsTF=-PxNPDMWMj5Hw+ueFYQwa8-qBEGMGTw@mail.gmail.com>
In-Reply-To: <CAFR8uefXjN_nzHWsTF=-PxNPDMWMj5Hw+ueFYQwa8-qBEGMGTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-01-08 at 11:54 -0800, Muthu Kumar wrote:
+AD4- Chris,
+AD4- 
+AD4- +AFs-    8.336061+AF0- WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio+AF8-endio+-0xbe/0x100()
+AD4- +AFs-    8.336062+AF0- bio+AF8-endio: bio for (unknown) without endio
+AD4- 
+AD4- This is my recent change to avoid memory leak in bio+AF8-endio. But I
+AD4- think the problem is higher up, most likely bio+AF8-endio is called twice
+AD4- on the same bio (which was freed before).
+AD4- 

I think these are just two separate problems.  Lets ignore the WARN+AF8-ON
for now.

+AD4- Are you running the unmodified for-3.14/core or do you have local patches?
+AD4- 

It's for-3.14/core with my btrfs branch.  Basically rc7 instead of rc6
but no changes to the block layer.  I hadn't mounted btrfs yet.

-chris

