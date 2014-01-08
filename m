Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23776 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbaAHVMF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 16:12:05 -0500
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
Date: Wed, 8 Jan 2014 21:11:49 +0000
Message-ID: <1389215536.23310.37.camel@ret.masoncoding.com>
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
	 <1389212231.23310.33.camel@ret.masoncoding.com>
	 <CAFR8uec00zThzs5Q21ySG90shQHVxbRZDGrYBPrdn1KbNCQ_vw@mail.gmail.com>
	 <1389214325.23310.34.camel@ret.masoncoding.com>
	 <CAFR8uefj7=x149nAQOwX5pw-5OCXnS6oYYF8xZkQVrdmPJBD6g@mail.gmail.com>
In-Reply-To: <CAFR8uefj7=x149nAQOwX5pw-5OCXnS6oYYF8xZkQVrdmPJBD6g@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-01-08 at 13:01 -0800, Muthu Kumar wrote:
+AD4- On Wed, Jan 8, 2014 at 12:51 PM, Chris Mason +ADw-clm+AEA-fb.com+AD4- wrote:
+AD4- +AD4- On Wed, 2014-01-08 at 12:40 -0800, Muthu Kumar wrote:
+AD4- +AD4APg- On Wed, Jan 8, 2014 at 12:16 PM, Chris Mason +ADw-clm+AEA-fb.com+AD4- wrote:
+AD4- +AD4APg- +AD4- On Wed, 2014-01-08 at 11:54 -0800, Muthu Kumar wrote:
+AD4- +AD4APg- +AD4APg- Chris,
+AD4- +AD4APg- +AD4APg-
+AD4- +AD4APg- +AD4APg- +AFs-    8.336061+AF0- WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio+AF8-endio+-0xbe/0x100()
+AD4- +AD4APg- +AD4APg- +AFs-    8.336062+AF0- bio+AF8-endio: bio for (unknown) without endio
+AD4- +AD4APg- +AD4APg-
+AD4- +AD4APg- +AD4APg- This is my recent change to avoid memory leak in bio+AF8-endio. But I
+AD4- +AD4APg- +AD4APg- think the problem is higher up, most likely bio+AF8-endio is called twice
+AD4- +AD4APg- +AD4APg- on the same bio (which was freed before).
+AD4- +AD4APg- +AD4APg-
+AD4- +AD4APg- +AD4-
+AD4- +AD4APg- +AD4- I think these are just two separate problems.  Lets ignore the WARN+AF8-ON
+AD4- +AD4APg- +AD4- for now.
+AD4- +AD4APg- +AD4-
+AD4- +AD4APg-
+AD4- +AD4APg- Not really... the BUG that is triggered:
+AD4- +AD4APg-
+AD4- +AD4APg- kernel BUG at fs/bio.c:523+ACE-
+AD4- +AD4APg-
+AD4- +AD4APg- It is in bio+AF8-put() (added to bio+AF8-endio() as part of recent change)
+AD4- +AD4APg- which gets an already freed bio.
+AD4- +AD4APg-
+AD4- +AD4-
+AD4- +AD4- Oh+ACE- I see.  Let me try with that one reverted.  Thanks+ACE-
+AD4- +AD4-
+AD4- +AD4- -chris
+AD4- +AD4-
+AD4- 
+AD4- But, like I said, problem is in different place. I am running a +ACI-dd+ACI-
+AD4- on ext4 fs for a while now, but didn't hit the problem. Any idea to
+AD4- repro locally? I would also suggest running just the for-3.1/core to
+AD4- isolate the issue.

Just reverting that change fixes it for me.  Jens mentioned it was
broken for on-stack bios.

-chris

