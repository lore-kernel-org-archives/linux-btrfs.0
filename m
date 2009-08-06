From: Robert =?iso-8859-1?q?F=F6rster?= <Dessa@gmake.de>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 19:57:12 +0200
Message-ID: <200908061957.13190.Dessa@gmake.de>
References: <200908061657.50989.Dessa@gmake.de> <20090806152058.GF3655@dhcp231-156.rdu.redhat.com> <4A7B0FB7.2010401@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Tore Anderson <tore.anderson@redpill-linpro.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7B0FB7.2010401@redpill-linpro.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 6. August 2009 19:15:35 schrieb Tore Anderson:
> * Josef Bacik
>
> > Alrighty, so btrfs-show says you have used up all of your disk, but
> > for some reason statfs is saying you havent.  Can you cd into / and
> > run
> >
> > du -h -s
> >
> > and then wait a very long time and then tell me what it comes back
> > with :). That will tell us for sure what the hell is going on.  Thank
> > you,
>
> I think this needs to be "du -h -s -x" (otherwise you'll include space
> used by files on other file systems as well).
>
> Best regards,
oops, yea, should probaly had a closer look at its actual output, then i would 
have noticed that.
reposting the rest too since i did a temporary file cleanup in the meantime if 
that even matters, and if i missed anything else:

Beatrix / # du -h -s -x
3,9G    .

Beatrix / # df -h
Filesystem            Size  Used Avail Use% Mounted on
rootfs                 52G  4,3G   47G   9% /
/dev/root              52G  4,3G   47G   9% /
rc-svcdir             1,0M   68K  956K   7% /lib64/rc/init.d
udev                   10M  300K  9,8M   3% /dev
shm                  1004M  5,6M  999M   1% /dev/shm
/dev/sda1             129G   36G   93G  28% /home

Beatrix / # btrfs-show
failed to read /dev/sdc
failed to read /dev/hdb
Label: none  uuid: 0f47144c-4fef-4291-a320-7859a0e7c359
        Total devices 1 FS bytes used 35.46GB
        devid    1 size 128.23GB used 90.04GB path /dev/sda1

Label: none  uuid: 7f4f3bcb-7ba1-49c5-8996-e897b5483c7c
        Total devices 1 FS bytes used 4.23GB
        devid    1 size 51.22GB used 51.22GB path /dev/sdb1

Btrfs Btrfs v0.19
