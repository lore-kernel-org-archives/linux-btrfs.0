From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [Validation] How to properly use the subvolume and snapshot for
 a backup method
Date: Wed, 25 May 2011 19:34:18 +0200
Message-ID: <4DDD3D9A.8000104@libero.it>
References: <4DDC7C41.20908@videotron.ca>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Sylvain Alain <sylalain@videotron.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDC7C41.20908@videotron.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/25/2011 05:49 AM, Sylvain Alain wrote:
> Hi everyone, first of all, I want to say that I'm learning how to use
> BTRFS and I really enjoy all the subvolume and the snapshot features.
> 
> Also, I'm a backup freak :P
> 
> Basically, I have 4 questions :
> 
> 1. I would like to know what is the best way to install a Linux
> distribution inside a BTRFS partition ? I mean, do I install it directly
> inside the subvolid=0 or I create a subvolume for exemple @root to leave
> the subvolid=0 clean and without any data, of course only subvolume and
> then I install my distro inside the @root subvolume ? I'm asking that,
> because I saw that Ubuntu 11.04 use the subvolume @ and @home to install
> the distribution files so, the subvolid=0 is clean.
> I saw that because at boot time, the /boot/grub/grub.cfg use this param
> with Grub2 : rootflags=subvol=@

I do so

> 
> 2. I would like to know if this Live backup method is correct ?
> 
> +++++
> My /dev/sda2 contains a @root subvolume that contains my distribution,
> my /home directory is inside an another subvolume that is at the same
> level that @root.
> 
> # mkdir /mnt/disklayout
> # mount /dev/sda2 /mnt/disklayout -o subvolid=0
> 
> # cd /mnt/disklayout
> # btrfs subvolume snapshot @root snapshot-@racine-live
> # btrfs subvolume snapshot @home snapshot-@home-live
> 
> # mount /dev/sdb1 /mnt/backup -o subvol=@backup
> 
> # time rsync -aHA --del --force --stats --progress
> snapshot-@racine-live/ /mnt/backup/funtoo
> # time rsync -aHA --del --force --stats --progress snapshot-@home-live/
> /mnt/backup/funtoo/home
> # time rsync -aHA --del --force --stats --progress /boot/
> /mnt/backup/funtoo/boot
> 
> # cd /mnt/disklayout
> # btrfs subvolume delete snapshot-@root-live
> # btrfs subvolume delete snapshot-@home-live
> 
> # cd /
> # umount /mnt/disklayout
> 
> Creation of the snapshot :
> 
> # cd /
> # umount /mnt/backup
> # mount /dev/sdb1 /mnt/backup -o subvolid=0
> 
> # cd /mnt/backup
> # btrfs subvolume snapshot @backup @snap-20110502
> # btrfs subvolume list .
> 
> # cd /mnt/backup
> # ls -la
> # cd @snap-20110502
> # ls -la
> # cd /
> # umount /mnt/backup  

to me it seems correctly
> 
> ------
> 
> 3. Is there any objection to use a snapshot name or a subvolume that
> start with a @ ?
> 
> 4. Finally,I would like to know if we can rename subvolume ?

I did without trouble

> 
> The best example is this : I crash my box but I made earlier a snapshot
> that is named @snap-20110502 inside my subvolid=0. Now that my @root is
> brain dead, I would like to delete it and rename the @snap-20110502 to
> @root ?
> 
> Is this possible and if so, can I use the mv command or something else ?
> I'm sure that I will need to boot with a LiveCD to do so, but for the
> rest, is this possible ?

I tweaked a bit the grub script (under /etc/grub.d/);now when I run
"update-grub", the grub.cfg contains also some entries which permit do
boot in the snapshot subvolume. Basycally these entries  contains the
replace the parameter "rootflags=subvol=@" in
"rootflags=subvol=<subvolume name>". Is far to be optimal, but doing so
I don't need any LiveCD.

For example in a snapshot I am testing systemd ...

> 
> 
> Thanks you very much !!!
> 

