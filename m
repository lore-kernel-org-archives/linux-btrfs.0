Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48685 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbaIBUKV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 16:10:21 -0400
Message-ID: <54062424.9040508@fb.com>
Date: Tue, 2 Sep 2014 16:10:12 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>, Duncan <1i5t5.duncan@cox.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>	<540498AF.6030109@fb.com>	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>	<pan$1b676$93919c37$3c0fae08$71129a93@cox.net> <CANg_oxxiAJbchugA2puD7PE3qgd_iQ+Lwpzs416YPBUBCKVOag@mail.gmail.com>
In-Reply-To: <CANg_oxxiAJbchugA2puD7PE3qgd_iQ+Lwpzs416YPBUBCKVOag@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On 09/02/2014 03:56 PM, john terragon wrote:
> Nice...now I get the hung task even with 3.14.17.... And I tried with
> 4K for node and leaf size...same result. And to top it all off, today
> I've been bitten by the bug also on my main root fs (which is on two
> fast ssd), although with 3.16.1.
> 
> Is it at least safe for the data? I mean, as long as the hung process
> terminates and no other error shows up, can I at least be sure that
> the data written is correct?

Your traces are a little different.  The ENOSPC code is throttling
things to make sure you have enough room for the writes you're doing.
The code we have in 3.17-rc3 (or my for-linus branch) are the best
choices right now.  You can pull that down to 3.16 if you want all the
fixes on a more stable kernel.

Nailing down the ENOSPC code is going to be a little different, I think
autodefrag probably isn't interacting well with being short on space and
encryption.  This is leading to much more IO than we'd normally do, and
dm-crypt makes it fairly intensive.

Can you try flipping off autodefrag?

-chris
