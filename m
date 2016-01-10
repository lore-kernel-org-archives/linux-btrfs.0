Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45867 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbcAJG0o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 01:26:44 -0500
From: Russell Coker <russell@coker.com.au>
To: "cheater00 ." <cheater00@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the "usual" problem
Date: Sun, 10 Jan 2016 17:16:43 +1100
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com> <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
In-Reply-To: <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201601101716.43204.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 10 Jan 2016 08:07:50 AM cheater00 . wrote:
> Would like to point out that this can cause data loss. If I'm writing
> to disk and the disk becomes unexpectedly read only - that data will
> be lost, because who in their right mind makes their code expect this
> and builds a contingency (e.g. caching, backpressure, etc)...

There are lots of situations when a filesystem can become read-only, it's a 
fairly standard response to disk errors.  You should be able to handle that if 
your application deals with important data.

I was under the impression that this bug didn't make the disk read-only (IE 
you can delete/truncate files to free space) but instead incorrectly told the 
application that there was no space.  ENOSPACE is very common and all apps 
have to deal with it.

> There's no loss of data on the disk because the data doesn't make it
> to disk in the first place. But it's exactly the same as if the data
> had been written to disk, and then lost.

No it's not.  If you write data and a fsync() or fdatasync() call succeeds 
then it's on disk, otherwise not.  All apps which depend on data being written 
to disk (EG database servers and mail servers) use fsync() and fdatasync().

On Sun, 10 Jan 2016 02:59:46 PM cheater00 . wrote:
> Not really - at power loss the whole system is unreachable and can not
> accept incoming jobs/RPCs. When btrfs bugs out, it can still do that,
> and will not be able to say "oops i messed up" because it's not the
> kind of error that you'd be expected to handle as a programmer. So say
> an email server will not accept incoming emails at power loss, whereas
> if btrfs bugs out it will accept emails but will put them in a black
> hole. So it's more urgent than "hey this is like power loss and we
> can't really do much about power loss so let's ignore this issue for
> now"

Please test this with the common mail server software, EG Postfix, Exim, 
Procmail, Maildrop, Dovecot, etc.  The BTRFS bug as described won't cause data 
loss with any of them.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
