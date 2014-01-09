Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50646 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaAIK01 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 05:26:27 -0500
Received: by mail-ob0-f176.google.com with SMTP id vb8so3018087obc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 02:26:26 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 11:26:26 +0100
Message-ID: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
Subject: How does btrfs handle bad blocks in raid1?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am running write-intensive (well sort of, one write every 10s)
workloads on cheap flash media which proved to be horribly unreliable.
A 32GB microSDHC card reported bad blocks after 4 days, while a usb
pen drive returns bogus data without any warning at all.

So I wonder, how would btrfs behave in raid1 on two such devices?
Would it simply mark bad blocks as "bad" and continue to be
operational, or will it bail out when some block can not be
read/written anymore on one of the two devices?

Thank you in advance, Clemens
