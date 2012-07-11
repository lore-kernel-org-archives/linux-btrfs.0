Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2GKIgW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 04:36:22 -0400
Date: Wed, 11 Jul 2012 10:36:20 +0200 (CEST)
From: "haveaniceday@cv-sv.de" <haveaniceday@cv-sv.de>
Reply-To: "haveaniceday@cv-sv.de" <haveaniceday@cv-sv.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <209200388.295540.1341995780489.JavaMail.open-xchange@email.1und1.de>
In-Reply-To: <4FFD278D.20804@oracle.com>
References: <4FF9B07C.8090209@cv-sv.de> <4FFA52BC.9010401@oracle.com> <4FFB4BB4.4080408@cv-sv.de> <4FFBCC1A.8020800@oracle.com> <1462124570.240756.1341911618590.JavaMail.open-xchange@email.1und1.de> <333721177.250041.1341918535801.JavaMail.open-xchange@email.1und1.de> <4FFD278D.20804@oracle.com>
Subject: Re: btrfsck crashes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Anand Jain <Anand.Jain@oracle.com> hat am 11. Juli 2012 um 09:13 geschrieben:

>
>
>   If this is a deliberate corruption can you pls share the test-case ?
No. It's a real life corruption on a file system used to back up some servers.

That's also why basics like aquota,awk etc. are found.

But I expect it would be very hard to make a reproducible test case with error.
(Usage: see  PS: below.)

>   if not have you tried mount with recovery and the scrub. ? scrub>   would be
> preferred choice over btrfsck.
I can scrub this file system.
But isn't it a good test to try some recovery? A stable btrfs later should
manage  corruptions like this SIGSEGV and data loss.
I expect a real life recover could cover more strange things than the test cases
:)

So it's your/ btrfs supporters choice. How far we should follow this issue.
I did in between an image of the corrupted file system, so multiple recovery
tries are possible.

Best regards,
Christian

PS: I would bet that my kind of usage is a very good stress test for btrfs.

- large file system "/backup" btrfs with compress enabled.

Content of the file system:
- ./server1 .... /server5  as directories
- for each server the directory has a structure like this:
  backup-YYYY-DD-MM-HH:M
  New backups are created with:
  rsync -axvH --link-dest=/backup/server'n'/backup-...(old, last dir)..
  server:/   /backup/server'n'/backup-YYY-.../.

This generates files with a large number of hard links.
