Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:60645 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbbLZO5H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 09:57:07 -0500
Subject: Re: Timeouts copying large files to a Samba server with Btrfs
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
References: <20151220025010.7d353d35@natsu>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <567EAA3A.10401@siedziba.pl>
Date: Sat, 26 Dec 2015 15:54:50 +0100
MIME-Version: 1.0
In-Reply-To: <20151220025010.7d353d35@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> My guess is that the Samba server process submits too much queued buffers at
> once to be written to disk, then blocks on waiting for this, and the whole
> operation ends up taking so long, that it doesn't get back to the client in
> time.

I've seen something similar. I could reproduce it easily:

- upload a big file
- wait for it to be written and commited
- remove the file
- upload another big file before the removal is commited
- commit wakes up [btrfs-transacti] process, which blocks IO for a very 
long time, causing the upload to time out

Demonstration: http://pps.siedziba.pl/btrfs_transaction_smb_timeout.mp4

The FS is on 16TB md raid5, half filled, default mount options except 
noatime. It was running kernel 4.1.4 I think.

I tried defragmenting directories and balancing metadata, which seemed 
to help a bit, then I upgraded to kernel 4.2.5 and the problem 
disappeared, but that kernel version had a nasty memory leak that caused 
everything to OOM after 1-2 days, so I upgraded to just released 4.3.0 
and it works fine since then - I'm observing transaction times of around 
1-2 sec.
