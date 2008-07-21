From: Chris Mason <chris.mason@oracle.com>
Subject: Re: single disk reed solomon codes
Date: Mon, 21 Jul 2008 09:03:36 -0400
Message-ID: <1216645416.6932.98.camel@think.oraclecorp.com>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
	 <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
	 <1216622923.6970.19.camel@s1.crocom.com.pl>
	 <3da3b5b40807210040s72fdf458g44a1fe968088586e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tomasz Torcz <tomek@crocom.com.pl>, linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807210040s72fdf458g44a1fe968088586e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 10:40 +0300, Ahmed Kamal wrote:
> I definitely hope btrfs has this per-object "copies" property too.
> However, simply replicating the whole contents of a directory, wastes
> too much disk space, as opposed to RS codes
> 

Btrfs already has a raid level where things are duplicated on the single
spindles and it is on by default for metadata.  mkfs isn't currently
setup to use this on data blocks, but it is certainly possible (look for
BTRFS_BLOCK_GROUP_DUP).  This is definitely less reliable than two
physical devices, and I worry that such a feature would give people the
impression that single drive raid is a good idea.

As others have already said, the drives to have considerable error
detection and correction already.  One of the main benefits of the
checksums is being able to tell which copy of the data from a group of
drives is correct.

In terms of detecting errors, the data checksums will do that.

-chris


