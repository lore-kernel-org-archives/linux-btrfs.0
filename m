From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 17:39:59 +0800
Message-ID: <4EFC356F.4060904@cn.fujitsu.com>
References: <201112281757.16019.Martin@lichtvoll.de> <CAG1y0scg0vA1jfrp7GX8m9Puh0HJWBNgABHiXqrOuUGgH6p8KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scg0vA1jfrp7GX8m9Puh0HJWBNgABHiXqrOuUGgH6p8KQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha wrote:
> On Wed, Dec 28, 2011 at 11:57 PM, Martin Steigerwald
> <Martin@lichtvoll.de> wrote:
>> But BTRFS does not:
>>
>> merkaba:~> fstrim -v /
>> /: 4431613952 bytes were trimmed
>> merkaba:~> fstrim -v /
>> /: 4341846016 bytes were trimmed
> 
> .... and apparently it can't trim everything. Or maybe my kernel is
> just too old.
> 
> 
> $ sudo fstrim -v /
> 2258165760 Bytes was trimmed
> 
> $ df -h /
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda6              50G   34G   12G  75% /
> 
> $ mount | grep "/ "
> /dev/sda6 on / type btrfs (rw,noatime,subvolid=258,compress-force=lzo)
> 
> so only about 2G out of 12G can be trimmed. This is on kernel 3.1.4.
> 

That's because only free spaces in block groups will be trimmed. Btrfs
allocates space from block groups, and when there's no space availabe,
it will allocate a new block group from the pool. In your case there's
~10G in the pool.

You can do a "btrfs fi df /", and you'll see the total size of existing
block groups.

You can empty the pool by:

	# dd if=/dev/zero of=/mytmpfile bs=1M

Then release the space (but it won't return back to the pool):

	# rm /mytmpfile
	# sync

and try "btrfs fi df /" and trim again.
