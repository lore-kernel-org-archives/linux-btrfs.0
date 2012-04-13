From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs mount flags
Date: Sat, 14 Apr 2012 00:05:08 +0200
Message-ID: <201204140005.08619.Martin@lichtvoll.de>
References: <jjul59-m49.ln1@hurikhan.ath.cx> (sfid-20120413_182119_379057_8476B95A)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jjul59-m49.ln1@hurikhan.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 13. April 2012 schrieb Kai Krakow:
> Hello!

Hi!

> Is there any documentation about btrfs mount flags wrt:
> 
> 1. which flags are one-time options and are permanent,
> 2. which flags are global per btrfs partition,
> 3. which flags are local per subvolume mount?
> 
> I'm asking because while googling I found very confusing info about
> autodefrag. Some say it is a global flag, others say to get autodefrag
> one has to supply it for each subvolume mount to have autodefrag for
> that subvolume.
> 
> Then there's space_cache which is a one-time option and does not need
> to be given on successive mounts. Otoh there's inode_cache which I
> would expect to be handled the same but it doesn't look like it's
> implemented that way.

I like the distinction in Ext3/Ext4. There are mount option and filesystem 
features that can be activated at mkfs time or (some) later with tune2fs.

Now I would expect a one time mount option to be a filesystem feature that 
I enabled with btrfstune or so. Cause I always understood mount options as 
temporary unless I write them into /etc/fstab. But then tune2fs / Ext also 
supports default mount options, so you could encode into the fs as well.

There even is a btrfstune command and it has a switch to enable something:

merkaba:~> btrfstune 
usage: btrfstune [options] device
        -S value        enable/disable seeding

but no manual page here. Seeding is mentioned at:

Seed Device support
It is now possible to create a filesystem to seed other Btrfs filesystems. 
The original filesystem and devices are included as a readonly starting 
point to the new FS. All modifications go onto different devices and the COW 
machinery makes sure the original is unchanged.

http://btrfs.ipv5.de/index.php?title=Changelog#Seed_Device_support


Anyway the documentation of mount options is on:

http://btrfs.ipv5.de/index.php?title=Mount_options

it seems.


There only for "space_cache" it is mentioned that it is permanent. Not for 
"inode_cache".

The mount manpage which usually has mount options of various filesystems 
does not mention BTRFS yet. I am not sure whether each filesystem should 
have an own manpage anyway.


Whatever is used, I would like to have a clear distinction between 
permanent and volatile settings. And I think a permanent option is 
something which should be set and queryable by a tuning command.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
