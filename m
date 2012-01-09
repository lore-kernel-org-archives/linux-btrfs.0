From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: revert to static snapshot on reboot
Date: Mon, 9 Jan 2012 16:21:31 +0100
Message-ID: <b14e2228999a5acd0ee5d38705da7260.squirrel@webmail.decarpentier.com>
References: <20120109064304.18411.qmail@otpproductions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: btrfs@spiritvideo.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120109064304.18411.qmail@otpproductions.com>
List-ID: <linux-btrfs.vger.kernel.org>

> The plan that occurs to me is to make a snapshot of the system in the
> state that I want to always boot.  Then, I would rewrite the init
> script in the initrd to (a) delete any old tmp copy of the snapshot;
> (b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.
>
> That's a little harder than I was hoping to work -- is there an easier
> way to get this functionality?

I would just create a filesystem with the static content, and on boot do:

mount fs
delete snapshots
create snapshot
unmount fs and mount snapshot.

I'm not sure if you can snapshot a snapshot, otherwise you could start
with a snapshot as well. (Just be sure not to delete it)

Niels


