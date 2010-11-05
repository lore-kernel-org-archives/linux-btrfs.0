From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: Re: RFC: exporting info via sysfs [was Re: [patch 0/2] Control
 filesystem balances (kernel side)]
Date: Fri, 5 Nov 2010 16:28:28 +0100 (CET)
Message-ID: <18113058.806241288970908229.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



>----Messaggio originale----
>Da: hugo-lkml@carfax.org.uk
>Data: 05/11/2010 13.41
>A: "Goffredo Baroncelli"<kreijack@libero.it>
>Cc: <linux-btrfs@vger.kernel.org>, "Hugo Mills"<hugo-lkml@carfax.org.uk>
>Ogg: Re: RFC: exporting info via sysfs [was Re: [patch 0/2] Control 
filesystem balances (kernel side)]
>
>   Hi, Goffredo,
>
>On Thu, Nov 04, 2010 at 11:55:24PM +0100, Goffredo Baroncelli wrote:
>> I make a prototype for exporting info from btrfs via sysfs.
>
>   Good stuff. I was going to take a look at doing that this
>weekend. :)
>
>> Under /sys/btrfs were created two directories, named "fs" and "devices".
>>
>> /sys/btrfs/fs/<fs-uuid>/
>
>   I'm pretty sure that /sys/btrfs won't get through any discussion on
>LKML. I'd suggest /sys/fs/btrfs as the base, since that's where the
>other filesystems seem to put their sysfs information.

Not enough cofee... The right path is /sys/fs/btrfs (see examples in my 
email)

>
>>                          label		-> filesystem label
>>                          num_devices    -> total number of devices
>>                          open_devices   -> number of opened devices
>>                          [...]
>> /sys/btrfs/devices/<dev-uuid>/
>>                          devid          -> btrfs device number
>>                          fsid           -> filesystem uuid (fs-uuid)
>>                          major, minor   -> major minor
>
>   I think the major, minor should instead be be a symlink to the
>relevant entry in /sys/devices/...  (as done in /sys/block/*) or
>/sys/block (as done in /sys/block/md*/slaves). Call it "device".
>
>>                          name           -> device name
>
>   Unnecessary -- and also, I think, unlikely to get through LKML
>review. Putting a device name here implies that the kernel knows
>better than userspace what the name of the device is (i.e. which
>device node you should be using). Having the link to /sys/block/* or
>/sys/devices/... as above is, I think, all that's needed here.

Apparently btrfs opens the device only when the filesystem is mounted. 
So before mounting a filesystem only the device file path exists. After the 
mounting major/minor have meaning values.

>Userspace should be able to convert the major/minor pair kept in
>/sys/fs/btrfs/devices/<uuid>/device/dev appropriately.
>
>>                          writeable      -> is the device writeable
>
>> where <fs-uuid> is the filesystem uuid, and <dev-uuid> is the device uuid. 
The 
>> link between devices and filesystem is the <fsid> parameter of a device.
>
>   Could that be made a symlink instead? That seems to be the usual
>approach in sysfs.
>
>> I create these structure because we should handle the case were the 
devices 
>> are present (like after a "btrfs device scan") but the filesystem aren't 
>> mounted.
>
>   ... ah, I see it can't. (Re: my previous comment)
>
>> In this case the devices/ subdirectory is populated. Instead the fs/ 
>> subdirectory is empty.
>> 
>> I don't attach a patch because the code is very ugly.
>> Comments ? Thoughts ?
>
>   Is it ugly because there are significant difficulties in making
>btrfs or sysfs do this, or just because you hacked something together
>as quickly as possible for a demo?

Both. Sysfs is not difficult to manage but there is a lot of redundant codes.
Fortunately few #defines help a lot. In any case I have a lot of doubts about 
the 
locking...

For this week I will try to sent the patches

>
>   Hugo.
>
>-- 
>=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- "There's a Martian war machine outside -- they want to talk ---   
>                to you about a cure for the common cold."                
>


