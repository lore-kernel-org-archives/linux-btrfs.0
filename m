Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51681 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbcF0Vrb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 17:47:31 -0400
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Henk Slager <eye1tm@gmail.com>, Chris Murphy <lists@colorremedies.com>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
 <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
 <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm>
 <CAJCQCtSdNitRUA498COj1S3bcgdVA8Xf6qq1Fw71pbn_m=Z62A@mail.gmail.com>
 <CAPmG0jbhv8tL4wOimNuAYKv+BruZy=JfzjjhjnEg6nbF5A+1_g@mail.gmail.com>
Cc: Francesco Turco <fturco@fastmail.fm>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <640254ee-1773-0d47-4190-7082512c6f43@mendix.com>
Date: Mon, 27 Jun 2016 23:47:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbhv8tL4wOimNuAYKv+BruZy=JfzjjhjnEg6nbF5A+1_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On 06/27/2016 11:26 PM, Henk Slager wrote:
>
> btrfs-debug does not show metadata ans system chunks; the balancing
> problem might come from those.
> This script does show all chunks:
> https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py

Since the existence of python-btrfs, it has gathered a few useful 
example scripts:

git clone https://github.com/knorrie/python-btrfs
cd python-btrfs/examples/
(get root prompt)

./show_usage.py /mountpoint <- view sorted by 'virtual' address space
./show_dev_extents.py /mountpoint <- view sorted by physical layout

The show_usage in the btrfs-heatmap repo is almost gone. I'm currently 
replacing all the proof of concept playing around stuff in there with 
dedicated png-creation code that uses the python-btrfs lib.

So, it's better to refer to the examples in python-btrfs instead. Or, 
write some others to create overviews yourself, it gets easier every day. :D

Have fun,

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
