Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaAMSfE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 13:35:04 -0500
Date: Mon, 13 Jan 2014 19:23:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jbacik@fb.com
Subject: Re: btrfs send: page allocation failure
Message-ID: <20140113182312.GR6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52D3E308.7060309@jrs-s.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D3E308.7060309@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 13, 2014 at 07:58:48AM -0500, Jim Salter wrote:
> Getting sporadic page allocation failures in btrfs send. This happened once
> several weeks ago but was fine after a reboot; yesterday I did not reboot,
> but had the failure back-to-back trying to send two different snapshots.
> These are full sends, not incremental, of a bit over 600G of data. Test
> machine has 32G of RAM, with 21G of it free (not including cache):
> 
> root@gwa-virt1:/data/images/.snapshots# free -m
>              total       used       free     shared    buffers cached
> Mem:         32159      31789        369          0          0 21276
> -/+ buffers/cache:      10513      21646
> Swap:            0          0          0
> 
> In both cases (all three, really) the btrfs send failed a bit more than half
> of the way through the send (somewhere around the 380GB mark).
> 
> Kern log snippets follow:
> 
> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627611] btrfs: page allocation
> failure: order:6, mode:0x104050
> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627818] [<ffffffffa01876dd>] ?
> ulist_add_merge+0xcd/0x270 [btrfs]

That's the krealloc failure, Josef has a patch that came out of
https://bugzilla.kernel.org/show_bug.cgi?id=60579
but I don't see it merged anywhere.

david
