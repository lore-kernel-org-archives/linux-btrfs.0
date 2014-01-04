Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43235 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbaADO4p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 09:56:45 -0500
From: Chris Mason <clm@fb.com>
To: "chris@csamuel.org" <chris@csamuel.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sat, 4 Jan 2014 14:56:39 +0000
Message-ID: <1388847436.23513.26.camel@ret.masoncoding.com>
References: <52C73987.7000106@jrs-s.net> <52C77903.9060408@jrs-s.net>
	 <CAAVQaYBZS87S7XNdDpUv5pBMvqF0+th34H8PjSLVLtZV9LOR=Q@mail.gmail.com>
	 <1422900.iO9oO96QZb@quad>
In-Reply-To: <1422900.iO9oO96QZb@quad>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2014-01-04 at 22:28 +-1100, Chris Samuel wrote:
+AD4- On Sat, 4 Jan 2014 12:57:02 AM Dave wrote:
+AD4- 
+AD4- +AD4- I find myself annoyed by the constant disclaimers I
+AD4- +AD4- read on this list, about the experimental status of Btrfs, but it's
+AD4- +AD4- apparent that this hasn't sunk in for everyone.
+AD4- 
+AD4- Btrfs will no longer marked as experimental in the kernel as of 3.13.
+AD4- 
+AD4- Unless someone submits a patch to fix it first. :-)
+AD4- 
+AD4- Can we also keep things polite here please.

Seconded +ADs-)  We're really focused on nailing down these problems instead
of hiding behind the experimental flag.  I know we won't be perfect
overnight, but it's time to focus on production workloads.

-chris

