Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3CKRqj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 13:46:39 -0400
Date: Mon, 11 Mar 2013 18:46:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Michael Johnson - MJ <mj@revmj.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: snapshot deletion / unmount slowness
Message-ID: <20130311174637.GG7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 10:31:08PM -0700, Michael Johnson - MJ wrote:
> I currently have a btrfs filesystem that I am unmounting and it has
> been has been "unmounting" for the last 20 minutes.
> 
> I'm pretty sure I know exactly what is going on and in my current
> situation it's not a huge issues, but it would be a problem if this
> was a production system and I was trying to do a maintenance.
> 
> Here is how I got into this situation:
> 
> What I now suspect is going on is that while deleting the snapshots
> was quick, that probably kicks of a background thread which actually
> does the heavy lifting.  I noticed a btrfs-cleaner process that was in
> an io wait state, which I presumed was the process in question.
> However, now 40 minutes later, my unmount is still hung and the
> btrfs-cleaner process is sleeping, so perhaps I am wrong.

The umount blocked by cleaner is known and I have now a patch ready to
improve that

http://thread.gmane.org/gmane.comp.file-systems.btrfs/23212

cleaner does not wait to do the background work for all deleted
snapshots and is able to return in the middle of processing the current
one when the fs si going down.

There's another umount blocker, when a huge orphan file is being cleaned
up, but from first look it also seems to be possible exit early if
umount is detected.


david
