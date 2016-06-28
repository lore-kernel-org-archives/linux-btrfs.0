Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36399 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbcF1NwF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 09:52:05 -0400
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Henk Slager <eye1tm@gmail.com>, Chris Murphy <lists@colorremedies.com>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
 <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
 <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm>
 <CAJCQCtSdNitRUA498COj1S3bcgdVA8Xf6qq1Fw71pbn_m=Z62A@mail.gmail.com>
 <CAPmG0jbhv8tL4wOimNuAYKv+BruZy=JfzjjhjnEg6nbF5A+1_g@mail.gmail.com>
 <640254ee-1773-0d47-4190-7082512c6f43@mendix.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Francesco Turco <fturco@fastmail.fm>
Message-ID: <cbbbf181-f883-68ab-1a7a-be1349ab5faa@fastmail.fm>
Date: Tue, 28 Jun 2016 15:52:02 +0200
MIME-Version: 1.0
In-Reply-To: <640254ee-1773-0d47-4190-7082512c6f43@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-27 23:47, Hans van Kranenburg wrote:
> Since the existence of python-btrfs, it has gathered a few useful
> example scripts:
> 
> git clone https://github.com/knorrie/python-btrfs
> cd python-btrfs/examples/
> (get root prompt)
> 
> ./show_usage.py /mountpoint <- view sorted by 'virtual' address space
> ./show_dev_extents.py /mountpoint <- view sorted by physical layout
> 
> The show_usage in the btrfs-heatmap repo is almost gone. I'm currently
> replacing all the proof of concept playing around stuff in there with
> dedicated png-creation code that uses the python-btrfs lib.

I also issued the show_dev_extents.py command as you suggested. Hope it
helps.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
