Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48745 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbaADBLF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 20:11:05 -0500
From: Chris Mason <clm@fb.com>
To: "dave@thekilempire.com" <dave@thekilempire.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Status of raid5/6 in 2014?
Date: Sat, 4 Jan 2014 01:11:00 +0000
Message-ID: <1388797899.23513.2.camel@ret.masoncoding.com>
References: <CAAVQaYAx8yxtvM1Mg759FJpEx6rjHQo3_2F84LNMA_f0kP81Sg@mail.gmail.com>
In-Reply-To: <CAAVQaYAx8yxtvM1Mg759FJpEx6rjHQo3_2F84LNMA_f0kP81Sg@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-01-03 at 11:45 -0500, Dave wrote:
+AD4- Back in Feb 2013 there was quite a bit of press about the preliminary
+AD4- raid5/6 implementation in Btrfs.  At the time it wasn't useful for
+AD4- anything other then testing and it's my understanding that this is
+AD4- still the case.
+AD4- 
+AD4- I've seen a few git commits and some chatter on this list but it would
+AD4- appear the developers are largely silent.  Parity based raid would be
+AD4- a powerful addition the the Btrfs feature stack and it's the feature I
+AD4- most anxiously await.  Are there any milestones planned for 2014?
+AD4- 
+AD4- Keep up the good work...

Thanks+ACE-  The big thing missing from RAID5/6 has been logging of parity
to make sure the parity is consistent after a power outage.  I'm back on
this now, and making some progress.

We also need to fix scrub support for raid5/6, which will happen after
the parity work.

-chris

