From: "Joshua J. Berry" <des@condordes.net>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 10:11:46 -0800
Message-ID: <200812101011.46866.des@condordes.net>
References: <20081209145952.GA30494@tux64-03> <493F043B.50804@hp.com> <1228916687.11900.10.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: jim owens <jowens@hp.com>, Diego Calleja <diegocg@gmail.com>,
	Lee Trager <lt73@cs.drexel.edu>,
	Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228916687.11900.10.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 10 December 2008 05:44:47 Chris Mason wrote:
[snip]
> The second is using xattr programs to set the flag, which I don't really
> have an opinion on.  The idea of having the flags backed up by backup
> programs or rsync is really nice, but do any of the backup programs
> actually copy out all the xattrs?

rsync has the -X option.  rdiff-backup autodetects whether xattrs are 
supported.

Those are the programs I use; dunno about others.

-- Josh


-- 
Joshua J. Berry

"I haven't lost my mind -- it's backed up on tape somewhere."
    -- /usr/games/fortune

