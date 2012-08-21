Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40027 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2HUQvT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 12:51:19 -0400
Received: by weyx8 with SMTP id x8so12432wey.19
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2012 09:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120821160019.GN17430@twin.jikos.cz>
References: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
 <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com> <20120821160019.GN17430@twin.jikos.cz>
From: Not Zippy <notzippy@gmail.com>
Date: Tue, 21 Aug 2012 09:50:58 -0700
Message-ID: <CANDob0LpwsWP=jcyMkxZor0_6AnFeHY6zt-Sp6V0HH+Pd2SH=w@mail.gmail.com>
Subject: Re: Computer crash, btrfs partition errors
To: dave@jikos.cz, Not Zippy <notzippy@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Thanks for the analysis, unfortunately I get the same assert error
when I attempt to run the repair from the compiled source.

# ./work/builds/btrfs-progs/btrfsck
usage: btrfsck dev
Btrfs Btrfs v0.19

# ./work/builds/btrfs-progs/btrfsck --repair /dev/sda2
enabling repair mode
checking extents
leaf parent key incorrect 46329503744
bad block 46329503744
owner ref check failed [46329503744 4096]
repair deleting extent record: key 46329503744 168 4096
adding new tree backref on start 46329503744 len 4096 parent 256 root 256
repaired damaged extent references
checking fs roots
btrfsck: btrfsck.c:397: process_inode_item: Assertion `!(rec->ino !=
key->objectid || rec->refs > 1)' failed.
Aborted
