Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox1.develooper.com ([207.171.7.178]:40897 "EHLO
	mbox1.develooper.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3CXIHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Mar 2013 04:07:47 -0400
Received: from mbox1.develooper.com (mbox1.develooper.com [127.0.0.1])
	by mbox1.develooper.com (Postfix) with ESMTP id BA0E1175B2B
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2013 01:07:46 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: btrfs "stuck" on 
From: =?iso-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
In-Reply-To: <20130323001201.2bbbb817@natsu>
Date: Sun, 24 Mar 2013 01:07:39 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <397D37BF-8FB1-4108-94DF-EBF73F545C30@develooper.com>
References: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com> <20130323001201.2bbbb817@natsu>
To: Roman Mamedov <rm@romanrm.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 22, 2013, at 11:12 AM, Roman Mamedov <rm@romanrm.ru> wrote:

>> The "disk" is an iscsi disk that in my benchmarks performs roughly like a local raid with 2-3 SATA disks.
> 
> I think you should re-verify if this is still the case. Maybe your block
> device performance suddenly plummeted for some other unrelated issue?
> 
> The simplest test would be "hdparm -t /dev/sdc".

If I boot without mounting the btrfs file system then I get:

 Timing buffered disk reads: 268 MB in  3.01 seconds =  89.14 MB/sec
 Timing buffered disk reads: 268 MB in  3.02 seconds =  88.86 MB/sec
 Timing buffered disk reads: 268 MB in  3.01 seconds =  89.18 MB/sec
 Timing buffered disk reads: 266 MB in  3.00 seconds =  88.59 MB/sec
 Timing buffered disk reads: 272 MB in  3.01 seconds =  90.26 MB/sec
 Timing buffered disk reads: 268 MB in  3.01 seconds =  88.99 MB/sec
 Timing buffered disk reads: 266 MB in  3.01 seconds =  88.48 MB/sec

I also made a new LUN on the iscsi target and tested with bonnie++ on a fresh btrfs file system on that device and got reasonable results (mounted without compression to make sure that wouldn't make it cheat on actual IO):

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
gunnarr.bn.d 15456M   476  99 122194  13 42724   8  2327  95 113553  14 494.8  21
Latency             44109us     465ms     268ms   19309us     300ms    1161ms
Version  1.96       ------Sequential Create------ --------Random Create--------
gunnarr.bn.dev      -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 14550  57 +++++ +++ 20353  67 15617  61 +++++ +++ 19165  72
Latency               295us     566us     532us     373us      29us     561us


For what it's worth the iscsi target (a Synology box, some sort of linux) shows lower load running bonnie++ than when the other btrfs file system is mounted with the btrfs-cleaner process running (and nothing happening).

Ask