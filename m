Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44464 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbaACQHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 11:07:12 -0500
From: Chris Mason <clm@fb.com>
To: "fengguang.wu@intel.com" <fengguang.wu@intel.com>
CC: "jbacik@fusionio.com" <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>
Subject: Re: 1be41b78: +18% increased btrfs write throughput
Date: Fri, 3 Jan 2014 16:07:05 +0000
Message-ID: <1388765265.32640.7.camel@ret.masoncoding.com>
References: <20140103155421.GA7494@localhost>
In-Reply-To: <20140103155421.GA7494@localhost>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-01-03 at 23:54 +-0800, fengguang.wu+AEA-intel.com wrote:
+AD4- Hi Josef,
+AD4- 
+AD4- FYI. We are doing 0day performance tests and happen to notice that
+AD4- btrfs write throughput increased considerably during v3.10-11 time
+AD4- frame:
+AD4- 
+AD4-           v3.10                      v3.11                      v3.12                  v3.13-rc6
+AD4- ---------------  -------------------------  -------------------------  -------------------------
+AD4-      50619 +AH4- 1+ACU-     +-17.0+ACU-      59209 +AH4- 2+ACU-     +-18.8+ACU-      60159 +AH4- 2+ACU-     +-20.5+ACU-      61007 +AH4- 0+ACU-  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-btrfs-1dd
+AD4-      50619          +-17.0+ACU-      59209          +-18.8+ACU-      60159          +-20.5+ACU-      61007       TOTAL iostat.sdd.wkB/s
+AD4- 
+AD4- and it's contributed by 
+AD4- 
+AD4- commit 1be41b78bc688fc634bf30965d2be692c99fd11d
+AD4- Author:     Josef Bacik +ADw-jbacik+AEA-fusionio.com+AD4-
+AD4- AuthorDate: Wed Jun 12 13:56:06 2013 -0400
+AD4- Commit:     Josef Bacik +ADw-jbacik+AEA-fusionio.com+AD4-
+AD4- CommitDate: Mon Jul 1 08:52:28 2013 -0400
+AD4- 
+AD4-     Btrfs: fix transaction throttling for delayed refs

Bonus points for increasing the performance on purpose.  Thanks for
running these Wu.

-chris

