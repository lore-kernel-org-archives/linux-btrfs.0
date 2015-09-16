Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35318 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbbIPQpu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 12:45:50 -0400
Received: by lagj9 with SMTP id j9so135257019lag.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 09:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F988A6.8070109@gmail.com>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Wed, 16 Sep 2015 18:45:29 +0200
Message-ID: <CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
Subject: Re: FYIO: A rant about btrfs
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

2015-09-16 17:20 GMT+02:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
[...]
> 3. He's testing it for a workload is a known and documented problem for
> BTRFS, and claiming that that means that it isn't worth considering as a
> general usage filesystem.  Most people don't run RDBMS servers on their
> systems, and as such, such a workload is not worth considering for most
> people.
>
> His points about the degree of performance jitter are valid however, as are
> the complaints of apparent CPU intensive stalls in the BTRFS code, and I
> occasionally see both on my own systems.

Are there any conceptual or design properties that make btrfs perform
worse in this workload compared to ZFS or F2FS that both do CoW and
share some similarity?

If not then I still think (from a user perspective) it it still
interesting too look where the difference is coming from? There is
also a quite old talk with some unfortunate numbers for btrfs from the
XFS developer Dave Chinner:
https://www.youtube.com/watch?v=FegjLbCnoBw - is this already
resolved? 2012 is 3 years ago.

>From reading the list I understand that btrfs is still very much work
in progress and performance is not a top priority at this stage but I
don't see why it shouldn't perform at least equally good as ZFS/F2FS
on the same workloads. Is looking at performance problems on the
development roadmap?

regards
Martin
