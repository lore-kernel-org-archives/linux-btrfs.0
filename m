Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38447 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3I2NM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 09:12:28 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3D4077C041B
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 07:12:27 -0600 (MDT)
Date: Sun, 29 Sep 2013 09:12:24 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Aastha Mehta <aasthakm@gmail.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions regarding logging upon fsync in btrfs
Message-ID: <20130929131224.GM18681@localhost.localdomain>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
 <20130929004252.GL18681@localhost.localdomain>
 <CAEx9m440QMtfkaZjc5Qgu6jv+TsejheKG5nVuYhAEe_vqgp0MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAEx9m440QMtfkaZjc5Qgu6jv+TsejheKG5nVuYhAEe_vqgp0MQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 29, 2013 at 11:22:36AM +0200, Aastha Mehta wrote:
> Thank you very much for the reply. That clarifies a lot of things.
> 
> I was trying a small test case that opens a file, writes a block of
> data, calls fsync and then closes the file. If I understand correctly,
> fsync would return only after all in-memory buffers have been
> committed to disk. I have added few print statements in the
> __extent_writepage function, and I notice that the function gets
> called a bit later after fsync returns. It seems that I am not
> guaranteed to see the data going to disk by the time fsync returns.
> 
> Am I doing something wrong, or am I looking at the wrong place for
> disk write? This happens both with tree logging enabled as well as
> with notreelog.
> 

So 3.1 was a long time ago and to be sure it had issues I don't think it was
_that_ broken.  You are probably better off instrumenting a recent kernel, 3.11
or just build btrfs-next from git.  But if I were to make a guess I'd say that
__extent_writepage was how both data and metadata was written out at the time (I
don't think I changed it until 3.2 or something later) so what you are likely
seeing is the normal transaction commit after the fsync.  In the case of
notreelog we are likely starting another transaction and you are seeing that
commit (at the time the transaction kthread would start a transaction even if
none had been started yet.)  Thanks,

Josef
