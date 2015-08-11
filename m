Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35393 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbbHKBXX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 21:23:23 -0400
Received: by igbjg10 with SMTP id jg10so12630663igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 18:23:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
Date: Mon, 10 Aug 2015 21:23:22 -0400
Message-ID: <CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 10, 2015 at 6:52 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Four needed things:
> - kernel version

4.1.0-gentoo-r1, although I have also tried 4.1.4.

> - btrfs-progs version

4.1.2

> - complete dmesg for the failed mount

It really doesn't say much.  I have things like this:
[    8.643535] BTRFS info (device sdc): disk space caching is enabled
[    8.643789] BTRFS: failed to read the system array on sdc
[    8.706062] BTRFS: open_ctree failed
[    8.707124] BTRFS info (device sdc): disk space caching is enabled
[    8.710924] BTRFS: failed to read the system array on sdc
[    8.766080] BTRFS: open_ctree failed
[    8.766903] BTRFS info (device sdc): setting nodatacow, compression disabled
[    8.766905] BTRFS info (device sdc): disk space caching is enabled
[    8.767152] BTRFS: failed to read the system array on sdc
[    8.936019] BTRFS: open_ctree failed
[    8.936906] BTRFS info (device sdc): disk space caching is enabled
[    8.939922] BTRFS: failed to read the system array on sdc
[    8.995984] BTRFS: open_ctree failed
[    8.996796] BTRFS info (device sdc): disk space caching is enabled
[    8.997093] BTRFS: failed to read the system array on sdc
[    9.125936] BTRFS: open_ctree failed

Also, when I manually try to mount, I get things like this:

# mount /mnt/btrfs
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

For this fstab entry:
UUID=ecdff84d-b4a2-4286-a1c1-cd7e5396901c /mnt/btrfs btrfs
compress=lzo,noatime,space_cache 0 2

# mount -t btrfs /dev/sdd /mnt/btrfs
mount: wrong fs type, bad option, bad superblock on /dev/sdd,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.


> - complete btrfs check output (you mostly have this but since the
> version isn't included, it's not clear this is the entire output)

I pasted it all.

>
> The last two can be included as attachments in a bugzilla.kernel.org
> bug report and the URL posted in this thread. Typically MUA wrapping
> nerfs the dmesg making it hard to read, so attachments to a bug report
> are better.

Well, if I get something lengthy, I'll attach it to my bug report.
Did the information I reported help at all?  I think that btrfs just
isn't being informative about the problem.  Are there other commands I
can run to get more detailed reports?

BTW, I tried disconnecting the drive with the bad sector.  I still get
all the same errors and can't repair.

>
> Bugs get reported both in bugzilla and on the list.
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F
>
> Sometimes it takes a while for devs to respond, they also get worked
> on even without responses just because there's so many improvements
> each release.
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
