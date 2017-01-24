Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34533 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbdAXURj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:17:39 -0500
Received: by mail-pf0-f174.google.com with SMTP id e4so52197074pfg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 12:17:38 -0800 (PST)
Date: Tue, 24 Jan 2017 12:17:02 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170124201702.GC2853@vader>
References: <20170123220448.GB11778@vader.DHCP.thefacebook.com>
 <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader>
 <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader>
 <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <CAJCQCtQjQtP5XCbdphLX1BTU382xn0b05oSF5D-WCw9E6U5yqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQjQtP5XCbdphLX1BTU382xn0b05oSF5D-WCw9E6U5yqA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 01:13:47PM -0700, Chris Murphy wrote:
> OK I've reproduced it in a virt-manager VM with Fedora Rawhide from a
> week old ISO, which is using btrfs-progs 4.9 and kernel 4.10-rc3.
> 
> Get this though. The problem doesn't happen with boot param selinux=0,
> either in the VM or one of the laptops. Whereas the problem happens
> still with enforcing=0. So this could be an selinux xattr that's
> involved.
> 
> Chris Murphy

That makes sense, I don't have SELinux compiled into my test kernel.
I'll fix that and try again.
