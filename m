From: Peter Stuge <peter@stuge.se>
Subject: Re: Kernel BUG at fs/btrfs/inode.c:2281 & 4665
Date: Tue, 12 Apr 2011 20:20:38 +0200
Message-ID: <20110412182038.17617.qmail@stuge.se>
References: <4931fe2bc7e70ddc21f0240f9b65bb29.squirrel@squirrel-webmail.surftown.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: maria@ponstudios.se
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4931fe2bc7e70ddc21f0240f9b65bb29.squirrel@squirrel-webmail.surftown.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hej Maria!

maria@ponstudios.se wrote:
> The computer was idle when the first bug happened

Ouch.


> and after the reboot btrfs can't be mounted.

Can you get some messages out of btrfs tools run against the file
system when offline, or an image of it? Maybe hook the fs up to
another machine.


//Peter
