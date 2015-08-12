Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34769 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbHLRzr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 13:55:47 -0400
Received: by iodb91 with SMTP id b91so27811323iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 10:55:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
	<CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
	<CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
Date: Wed, 12 Aug 2015 13:55:46 -0400
Message-ID: <CAK7bmU9SL7Fxqe+hAbe229Y7Fzegs2Dx42tLXyZ5Wttk+UeZDQ@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I added a new device and then did a delete missing.  I lost the
terminal (should have used gnu screen), so I didn't see the stdout,
but the operation aborted at some point.  There's ton of output in
dmesg related to this, along with some OOPSes, which I have attached
as "dmesg2" here:

https://bugzilla.kernel.org/show_bug.cgi?id=102691


-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
