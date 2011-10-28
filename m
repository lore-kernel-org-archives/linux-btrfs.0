From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs fi defrag -c
Date: Fri, 28 Oct 2011 10:25:54 +0800
Message-ID: <4EAA12B2.8070007@cn.fujitsu.com>
References: <20111027192022.GD4389@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027192022.GD4389@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Stephane Chazelas wrote:
> I don't quite understand the behavior of "btrfs fi defrag"
> 
> ~# truncate -s2G ~/a
> ~# mkfs.btrfs ~/a
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
> ~# mount -o loop ~/a /mnt/1
> /mnt/1# cd x
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G   64K  1.8G   1% /mnt/1
> /mnt/1# yes | head -c400M > a
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G   64K  1.8G   1% /mnt/1
> /mnt/1# sync
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G  402M  1.4G  23% /mnt/1
> /mnt/1# btrfs fi defrag -c a
> 
> (exit status == 20 BTW).
> 

int do_defrag(int ac, char **av)
{
	...
        return errors + 20;
}

This doesn't make sense to me.

> (20)/mnt/1# sync
> /mnt/1# df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop1      2.0G  415M  994M  30% /mnt/1
> 
> No space gain, even lost 15M or 400M depending on how you look at it.
> 

Here's mine:

# df . -h
Filesystem            Size  Used Avail Use% Mounted on
/home/lizf/tmp/a      2.0G  409M  1.4G  23% /mnt

And I was not suprised, as there's a regression.

With this fix:

http://marc.info/?l=linux-btrfs&m=131495014823121&w=2

# df . -h
Filesystem            Size  Used Avail Use% Mounted on
/home/lizf/tmp/a      2.0G   14M  1.8G   1% /mnt
