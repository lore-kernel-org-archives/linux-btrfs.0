From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 20:39:12 +0200
Message-ID: <20120401183912.61760@gmx.net>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com>
 <20120401164136.61800@gmx.net> <4F788619.1040403@gmail.com>
 <20120401170754.238550@gmx.net> <4F788EE2.4010105@univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: "Klaus A. Kreil" <klaus.kreil@univie.ac.at>, k.skarlatos@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F788EE2.4010105@univie.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

> On: Sun, 01 Apr 2012 19:22:42 +0200"Klaus A. Kreil" wrote

> I am just an interested reader on the btrfs list and so far have never 
> posted or sent a message to the list, but I do have a dedup bash script 
> that searches for duplicates underneath a directory (provided as an 
> argument) and hard links identical files.
> 
> It works very well for an ext3 filesystem, but I guess the basics should 
> be the same for a btrfs filesystem.

Everyone feel free to correct me here, but:
At the moment there is a little problem with the maximum number of hard links in a directory. So I wouldn't use them wherever possible to avoid any thinkable problems in the near future.

Plus to hard link 2 files means, that change one file You change the other one. It's something You either don't want to happen or something, which could be done in better ways. The cp --reflink method on a COW-fs is a much smarter method.

Plus hard links across subvolumes do match the case of hard links across devices on a traditional fs, which is forbidden.

Plus hard links In my opinion should really be substituted by soft links, because hard links are not transparent at the first sight and can not be copied as it.

So no, I'd rather want the patch to allow cross-subvolume cp --reflink in the kernel and I will wait for that to happen.

Greetings
   Norbert
