From: "Nikos Voutsinas" <nvoutsin@noc.edunet.gr>
Subject: Re: BTRFS thinks that a device is mounted
Date: Sat, 22 Oct 2011 16:57:55 +0300
Message-ID: <e0ac043e6f443df448791e3fcd6cdf0a.squirrel@webmail01.edunet.gr>
References: <a46ac41f14ba1581cb554a0f26463859.squirrel@webmail01.edunet.gr>
    <slrnja2h84.5ku.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnja2h84.5ku.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

> 2011-10-21, 00:39(+03), Nikos Voutsinas:
> [...]
>> ## Comment: Of course /dev/sdh is not mounted.
>> mount |grep /dev/sdh
>> root@lxc:~#
> [...]
>
> Note that mount(8) uses /etc/mtab to find out what is mounted.
> And if that file is not a symlink to /proc/mounts, the
> information is not necessarily correct.
>
> You can also have a look at /proc/mounts directly.
>

OK, I found what went wrong, however I am not sure whose fault this is and
If I am going to describe a case that is already known to this list.

To cut a long story short, the consecutive

root@btrfs:~# btrfs device add /dev/sdc /
root@btrfs:~# btrfs device delete /dev/sdc /

led to inconsistency between the contents of /proc/mounts and
/dev/disk/by-uuid (ie the mapping of UUIDs to devices).

Actually, "btrfs device add /dev/sdc /" changed the mapping of root's UUID
to point to /dev/sdc, and the system left it this way, even after the
"btrfs device delete /dev/sdc /". Thus I ended up with the following
situation.

root@btrfs:~# cat  /etc/mtab /proc/mounts |grep btrfs
/dev/sdd2 / btrfs rw 0 0
/dev/disk/by-uuid/cc8211ba-6f62-46d6-ba17-49250f06a941 / btrfs rw 0 0
root@btrfs:~#
root@btrfs:~# ls -l /dev/disk/by-uuid/cc8211ba-6f62-46d6-ba17-49250f06a941
lrwxrwxrwx 1 root root 9 Oct 22 16:13
/dev/disk/by-uuid/cc8211ba-6f62-46d6-ba17-49250f06a941 -> ../../sdc

Although this may be a udev issue, I think that the userspace tools of
btrfs should have handled this in a better way.

Nikos


