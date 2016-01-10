Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38573 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcAJWYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 17:24:49 -0500
Received: by mail-wm0-f51.google.com with SMTP id b14so243190106wmb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jan 2016 14:24:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201601101716.43204.russell@coker.com.au>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <201601101716.43204.russell@coker.com.au>
From: "cheater00 ." <cheater00@gmail.com>
Date: Sun, 10 Jan 2016 23:24:28 +0100
Message-ID: <CA+9GZUhSQe4Yk-dm+=D_6xTAMh7y6B-29wwEiaTNpw84rETcsg@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Russell Coker <russell@coker.com.au>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 10, 2016 at 7:16 AM, Russell Coker <russell@coker.com.au> wrote:
> On Sun, 10 Jan 2016 08:07:50 AM cheater00 . wrote:
>> Would like to point out that this can cause data loss. If I'm writing
>> to disk and the disk becomes unexpectedly read only - that data will
>> be lost, because who in their right mind makes their code expect this
>> and builds a contingency (e.g. caching, backpressure, etc)...
>
> I was under the impression that this bug didn't make the disk read-only (IE
> you can delete/truncate files to free space) but instead incorrectly told the
> application that there was no space.  ENOSPACE is very common and all apps
> have to deal with it.

The kernel remounts the disk as ro when this bug happens.

>> There's no loss of data on the disk because the data doesn't make it
>> to disk in the first place. But it's exactly the same as if the data
>> had been written to disk, and then lost.

> No it's not.  If you write data and a fsync() or fdatasync() call succeeds
> then it's on disk, otherwise not.  All apps which depend on data being written
> to disk (EG database servers and mail servers) use fsync() and fdatasync().

> Please test this with the common mail server software, EG Postfix, Exim,
> Procmail, Maildrop, Dovecot, etc.  The BTRFS bug as described won't cause data
> loss with any of them.

It's easy to imagine this scenario: you don't want your server to run
out of space, so you put alerts in place for when there's, say, only
10 GB left, and will provision new servers at that point. So you keep
on doing df (or even btrfs filesystem df) and that works. But then
this bug shows up and you run out of space even though you still have
3 terabytes left according to your metrics. At this point your server
breaks down and cannot accept jobs any more, even though according to
everything you've done it should. So even though your system
(including the btrfs code) assures you that you might be able to
receive a message within say 60 seconds (the maximum time to provision
a server on your cloud provider), it turns out the time extends
indefinitely, that is until you notice there's an issue and intervene,
which might be, say, half an hour. During which time messages are lost
because the sender only retries for 60 seconds and then throws away
the message forever. There you go, loss of data and service.
