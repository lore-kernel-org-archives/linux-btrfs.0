Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33596 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbcF0Scn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 14:32:43 -0400
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Chris Murphy <lists@colorremedies.com>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
 <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Francesco Turco <fturco@fastmail.fm>
Message-ID: <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm>
Date: Mon, 27 Jun 2016 20:32:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-27 20:18, Chris Murphy wrote:
> If you can grab btrfs-debugfs from
> https://github.com/kdave/btrfs-progs/blob/master/btrfs-debugfs
> 
> And then attach the output to the bug report it might be useful for a
> developer. But really your case is an odd duck, because there's fully
> 14GiB unallocated, so it should be able to create a new one without
> problem.
> 
> $ sudo ./btrfs-debugfs -b /

Done! Thank you, I was not aware of the existence of btrfs-debug...

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
