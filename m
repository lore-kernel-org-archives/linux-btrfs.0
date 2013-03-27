Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40765 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3C0BqA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 21:46:00 -0400
Received: by mail-qc0-f174.google.com with SMTP id z24so3481487qcq.33
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 18:45:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 09:45:59 +0800
Message-ID: <CAEH94Lgbo_QLkWzqE5cOSC7WAV5HCKhBSKR6LUG2trePH7D=_w@mail.gmail.com>
Subject: [RFC] How to enable btrfs reserve block space from specific device?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, linuxram@linux.vnet.ibm.com, sekharan@us.ibm.com,
        Ilya Dryomov <idryomov@gmail.com>, mingming cao <mingming@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,

    When i work on btrfs hot relocation feature, i hit one question
about block reservation. btrfs hot relocation need to reserve block
space from specific devices such as SSD, but current btrfs reserving
code doesn't differentiate if block space is reserved from SSD or HDD.
In order to make btrfs support this, I thought that we can introduce
one new block group or flag, but this will maybe make large impact on
current existing other functions. For this, does any guy have some
better idea? thanks.


-- 
Regards,

Zhi Yong Wu
