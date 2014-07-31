Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:54694 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaGaSIQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 14:08:16 -0400
Received: by mail-vc0-f181.google.com with SMTP id lf12so4888698vcb.12
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 11:08:15 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 31 Jul 2014 14:08:15 -0400
Message-ID: <CAPDOMVi7fS9zwpZcENiSxhWWn02VfV5H9qnHrK-4kfjLW1zaXg@mail.gmail.com>
Subject: Implement new FALLOC_FL_* modes
From: Nick Krause <xerofoify@gmail.com>
To: "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am doing this project from the btrfs wiki, since I am new after
reading the code using lxr I am wondering if
we can base the code off that already in ext4 for these modes as they
seem to work rather well. I am wondering
through as a newbie some of the data structures are ext4 based and the
same goes for some of the functions.
I am wondering what the equivalent structures and functions are in
btrfs as I can't seem to find them after reading
the code as a newbie for the last few hours in lxr. Maybe I just
missing something?
Regards Nick
