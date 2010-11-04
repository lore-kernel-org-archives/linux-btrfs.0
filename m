From: Goffredo Baroncelli <kreijack@libero.it>
Subject: RFC: exporting info via sysfs [was Re: [patch 0/2] Control filesystem balances (kernel side)]
Date: Thu, 4 Nov 2010 23:55:24 +0100
Message-ID: <201011042355.25214.kreijack@libero.it>
References: <20101030000726.286517546@carfax.org.uk> <201010301944.35962.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010301944.35962.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I make a prototype for exporting info from btrfs via sysfs.
Under /sys/btrfs were created two directories, named "fs" and "devices".


/sys/btrfs/fs/<fs-uuid>/
                         label		-> filesystem label
                         num_devices    -> total number of devices
                         open_devices   -> number of opened devices
                         [...]
/sys/btrfs/devices/<dev-uuid>/
                         devid          -> btrfs device number
                         fsid           -> filesystem uuid (fs-uuid)
                         major, minor   -> major minor
                         name           -> device name
                         writeable      -> is the device writeable

where <fs-uuid> is the filesystem uuid, and <dev-uuid> is the device uuid. The 
link between devices and filesystem is the <fsid> parameter of a device.

I create these structure because we should handle the case were the devices 
are present (like after a "btrfs device scan") but the filesystem aren't 
mounted.

In this case the devices/ subdirectory is populated. Instead the fs/ 
subdirectory is empty.

I don't attach a patch because the code is very ugly.
Comments ? Thoughts ?
        
Below an example of use.

$ /sbin/blkid img*
img0.img: UUID="099ea4b7-96dd-41fc-91df-0d1ab0066e05" 
UUID_SUB="1103c4e9-2dba-4b58-82ea-7c7c633fe04a" TYPE="btrfs" 
img1.img: UUID="099ea4b7-96dd-41fc-91df-0d1ab0066e05" 
UUID_SUB="d677e338-5eb0-4373-a540-78b9e7938987" TYPE="btrfs" 
img2.img: UUID="099ea4b7-96dd-41fc-91df-0d1ab0066e05" 
UUID_SUB="de5e3fbf-2400-438c-95b5-e4c876d96bed" TYPE="btrfs" 
img3.img: UUID="099ea4b7-96dd-41fc-91df-0d1ab0066e05" UUID_SUB="019b1657-
edad-488e-ad72-ccd2ea92e3ac" TYPE="btrfs"

$ (cd /sys/fs/btrfs/; for i in */*/*; do echo -e "$i:\t$(cat $i)"; done )          
devices/019b1657-edad-488e-ad72-ccd2ea92e3ac/devid:     4
devices/019b1657-edad-488e-ad72-ccd2ea92e3ac/fsid:      
099ea4b7-96dd-41fc-91df-0d1ab0066e05
devices/019b1657-edad-488e-ad72-ccd2ea92e3ac/major:     98
devices/019b1657-edad-488e-ad72-ccd2ea92e3ac/minor:     64
devices/019b1657-edad-488e-ad72-ccd2ea92e3ac/name:      /dev/ubde
devices/019b1657-edad-488e-ad72-ccd2ea92e3ac/writeable: 1
devices/1103c4e9-2dba-4b58-82ea-7c7c633fe04a/devid:     1
devices/1103c4e9-2dba-4b58-82ea-7c7c633fe04a/fsid:      
099ea4b7-96dd-41fc-91df-0d1ab0066e05
devices/1103c4e9-2dba-4b58-82ea-7c7c633fe04a/major:     98
devices/1103c4e9-2dba-4b58-82ea-7c7c633fe04a/minor:     16
devices/1103c4e9-2dba-4b58-82ea-7c7c633fe04a/name:      /dev/ubdb
devices/1103c4e9-2dba-4b58-82ea-7c7c633fe04a/writeable: 1
devices/d677e338-5eb0-4373-a540-78b9e7938987/devid:     2
devices/d677e338-5eb0-4373-a540-78b9e7938987/fsid:      
099ea4b7-96dd-41fc-91df-0d1ab0066e05
devices/d677e338-5eb0-4373-a540-78b9e7938987/major:     98
devices/d677e338-5eb0-4373-a540-78b9e7938987/minor:     32
devices/d677e338-5eb0-4373-a540-78b9e7938987/name:      /dev/ubdc
devices/d677e338-5eb0-4373-a540-78b9e7938987/writeable: 1
devices/de5e3fbf-2400-438c-95b5-e4c876d96bed/devid:     3
devices/de5e3fbf-2400-438c-95b5-e4c876d96bed/fsid:      
099ea4b7-96dd-41fc-91df-0d1ab0066e05
devices/de5e3fbf-2400-438c-95b5-e4c876d96bed/major:     98
devices/de5e3fbf-2400-438c-95b5-e4c876d96bed/minor:     48
devices/de5e3fbf-2400-438c-95b5-e4c876d96bed/name:      /dev/ubdd
devices/de5e3fbf-2400-438c-95b5-e4c876d96bed/writeable: 1
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/blocks_used:    32768
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/blocksize:      4096
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/label:
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/num_devices:    4
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/open_devices:   4
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/rw_devices:     4
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/total_blocks:   2222981120
fs/099ea4b7-96dd-41fc-91df-0d1ab0066e05/total_devices:  4



On Saturday, 30 October, 2010, you (Goffredo Baroncelli) wrote:
> On Saturday, 30 October, 2010, Hugo Mills wrote:
> >    These two patches give a degree of control over balance operations.
> > The first makes it possible to get an idea of how much work remains to
> > do, by tracking the number of block groups (chunks) that need to be
> > moved/rewritten. The second patch allows a running balance operation
> > to be cancelled when the current block group has been moved.
> > 
> >    One fundamental question, though -- is the progress monitor
> > function best implemented as an ioctl, as I've done here, or should it
> > be two or three sysfs files? I'm thinking of /proc/mdstat...
> > Obviously, /proc/mdstat would never get into /sys, but exposing the
> > "expected" and "remaining" values as files has an attractive
> > simplicity to it.
> 
> 
> I like the idea that these info should be put under sysfs. Something like
> 
> /sys/btrfs/<filesystem-uuid>/
>                              balance	-> info on balancing
>                              devices	-> list of device (a directory of
>                                            links or a file which contains 
>                                            the list of devices)
>                              subvolumes/ -> info on subvolume(s)
>                              label       -> label of the filesystem
>                              <other btrfs filesystem related knoba>
> 
>                                            
> 
> 
> Obviously we need another btrfs command to extract an uuid from a btrfs 
> filesystem like:
> 
> # btrfs filesystem get-uuid /path/to/a/btrfs/filesystem
> f9b9c413-0dc8-4e3f-94f2-86faa702f519
> 
> > 
> >    The user-space side of things are in a separate patch series, to
> > follow.
> > 
> >    Please be gentle with me, this is my first (serious, non-trivial)
> > kernel patch. :)
> > 
> >    Hugo.
> > 
> > 
> > -- 
> > === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
> >   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
> >    --- "No!  My collection of rare, incurable diseases! Violated!" ---   
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) 
<kreijack@inwind.it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> 
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
