From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Thu, 19 Jun 2008 22:23:17 -0700
Message-ID: <485B3EC5.8090006@oracle.com>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>


> +#define BTRFS_IOC_NODATACOW _IO(BTRFS_IOCTL_MAGIC, 13)
> +#define BTRFS_IOC_DATACOW _IO(BTRFS_IOCTL_MAGIC, 14)
> +#define BTRFS_IOC_NODATASUM _IO(BTRFS_IOCTL_MAGIC, 15)
> +#define BTRFS_IOC_DATASUM _IO(BTRFS_IOCTL_MAGIC, 16)

Hmm.  Do we really want 4 different ioctl commands to turn 2 features on
and off?  Surely we could have 1 ioctl which updates a bitfield?  Or a
ioctl that takes an explicit feature enum argument and a boolean which
indicates that it should be enabled or not?

(And is ioctl the right interface for this?  maybe it should be xattr
ops in some defined btrfs string namespace?  I'm just making this up.  I
feel the the lack of a single comment in the patch, while in keeping
with the existing precedent in btrfs, leaves a lot of room for wild
speculation :))

- z
