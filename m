Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33324 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdAWVzX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 16:55:23 -0500
Received: by mail-yw0-f195.google.com with SMTP id u68so18799705ywg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 13:55:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com> <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 23 Jan 2017 14:55:21 -0700
Message-ID: <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Chris Murphy <lists@colorremedies.com>
Cc: Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 2:50 PM, Chris Murphy
> I haven't found the commit for that patch, so maybe it's something
> with the combination of that patch and the previous commit.

I think that's provably not the case based on the bisect log, because
I hit the problem with kernel that has only the commit, as well as the
commit plus the updated patch. So the patch neither causes nor fixes
the problem I'm experiencing.

If it's useful the btrfs-image is here; mentioned in a previous
thread, this image mounts find, btrfs check --mode=original has no
complaints, but btrfs check --mode=lowmem has complaints. There's no
problem using the parent subvolume as rootfs. Only snapshots of that
subvolume result in the problem.
https://drive.google.com/open?id=0B_2Asp8DGjJ9ZmNxdEw1RDBPcTA




-- 
Chris Murphy
