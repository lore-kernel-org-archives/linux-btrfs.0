Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54467 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab3LRTX0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 14:23:26 -0500
From: Chris Mason <clm@fb.com>
To: "proski@gnu.org" <proski@gnu.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Backporting bugfixes
Date: Wed, 18 Dec 2013 19:23:08 +0000
Message-ID: <1387394605.25093.4.camel@ret.masoncoding.com>
References: <20131218140615.dbjsgs7zkssgckos-cebfxv@webmail.spamcop.net>
In-Reply-To: <20131218140615.dbjsgs7zkssgckos-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2013-12-18 at 14:06 -0500, Pavel Roskin wrote:
+AD4- Hello+ACE-
+AD4- 
+AD4- I have noticed that there have been important fixes for btrfs in the  
+AD4- mainline Linux git repository.  However, there is just one btrfs fix  
+AD4- in Linux 3.12.5 after 3.12.
+AD4- 
+AD4- I think it's important to submit all serious bugfixes to the stable  
+AD4- kernels.  It would protect users against data corruption and improve  
+AD4- the image of btrfs as a serious filesystem that can be trusted at  
+AD4- least with semi-important data.
+AD4- 
+AD4- This post was inspired by http://lwn.net/Articles/577218/ and
+AD4- https://bugzilla.redhat.com/show+AF8-bug.cgi?id+AD0-1028750
+AD4- 

Hi Pavel,

We do tag some commits for stable, but Dave Sterba actually just sent a
request to the stable tree to pull in a few more.

-chris

