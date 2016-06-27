Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34780 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbcF0SSq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 14:18:46 -0400
Received: by mail-oi0-f42.google.com with SMTP id s66so211768251oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 11:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 12:18:44 -0600
Message-ID: <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Francesco Turco <fturco@fastmail.fm>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 11:28 AM, Francesco Turco <fturco@fastmail.fm> wrote:
> Note: I already filed bug 121071 but perhaps I should have written to
> this mailing list first.

https://bugzilla.kernel.org/show_bug.cgi?id=121071

It's a good bug report.


> Is there anything I can try? Should I run the command from a live CD? Is
> this a real bug or a mistake from an unexperienced btrfs user like me?

It's a bug somewhere, not a user mistake.

If you can grab btrfs-debugfs from
https://github.com/kdave/btrfs-progs/blob/master/btrfs-debugfs

And then attach the output to the bug report it might be useful for a
developer. But really your case is an odd duck, because there's fully
14GiB unallocated, so it should be able to create a new one without
problem.

$ sudo ./btrfs-debugfs -b /



-- 
Chris Murphy
