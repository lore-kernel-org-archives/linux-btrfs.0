From: Arun Bhanu <btrfs@arunbhanu.com>
Subject: Re: Problem with building btrfs into the kernel instead of module
Date: Thu, 9 Oct 2008 01:41:13 +0800
Message-ID: <20081008174113.GA6491@deepthought>
References: <20081007182230.GA19219@deepthought> <Pine.LNX.4.64.0810071243090.31477@cobra.newdream.net>
Reply-To: Arun Bhanu <btrfs@arunbhanu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810071243090.31477@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

* Sage Weil (sage@newdream.net) wrote:
> On Wed, 8 Oct 2008, Arun Bhanu wrote:
> > Hi
> > 
> > I have compiled btrfs into the kernel instead of building as module.
> > Then I create a btrfs filesystem on a partition and try to mount it and
> > I get the following error.
> 
> fs/btrfs/Makefile is a bit wonky.  This at least makes it work both ways:

Thanks. With your patch applied, it is working as expected in both
cases.

> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index 48b7909..7125716 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -1,7 +1,7 @@
>  ifneq ($(KERNELRELEASE),)
>  # kbuild part of makefile
>  
> -obj-m  := btrfs.o
> +obj-$(CONFIG_BTRFS_FS) := btrfs.o
>  btrfs-y := super.o ctree.o extent-tree.o print-tree.o root-tree.o 
> dir-item.o \
>            file-item.o inode-item.o inode-map.o disk-io.o \
>            transaction.o inode.o file.o tree-defrag.o \
> @@ -14,7 +14,7 @@ else
>  
>  KERNELDIR := /lib/modules/`uname -r`/build
>  all:
> -       $(MAKE) -C $(KERNELDIR) M=`pwd` modules
> +       $(MAKE) -C $(KERNELDIR) M=`pwd` CONFIG_BTRFS_FS=m modules
>  
>  modules_install:
>         $(MAKE) -C $(KERNELDIR) M=`pwd` modules_install
> 

-Arun
