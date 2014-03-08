Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45777 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbaCHVz5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Mar 2014 16:55:57 -0500
From: Josef Bacik <jbacik@fb.com>
To: Hugo Mills <hugo@carfax.org.uk>
CC: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: send/receive locking
Date: Sat, 8 Mar 2014 21:55:50 +0000
Message-ID: <usnory0eq5h626p5eaeeh4ki.1394315749442@email.android.com>
References: <20140308215350.GE6318@carfax.org.uk>
In-Reply-To: <20140308215350.GE6318@carfax.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Hugo will you try the danger branch on btrfs-next, Wang changed the locking a bit.  Thanks,

Josef

Hugo Mills <hugo@carfax.org.uk> wrote:


   Is there anything that can be done about the issues of btrfs send
blocking? I've been writing a backup script (slowly), and several
times I've managed to hit a situation where large chunks of the
machine grind to a complete halt in D state because the backup script
has jammed up.

   Now, I'm aware that you can't send and receive to the same
filesystem at the same time, and that's a restriction I can live with.
However, having things that aren't related to the backup process
suddenly stop working because the backup script is trying to log its
progress to the same FS it's backing up is... umm... somewhat vexing,
to say the least.

   Is this a truly fundamental property of send/receive, or is there
likely to be a simple(ish) solution?

   Hugo.

--
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or https://urldefense.proofpoint.com/v1/url?u=http://www.carfax.org.uk/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=DpjVPUDw%2BBOF8It3j6uqicc%2Fa8ToXNmi%2FzBNxek3pv8%3D%0A&s=b4f6d6e5bbee25bad639a60b61a95c5813d89a00a979388dea429adfb3902498
   --- Well, you don't get to be a kernel hacker simply by looking ---
                    good in Speedos. -- Rusty Russell
