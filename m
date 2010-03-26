From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: btrfs subvol diff
Date: Fri, 26 Mar 2010 22:38:31 +0100
Message-ID: <20100326223831.4fc45d20@simplux>
References: <20100326111807.24dcc2f0@simplux>
	<20100326212207.424db8af@simplux>
	<20100326202646.GG13680@think>
	<201003262136.32330.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: kreijack@gmail.com, Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003262136.32330.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

> It is possible to combine the commands max-gen and find-new ? Something like:
> 
> 	$ btrfs subvol find-new subvol1 snap1

I had very similar thoughts myself.

If we compare two snapshots (of the same subvolume) we wouldn't need timestamps
either, e.g.:

btrfs subvol diff <old_snapshot> <new_snapshot>

The output could be a list of files (and directories); each line prefixed with
a plus sign (for new or modified files) or a minus sign (for deleted files).

The output could be easily postprocessed using grep and cut.

Greetings, Michael

