From: David Sterba <dave@jikos.cz>
Subject: Re: Problems with nodatacow/nodatasum
Date: Fri, 20 Apr 2012 11:12:50 +0200
Message-ID: <20120420091250.GK20982@twin.jikos.cz>
References: <CAEbWaipj_MzfM2wF6CpQg5dNCmLNLVomReDmnBVZHv9R3Be-cw@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Avi Kivity <avi.kivity@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWaipj_MzfM2wF6CpQg5dNCmLNLVomReDmnBVZHv9R3Be-cw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 11:19:39AM +0300, Avi Kivity wrote:
>   /dev/mapper/luks-blah /                       btrfs
> subvol=/rootvol        1 1
>   /dev/mapper/luks-blah /var/lib/libvirt/images     btrfs
> nodatasum,nodatacow,subvol=/images.libvirt        1 2

what does /proc/mounts say about the applied options? do you see
nodatasum and nodatacow there? afaik most (if not all) mount options
affect the whole filesystem including any subvolume mounts.  having
per-subvol options is possible, just not implemented.

david
