From: Alan Chandler <alan@chandlerfamily.org.uk>
Subject: Re: Synching a Backup Server
Date: Sun, 09 Jan 2011 11:46:59 +0000
Message-ID: <4D29A033.7000803@chandlerfamily.org.uk>
References: <201101060935.14059.CACook@quantum-sci.com> <201101061342.23991.CACook@quantum-sci.com> <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com> <201101071720.08298.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101071720.08298.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/11 16:20, Hubert Kario wrote:
>
> I usually create subvolumes in btrfs root volume:
>
> /mnt/btrfs/
>          |- server-a
>          |- server-b
>          \- server-c
>
> then create snapshots of these directories:
>
> /mnt/btrfs/
>          |- server-a
>          |- server-b
>          |- server-c
>          |- snapshots-server-a
>                   |- @GMT-2010.12.21-16.48.09
> 	            \- @GMT-2010.12.22-16.45.14
>          |- snapshots-server-b
>          \- snapshots-server-c
>
> This way I can use the shadow_copy module for samba to publish the snapshots
> to windows clients.
>    


Can you post some actual commands to do this part

I am extremely confused about btrfs subvolumes v the root filesystem and 
mounting, particularly in relation to the default subvolume.

For instance, if I create the initial file system using mkfs.btrfs and 
then mount it on /mnt/btrfs is there already a default subvolume?  or do 
I have to make one?  What happens when you unmount the whole filesystem 
and then come back

The wiki also makes the following statement

*"Note:* to be mounted the subvolume or snapshot have to be in the root 
of the btrfs filesystem."


but you seems to have snapshots at one layer down from the root.


I am trying to use this method for my offsite backups - to a large spare 
sata disk loaded via a usb port.

I want to create the main filesystem (and possibly a subvolume - this is 
where I start to get confused) and rsync my current daily backup files 
to it.  I would then also (just so I get the correct time - rather than 
do it at the next cycle, as explained below) take a snapshot with a time 
label. I would transport this disk offsite.

I would repeat this in a months time with a totally different disk

In a couple of months time - when I come to recycle the first disk for 
my offsite backup, I would mount the retrieved disk (and again I am 
confused - mount the complete filesystem or the subvolume?)  rsync 
(--inplace ? - is this necessary) again the various backup files from my 
server and take another snapshot.

I am hoping that this would effectively allow me to leave the snapshot I 
took last time in place, as because not everything will have changed it 
won't have used much space - so effectively I can keep quite a long 
stream of backup snapshots in place offsite.

Eventually of course the disk will start to become full, but I assume I 
can reclaim the space by deleting some of the old snapshots.

-- 
Alan Chandler
http://www.chandlerfamily.org.uk

