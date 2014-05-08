Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63786 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbaEHQLF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 12:11:05 -0400
Message-ID: <536BAC5F.60803@fb.com>
Date: Thu, 8 May 2014 12:10:07 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <russell@coker.com.au>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Balance performance problem with 3.14.1
References: <201405081950.23922.russell@coker.com.au>
In-Reply-To: <201405081950.23922.russell@coker.com.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2014 05:50 AM, Russell Coker wrote:
> I've got a server/workstation (KDE desktop and file server) running kernel
> 3.14.1 from the Debian package 3.14-trunk-amd64.
>
> It was running well until I decided to do a full balance of the BTRFS RAID-1
> array of 3TB SATA disks (which hadn't been balanced before due to previous
> kernels performing badly with scrub or balance).  I canceled the balance after
> about 5 days when it had been claiming to be about 65% done for a day while
> doing a lot of disk IO.
>

Can I see dmesg/messages for the time that this was running for so long?

> After canceling the balance the performance of the array has been poor.  It
> has a cron job that runs twice a week to rsync data from a Maildir based mail
> server that currently has 2401473 Inodes in use according to ZFS on the mail
> server (unfortunately BTRFS won't tell me how many Inodes are in use).  The
> cron job does an "rsync -va" type backup WITHOUT the -c option, so we're
> basically doing a recursive stat on all files and then transferring new files
> (Dovecot index files are excluded so files tend never to change).  After the
> rsync is complete "cp -rl" is used to make a backup of the tree.
>
> The cp -rl usually takes something less than 30 minutes (not long enough for
> me to even notice) but today cp has been running for 5.5 hours and seems to be
> about 3/5 done (9000/15000 subdirectories linked).
>

Sysrq+w while it's running, just one and then wait a while and then 
another.  Thanks,

Josef
