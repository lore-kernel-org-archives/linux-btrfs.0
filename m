Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbKWSJg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 13:09:36 -0500
Date: Mon, 23 Nov 2015 19:07:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [Bug] btrfs-progs v4.3.1, mkfs.btrfs manpage, profiles table
 missing raid1
Message-ID: <20151123180751.GJ31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <pan$130bd$2fb4e52a$aef597d4$e021ef73@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$130bd$2fb4e52a$aef597d4$e021ef73@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2015 at 11:05:44AM +0000, Duncan wrote:
> As in the title...
> 
> The btrfs-progs v4.3.1 mkfs.btrfs manpage has a quite nice profiles table 
> listing the various profiles, single/dup/raid0/raid10/raid5/raid6.
> 
> It's missing raid1. =:^(

Oh, that's not intentional, I'll fix it.

> Also, it calls raid5/6 "copies" rather than "parity".  Perhaps add 
> another column for parity, change the redundancy column to copies, and 
> adjust accordingly?  Alternatively, keep the single redundancy column and 
> just change raid5 to 1 parity and raid6 to 2 parity.

Yeah, parity would be better. I'll split it to copy and parity, where a
copy really means 1:1 byte copy.

> Other than that, I really like the nice profiles table layout.
> Kudos to whoever set that up. =:^)

Thanks ;)
