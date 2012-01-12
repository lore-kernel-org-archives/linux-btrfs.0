From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: revert to static snapshot on reboot
Date: Thu, 12 Jan 2012 23:01:09 +0100
Message-ID: <caac4792c203d54bce7dca9a10903263.squirrel@webmail.decarpentier.com>
References: <20120109064304.18411.qmail@otpproductions.com>
    <b14e2228999a5acd0ee5d38705da7260.squirrel@webmail.decarpentier.com>
    <20120112213813.GA21769@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "Hugo Mills" <hugo@carfax.org.uk>, btrfs@spiritvideo.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120112213813.GA21769@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, Jan 09, 2012 at 04:21:31PM +0100, Niels de Carpentier wrote:
>> > The plan that occurs to me is to make a snapshot of the system in the
>> > state that I want to always boot.  Then, I would rewrite the init
>> > script in the initrd to (a) delete any old tmp copy of the snapshot;
>> > (b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.
>> >
>> > That's a little harder than I was hoping to work -- is there an easier
>> > way to get this functionality?
>>
>> I would just create a filesystem with the static content, and on boot
>> do:
>>
>> mount fs
>> delete snapshots
>> create snapshot
>> unmount fs and mount snapshot.
>>
>> I'm not sure if you can snapshot a snapshot, otherwise you could start
>> with a snapshot as well. (Just be sure not to delete it)
>
>    Yes, you can make snapshots of snapshots. A btrfs snapshot is a
> first-class citizen -- there's no real distinction between the
> original subvolume and a snapshot of it.

Good! That makes the op's case real simple. No need to copy any data, just
snapshot and mount.

Niels

