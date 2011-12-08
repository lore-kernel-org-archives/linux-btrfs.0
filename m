From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:4754 followed by BUG: unable
 to handle kernel NULL pointer dereference at (null)
Date: Thu, 08 Dec 2011 17:03:55 +0100
Message-ID: <4EE0DFEB.2000904@jan-o-sch.net>
References: <vhv4r8-hb5.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <vhv4r8-hb5.ln1@hurikhan.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>

On 07.12.2011 21:40, Kai Krakow wrote:
> Scrubbing reports 1 uncorrectable error. I have this error since my system 
> froze due to some xorg graphic driver instability (was trying out SNA 
> acceleration for sandybridge).
> 
> The problematic file seems to be in /usr/portage but scrubbing doesn't tell 
> me the filename (I was under the impression 3.2.x adds a patch which should 
> report filenames).

It should. Did you take a look at dmesg output after scrubbing? If it
doesn't contain a hint on the file or block, please paste what you get.

> Everytime I run "emerge" (it is a gentoo system) my 
> screen goes black after a few seconds and I can only revert to using ssh.
> 
> Problem is: As soon as this happens, some filesystem accesses block the 
> process in disk state, it cannot be killed. This initiates some feedback 
> loop: From now on any other process trying to access the FS freezes. I can 
> only reisub now. It seems to be fine if data comes from cache instead from 
> disk.

Please try to grab sysrq+w output in this state.

-Jan
