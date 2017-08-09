Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33851 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdHIR76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 13:59:58 -0400
Received: by mail-wm0-f47.google.com with SMTP id t138so15584905wmt.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Aug 2017 10:59:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22169.183.88.87.49.1502260598.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com> <22169.183.88.87.49.1502260598.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 9 Aug 2017 11:59:56 -0600
Message-ID: <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 9, 2017 at 12:36 AM,  <siranee.ja@tpc.co.th> wrote:

>   488  btrfs sub snap mysql_201707230830 mysql
>   489  systemctl start mariadb
>   490  btrfs sub list .
>   491  cat /var/log/mariadb/mariadb.log

OK so mysql_201707230830 once on machine B is inconsistent somehow. So
the questions I have are:

Is mysql_201707230830 on machine A really identical to
mysql_201707230830 on machine B? You can do an rsync -anc (double
check those options) which should independently check whether those
two subvolumes are in fact identical. The -n is a no op, which doesn't
really matter much because as read only subvolumes any attempt to sync
will just result in noisy messages. The -c causes rsync to do its own
checksum verification on both sides.

If the subvolumes are different, we need to find out why.

If the subvolumes are the same, then I wonder if you can reproduce the
mariadb complaint on machine A merely by making a rw snapshot of
mysql_201707230830 and trying to start it. If so, then it's not a send
receive problem, it sounds like the snapshot itself is inconsistent,
maybe mariadb hasn't actually completely closed out the database at
the time the read only snapshot was taken? I'm not sure.

If the subvolumes are different, I'm going to recommend updating at
least the btrfs-progs because 4.4 is kinda old at this point. The
kernel code is what's mainly responsible for the send stream, and the
user space code is mainly responsible for receiving. And I don't off
hand know or want to look up all the send receive changes between 4.4
and 4.12 to speculate on whether this is has already been fixed.

What's the kernel version?

-- 
Chris Murphy
