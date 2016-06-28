Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58235 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbcF1Nqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 09:46:46 -0400
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Henk Slager <eye1tm@gmail.com>, Chris Murphy <lists@colorremedies.com>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
 <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
 <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm>
 <CAJCQCtSdNitRUA498COj1S3bcgdVA8Xf6qq1Fw71pbn_m=Z62A@mail.gmail.com>
 <CAPmG0jbhv8tL4wOimNuAYKv+BruZy=JfzjjhjnEg6nbF5A+1_g@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Francesco Turco <fturco@fastmail.fm>
Message-ID: <0fe98668-5448-91c6-964d-4b9ab877668b@fastmail.fm>
Date: Tue, 28 Jun 2016 15:46:43 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbhv8tL4wOimNuAYKv+BruZy=JfzjjhjnEg6nbF5A+1_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-27 23:26, Henk Slager wrote:
> btrfs-debug does not show metadata ans system chunks; the balancing
> problem might come from those.
> This script does show all chunks:
> https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py
> 
> You might want to use vrange or drange balance filters so that you can
> just target a certain chunk and maybe that gives a hint where the
> problem might be. But anyhow, the behavior experienced is a bug.

Updated the bug with the output log from your script. I simply ran it as:

./show_usage.py /

I don't know how to use vrange/drange balance filters. Can you show me
how to do that, please?

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
