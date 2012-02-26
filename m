From: Fahrzin Hemmati <fahhem2@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 21:50:49 -0800
Message-ID: <4F49C839.7030508@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <jicgtv$bg2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jicgtv$bg2$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2/25/2012 9:45 PM, Brian J. Murrell wrote:
> On 12-02-25 09:10 PM, Fahrzin Hemmati wrote:
>> btrfs is horrible for small filesystems (like a 5GB drive). df -h says
>> you have 967MB available, but btrfs (at least by default) allocates 1GB
>> at a time to data/metadata. This means that your 10MB file is too big
>> for the current allocation and requires a new data chunk, or another
>> 1GB, which you don't have.
> So increasing the size of the filesystem should suffice then?  How much
> bigger?  10G?  Nope.  still not big enough:
>
> # lvextend -L+1G /dev/rootvol/mint_usr; btrfs fi resize max /usr; df -h /usr
>    Extending logical volume mint_usr to 10.00 GiB
>    Logical volume mint_usr successfully resized
> Resize '/usr' of 'max'
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/rootvol-mint_usr
>                         10G  2.8G  6.0G  32% /usr
> test ~ # apt-get install -y -f
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> Correcting dependencies... Done
> The following extra packages will be installed:
>    linux-headers-3.0.0-16-generic
> The following NEW packages will be installed:
>    linux-headers-3.0.0-16-generic
> 0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
> 264 not fully installed or removed.
> Need to get 0 B/851 kB of archives.
> After this operation, 10.8 MB of additional disk space will be used.
> (Reading database ... 180246 files and directories currently installed.)
> Unpacking linux-headers-3.0.0-16-generic (from .../linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb) ...
> dpkg: error processing /var/cache/apt/archives/linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb (--unpack):
>   unable to install new version of `/usr/src/linux-headers-3.0.0-16-generic/include/config/dvb/usb.h': No space left on device
>
> 20G maybe?  Nope:
>
> # lvextend -L20G /dev/rootvol/mint_usr; btrfs fi resize max /usr; df -h /usr
>    Extending logical volume mint_usr to 20.00 GiB
>    Logical volume mint_usr successfully resized
> Resize '/usr' of 'max'
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/rootvol-mint_usr
>                         20G  2.8G   16G  15% /usr
> test ~ # apt-get install -y -f
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> Correcting dependencies... Done
> The following extra packages will be installed:
>    linux-headers-3.0.0-16-generic
> The following NEW packages will be installed:
>    linux-headers-3.0.0-16-generic
> 0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
> 264 not fully installed or removed.
> Need to get 0 B/851 kB of archives.
> After this operation, 10.8 MB of additional disk space will be used.
> (Reading database ... 180246 files and directories currently installed.)
> Unpacking linux-headers-3.0.0-16-generic (from .../linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb) ...
> dpkg: error processing /var/cache/apt/archives/linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb (--unpack):
>   unable to install new version of `/usr/src/linux-headers-3.0.0-16-generic/include/config/ncpfs/packet/signing.h': No space left on device
>
> Maybe 50G?  Yup:
>
> # apt-get install -y -f
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> Correcting dependencies... Done
> The following extra packages will be installed:
>    linux-headers-3.0.0-16-generic
> The following NEW packages will be installed:
>    linux-headers-3.0.0-16-generic
> 0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
> 264 not fully installed or removed.
> Need to get 0 B/851 kB of archives.
> After this operation, 10.8 MB of additional disk space will be used.
> (Reading database ... 180246 files and directories currently installed.)
> Unpacking linux-headers-3.0.0-16-generic (from .../linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb) ...
> Setting up linux-image-3.0.0-16-generic (3.0.0-16.28) ...
> ...
> # df -h /usr
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/rootvol-mint_usr
>                         50G  2.8G   43G   7% /usr
>
> So I guess I need a 50G btrfs filesystem for 2.8G worth of data?
>
> Does that really seem right?  I suppose to be fair it could have been
> some other value between 20G and 50G since I didn't test values in
> between.  So still, I need some amount more than 20G of space to store
> 2.8G of data?
>
> Surely there is something going on here other than just btrfs sucks for
> small filesystems.
>
> b.
>
>
>
>
You should have been fine with adding 1GB (really only 57MB), or at 
worst 2GB in case you were on the edge of both data and metadata.

A btrfs dev might be able to debug the problem there, since your 
original problem seemed only that you couldn't allocate a new chunk. It 
might be a problem with btrfs filesystem resize?
