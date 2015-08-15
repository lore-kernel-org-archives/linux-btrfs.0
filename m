Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33544 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbbHOD3l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 23:29:41 -0400
Received: by igfj19 with SMTP id j19so25247403igf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 20:29:40 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Aug 2015 23:29:40 -0400
Message-ID: <CAK7bmU9vTap5JdkhCDNB=6BC4_fsU-6MCmS3QiFP1Mu2C7yjng@mail.gmail.com>
Subject: "delete missing" with two missing devices doesn't delete both
 missing, only does a partial reconstruction
From: Timothy Normand Miller <theosib@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After applying Anand's patch, I was able to mount my 4-drive RAID1 and
bring a new fourth drive online.  However, something weird happened
where the first "delete missing" only deleted one missing drive and
only did a partial duplication.  I've posted a bug report here:

https://bugzilla.kernel.org/show_bug.cgi?id=102901

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
