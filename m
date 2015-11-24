Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbbKXR35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 12:29:57 -0500
Date: Tue, 24 Nov 2015 18:28:12 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [Bug] btrfs-progs v4.3.1, mkfs.btrfs manpage, profiles table
 missing raid1
Message-ID: <20151124172811.GK31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <pan$130bd$2fb4e52a$aef597d4$e021ef73@cox.net>
 <20151123180751.GJ31035@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20151123180751.GJ31035@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 23, 2015 at 07:07:51PM +0100, David Sterba wrote:
> > Also, it calls raid5/6 "copies" rather than "parity".  Perhaps add 
> > another column for parity, change the redundancy column to copies, and 
> > adjust accordingly?  Alternatively, keep the single redundancy column and 
> > just change raid5 to 1 parity and raid6 to 2 parity.
> 
> Yeah, parity would be better. I'll split it to copy and parity, where a
> copy really means 1:1 byte copy.

Copy from manual page rendering:

       ┌────────┬────────────────────────────────────┬─────────────────┐
       │        │                                    │                 │
       │Profile │ Redundancy                         │ Min/max devices │
       │        ├──────────────┬────────┬────────────┤                 │
       │        │              │        │            │                 │
       │        │    Copies    │ Parity │  Striping  │                 │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │single  │      1       │        │            │      1/any      │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │  DUP   │ 2 / 1 device │        │            │ 1/1 (see note)  │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │ RAID0  │              │        │   1 to N   │      2/any      │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │ RAID1  │      2       │        │            │      2/any      │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │RAID10  │      2       │        │   1 to N   │      4/any      │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │ RAID5  │      1       │   1    │ 2 to N - 1 │      2/any      │
       ├────────┼──────────────┼────────┼────────────┼─────────────────┤
       │        │              │        │            │                 │
       │ RAID6  │      1       │   2    │ 3 to N - 2 │      3/any      │
       └────────┴──────────────┴────────┴────────────┴─────────────────┘

https://github.com/kdave/btrfs-progs/blob/devel/Documentation/mkfs.btrfs.asciidoc#profiles

(ignore the alignment and other formatting artifacts, it looks better in
the manual page or html)
