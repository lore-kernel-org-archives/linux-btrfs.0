From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: reserving an IOCTL number; other details
Date: Mon, 13 Sep 2010 22:22:09 +0200
Message-ID: <201009132222.10227.kreijack@libero.it>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com> <201009131923.53227.kreijack@libero.it> <AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 13 September, 2010, David Nicol wrote:
> https://btrfs.wiki.kernel.org/index.php/Category:Documentation does
> not mention any btrfs command. the btrfsctl command has the -c sync
> tool, and the tools for creating and deleting snapshots and
> subvolumes, so it seems that unless this btrfs program does all of
> that I have amended the right tool to provide a command line access to
> a new ioctl that waits for deleted subvolume cleanups to finish.

$ /sbin/btrfs help
Usage:
        btrfs subvolume snapshot <source> [<dest>/]<name>
                Create a writable snapshot of the subvolume <source> with
                the name <name> in the <dest> directory.
        btrfs subvolume delete <subvolume>
                Delete the subvolume <subvolume>.
        btrfs subvolume create [<dest>/]<name>
                Create a subvolume in <dest> (or the current directory if
                not passed).
        btrfs subvolume list <path>
                List the snapshot/subvolume of a filesystem.
        btrfs subvolume find-new <path> <last_gen>
                List the recently modified files in a filesystem.
        btrfs filesystem defragment [-vcf] [-s start] [-l len] [-t size] 
<file>|<dir> [<file>|<dir>...]
                Defragment a file or a directory.
        btrfs subvolume set-default <id> <path>
                Set the subvolume of the filesystem <path> which will be 
mounted
                as default.
        btrfs filesystem sync <path>
                Force a sync on the filesystem <path>.
        btrfs filesystem resize [+/-]<newsize>[gkm]|max <filesystem>
                Resize the file system. If 'max' is passed, the filesystem
                will occupe all available space on the device.
        btrfs filesystem show [<uuid>|<label>]
                Show the info of a btrfs filesystem. If no <uuid> or <label>
                is passed, info of all the btrfs filesystem are shown.
        btrfs filesystem df <path>
                Show space usage information for a mount point
                .
        btrfs filesystem balance <path>
                Balance the chunks across the device.
        btrfs device scan [<device> [<device>..]
                Scan all device for or the passed device for a btrfs
                filesystem.
        btrfs device add <dev> [<dev>..] <path>
                Add a device to a filesystem.
        btrfs device delete <dev> [<dev>..] <path>
                Remove a device from a filesystem.
                                                                                                 
        btrfs help|--help|-h                                                                     
                Show the help.                                                                   
                                                                                                 
Btrfs Btrfs v0.19                                            


> 
> Nothing on https://btrfs.wiki.kernel.org/index.php/Btrfsctl says
> anything about deprecation or obsolescence.
> 
> On Mon, Sep 13, 2010 at 12:23 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
> > Hi David,
> >
> > please don't do that. "btrfsctl" is obsolete, now the develop should 
involve
> > the "btrfs" command.
> > I you need help in updating the "btrfs" command source files, don't 
hesitate
> > to contact me.
> >
> > Regards
> > G.Baroncelli
> 
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
