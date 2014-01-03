Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48099 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbaACRaZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 12:30:25 -0500
From: Chris Mason <clm@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "wangsl.fnst@cn.fujitsu.com" <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        CML <CML@fb.com>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs: only fua the first superblock when writting
 supers
Date: Fri, 3 Jan 2014 17:30:05 +0000
Message-ID: <1388770244.29987.0.camel@ret.masoncoding.com>
References: <1388744577-13968-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	 <20140103170350.GP6498@twin.jikos.cz>
In-Reply-To: <20140103170350.GP6498@twin.jikos.cz>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-01-03 at 18:03 +-0100, David Sterba wrote:
+AD4- On Fri, Jan 03, 2014 at 06:22:57PM +-0800, Wang Shilong wrote:
+AD4- +AD4- We only intent to fua the first superblock in every device from
+AD4- +AD4- comments, fix it.
+AD4- 
+AD4- Good catch, this could gain some speedup when there are up to 2 less
+AD4- flushes.
+AD4- 
+AD4- There's one thing that's a different from currnet behaviour:
+AD4- Without this patch, all the superblocks are written with FUA, now only
+AD4- the first one, so my question is what if the first fails and the others
+AD4- succeed but do not get flushed immediatelly?
+AD4- 
+AD4- This is more of a theoretical scenario, and if the 1st superblock write
+AD4- fails more serious problems can be expected. But let's say the write
+AD4- error of 1st is transient, do you or others think that it's reasonable
+AD4- to try to write all the remainig sb's with FUA?

Not a bad idea, if we get a failure on the first SB, fua the others?  I
think it does make sense to do the others non-fua, just because they
only get used in emergencies anyway.

-chris

