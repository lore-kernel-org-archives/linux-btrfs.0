From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfs mount flags
Date: Sat, 14 Apr 2012 17:17:30 +0200
Message-ID: <t0ho59-rjd.ln1@hurikhan.ath.cx>
References: <jjul59-m49.ln1@hurikhan.ath.cx> <pan.2012.04.13.17.42.32@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> Kai Krakow posted on Fri, 13 Apr 2012 17:50:45 +0200 as excerpted:
> 
>> Is there any documentation about btrfs mount flags wrt:
>> [...]
> 
> AFAIK the best documentation is the wiki, which you didn't mention, tho
> you mentioned google.  It's also possible that you found the old/outdated
> (because it's read-only after the kernel.org breakin some months ago) wiki
> on btrfs.wiki.kernel.org, but not the current (but possibly temporary)
> one linked below.
> 
> So the wiki is where I'd go first.  Questions you have after that, ask
> here, and preferably update the wiki with the answers you get, as well.
> 
> http://btrfs.ipv5.de/index.php?title=Main_Page

This looks good but I think there's room for improvement. Are there any 
mount options which apply to a subvolume only?

And while I see space_cache having the "permanent" annotation in its 
description, I see something similar missing for e.g. the inode_cache, ssd, 
etc. descriptions. Something that says "not permanent, must be given each 
time".

Anyone willing to eloberate on this? I'd offer to contribute this to the 
wiki.

Thanks,
Kai

