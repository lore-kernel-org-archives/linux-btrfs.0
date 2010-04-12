From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Can't mount removable device if device name changes.
Date: Mon, 12 Apr 2010 09:02:43 +0900
Message-ID: <4BC26323.3010303@jp.fujitsu.com>
References: <l2k4853c6511004101849r8c34baebq39774a47bf3c8f19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: cwillu@cwillu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <l2k4853c6511004101849r8c34baebq39774a47bf3c8f19@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

 What is your kernel version?
 Btrfs hols device names which construct filesystems and
updating device name(device renaming) is merged just in
last month.

Regards,
taruisi

(2010/04/11 10:49), cwillu wrote:
> I've got a btrfs on an sd card, which I'm using as the root fs on a
> beagle.  That's not the problem :)
> 
> The machine I generate my images on has an internal sd reader, and I
> also have a usb card reader.  After creating the fs on the internal
> reader, I ended up plugging it in on the external reader.
> 
> internal: sdd
> external: sdh
> 
> mount /dev/sdh2 /mnt -t btrfs
>> mount: /dev/sdh2: can't read superblock
> [15035.538462] device fsid 48fadf7ed76537-bb9c7266ecb8b2 devid transid
> 8986 /dev/sdh2
> [15035.538462] open /dev/sdd2 failed
> 
> If I plug it back into the internal reader, it mounts fine on /dev/sdd2.
> 
> An strace of btrfsctl -a shows it reading /dev/sdh2, and there's no
> mention of /dev/sdd:
>> open("/dev/sdh2", O_RDONLY)             = 4
>> pread(4, "\2067kF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2859, 65536) = 2859
> 
> The fs mounts fine on the external reader on a different machine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
taruisi

