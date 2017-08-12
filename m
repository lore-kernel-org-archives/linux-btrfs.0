Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:35341 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751819AbdHLVeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 17:34:02 -0400
Received: by mail-vk0-f43.google.com with SMTP id d124so22747980vkf.2
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Aug 2017 14:34:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1420.49.228.123.163.1502514511.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 12 Aug 2017 15:34:01 -0600
Message-ID: <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 11, 2017 at 11:08 PM,  <siranee.ja@tpc.co.th> wrote:


> The backup script has the btrfs sync command since Aug 3


>From your script:
> system btrfs sub snap -r $basepath $snappath
> system btrfs sub sync $basepath

>From the man page: sync <path> [subvolid...]
           Wait until given subvolume(s) are completely removed from the
           filesystem after deletion.


This 'subvolume sync' command, per the man page, is only about
subvolume deletion. I suggest replacing it with a regular sync
command.

I think the problem is that the script does things so fast that the
snapshot is not always consistent on disk before btrfs send starts.
It's just a guess though. If I'm right, this means the rsync mismaches
mean the destination snapshots are bad. Here's what I would do:


- delete all the bad/mismatching snapshots only on the destination computer.

- he most recent good snapshot pair, which rsync shows origin and
destination match, is mysql_201708080830 so you can keep that one on
both sides.

- manually do incremental send/receive, starting with
mysql_201708090830/, to make the destination current again with the
origin.

- confirm with rsync that the snapshot pairs on origin and destination
are the same

- now resume using the modified script, which will do snapshot -> sync -> send.

OPTIONAL, you could add to your script an rsync -avnc to double check
that the incremental send receive is working. This is admittedly
inefficient because it checks the *entire* contents of the snapshots
on both sides, it's not just checking the incremental data. But if it
doesn't take too long, it will help restore trust in send/receive, and
confirm that a regular sync is needed in between snapshot and send.




-- 
Chris Murphy
