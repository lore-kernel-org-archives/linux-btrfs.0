From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Re: Missing entry for updated directory
Date: Sat, 27 Mar 2010 22:19:53 +0100
Message-ID: <20100327221953.35781dcd@simplux>
References: <20100327120420.28af24dd@simplux>
	<201003272047.30636.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: kreijack@gmail.com, linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003272047.30636.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Goffredo!

I checked all btrfs-item types (changed sk->max_type to 255 and removed the
filtering) connected with the updated directory's inode.

But none of them had got a new generation number.

I found the missing directory only using a more conventional tool that checked
all files and directories in both snapshots.

Here the output from stat:

>stat 2010-03-21/root/.googleearth/Temp/.kmztmp/
  File: `2010-03-21/root/.googleearth/Temp/.kmztmp/'
  Size: 21340     	Blocks: 0          IO Block: 4096   directory
Device: 15h/21d	Inode: 31757       Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2010-02-19 22:12:25.339932662 +0100
Modify: 2009-11-18 13:45:52.000000000 +0100
Change: 2010-01-12 19:48:01.911913031 +0100

>stat 2010-03-22/root/.googleearth/Temp/.kmztmp/
  File: `2010-03-22/root/.googleearth/Temp/.kmztmp/'
  Size: 21268     	Blocks: 0          IO Block: 4096   directory
Device: 16h/22d	Inode: 31757       Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2010-02-19 22:12:25.339932662 +0100
Modify: 2010-03-21 21:49:16.512553912 +0100
Change: 2010-03-21 21:49:16.512553912 +0100

Greetings, Michael
