Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38902 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081Ab3BTSN0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 13:13:26 -0500
Date: Wed, 20 Feb 2013 10:13:26 -0800
From: Zach Brown <zab@zabbo.net>
To: Petr Bena <benapetr@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs doesn't report proper error when removing subvolume
Message-ID: <20130220181326.GU22221@lenny.home.zabbo.net>
References: <CA+4EQ5dZN5YdvsJG+jO1LH8SghH_iedLYo7DN3zk1+m7o0QC9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+4EQ5dZN5YdvsJG+jO1LH8SghH_iedLYo7DN3zk1+m7o0QC9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> petrb@bots-bnr1:/mnt$ btrfs subvolume delete ext2_saved/
> Delete subvolume '/mnt/ext2_saved'
> ERROR: cannot delete '/mnt/ext2_saved'
> 
> this is not really very descriptive. It would be really cool if it
> told me why it can't delete it.

Hmm.  I think this has been fixed for a long time.

  [zab@f18 ~]$ btrfs sub delete /mnt/btrfs/blah/
  Delete subvolume '/mnt/btrfs/blah'
  ERROR: cannot delete '/mnt/btrfs/blah' - Operation not permitted

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commit;h=17cf679fb3622a9e3452777d07fcf3a346266ff1

Where'd you find that btrfs-progs version? :)

- z
