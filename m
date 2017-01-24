Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:35135 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdAXUNt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:13:49 -0500
Received: by mail-yb0-f193.google.com with SMTP id j82so7942131ybg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 12:13:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
References: <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com> <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com> <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com> <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader> <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader> <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 13:13:47 -0700
Message-ID: <CAJCQCtQjQtP5XCbdphLX1BTU382xn0b05oSF5D-WCw9E6U5yqA@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Chris Murphy <lists@colorremedies.com>
Cc: Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK I've reproduced it in a virt-manager VM with Fedora Rawhide from a
week old ISO, which is using btrfs-progs 4.9 and kernel 4.10-rc3.

Get this though. The problem doesn't happen with boot param selinux=0,
either in the VM or one of the laptops. Whereas the problem happens
still with enforcing=0. So this could be an selinux xattr that's
involved.

Chris Murphy
