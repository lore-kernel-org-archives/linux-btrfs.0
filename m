Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39825 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755682AbaIROTQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 10:19:16 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8IEEPkD016436
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 07:19:15 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pfkt1apnr-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 07:19:15 -0700
Message-ID: <541AE9DF.9030401@fb.com>
Date: Thu, 18 Sep 2014 10:19:11 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: kernel integration branch updated
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've added a few more patches to the kernel integration branch, and
rebased onto rc5.  This should be my last rebase before sending into
linux-next, please take a look.

It's still missing three patches from Josef, which we're updating.  I
can put more patches on top, but I'd prefer not to rebase again unless
some patches need removing.

-chris
