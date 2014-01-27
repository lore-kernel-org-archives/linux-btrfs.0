Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43232 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaA0Nxk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:53:40 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so2245609eek.6
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:53:39 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id a8sm36885465eeo.3.2014.01.27.05.53.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:53:38 -0800 (PST)
Message-ID: <52E664E0.5070909@gmail.com>
Date: Mon, 27 Jan 2014 14:53:36 +0100
From: KC <impactoria@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Snapshots =?windows-1252?Q?=96_noob_questions?=
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been trying to understand how snapshots work (in BRTFS and in 
general), but I still have some questions, and would appreciate if 
someone could clear them for me.
To make things easier, I tried to make most of them Yes/No questions:

1. When creating the filesystem, I only made btrfs partition with no 
subvolumes. Do I have to use subvolumes, or can I snapshot entire “/“?

2. Can I take a snapshot of a working / root filesystem?

3. If I make a snapshot of / and there are some separate partitions 
mounted under /mnt/ or /home/, will snapshot skip them?

4. If I have a snapshot of  /, can I completely erase this partition and 
later restore it in full form that snapshot, or do snapshots work only 
if a limited number of files has been changed?
If the former, then does it mean that snapshot size will be comparable 
to the original data size?

5. Can a snapshot be stored on a different partition? And if so, does 
that partition have to be BTRFS too? I ask, because I would also want to 
store snapshots in a cloud storage.

Thanks.
