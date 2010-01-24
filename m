From: Ronald Kasl <rkasl@freeshell.org>
Subject: "*** Some devices missing ***"  & "Unable to stat /dev/sdg"  error
 messages
Date: Sun, 24 Jan 2010 06:53:54 -0500
Message-ID: <4B5C34D2.5060701@freeshell.org>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com> <201001240902.38535.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001240902.38535.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, .. what do I do when I get " *** Some devices missing " and " "Unable to stat /dev/sdg" , error message after drive is hotswaped or die ?

this is what I did?
1. mkfs.btrfs -m raid1 -d raid10 -L btrfs_label_01  /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sdf /dev/sdg
2. mount -t btrfs -o compress /dev/sda /mnt/btrfs
3. figgle around testing  the system , then I tremoved one of the disk (/dev/sdg) to see what happen,  which  is when I get the "device missing"  message in the btrfs-show that is understandable, but I cannot bring the disk back after it's "live" again .... the FS worked just fine without the disk, I just don't know how to bring it back to the btrfs pool of disks 

# btrfs-show
failed to read /dev/sdg1
failed to read /dev/sdg
failed to read /dev/sr0
Label: btrfs_label_01  uuid: 0135dae3-61d8-430e-80ba-3e254d404371
    Total devices 6 FS bytes used 28.00KB
    devid    1 size 931.51GB used 1.02GB path /dev/sda
    devid    2 size 931.51GB used 1.00GB path /dev/sdb
    devid    3 size 931.51GB used 2.00GB path /dev/sdc
    devid    4 size 931.51GB used 2.00GB path /dev/sdd
    devid    5 size 931.48GB used 1.01GB path /dev/sdf

    *** Some devices missing

4. I tried what is on the wiki under "replacing failed devices, but I
was getting nowhere since I'm getting "Unable to stat /dev/sdg" error
message when I'm trying to remove the failed device.

this is what I did
umount /mnt/btrfs 
mount -o degraded /dev/sda /mnt/btrfs
btrfs-vol -r /dev/sdg /mnt/btrfs
.. then I get the  "Unable to stat /dev/sdg"  message

5. I hotswap the disk back to its bay, but the drive still did not show up .. it just keept "missing" until I reboot the system, then I could mount it ... yet after the reboot I had those "
mount: wrong fs type, bad option, bad superblock on /dev/sda ..." error messages untill I did something and then it work (I guess I had to run the btrfsctl -a command that showed all the disk present)

any idea what to do to bring hotswaped drive back to to system?  thanks!!

btw. do I need to create a partition with fdisk to use the disks with btrfs -- first I just used the new disk without creating partition on them, but then I read some howto and there was stated that one needs to create a partition first --- I tried that and I had the same problem described above and it seems that btrfs doesn't care

thanks!!!



http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

Goffredo Baroncelli wrote:
> On Sunday 24 January 2010, 0bo0 wrote:
>   
>> after a simple reboot,
>>     
>                  ^^^^^^
> Have you do
>
>   # btrfsctl -a
>
> before mounting the filesystem ? This command scans all the block devices 
> searching the btrfs volume. So when you mount a device of an array the system 
> is able to retrieves the others.
>
> [..]
>
>   

