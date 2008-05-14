From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: Online device removal pushed to the unstable tree
Date: Wed, 14 May 2008 15:41:53 +0100
Message-ID: <f058a9c30805140741o7d4c4e67l243f981d1b750cca@mail.gmail.com>
References: <200805131608.36386.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805131608.36386.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

On Tue, May 13, 2008 at 9:08 PM, Chris Mason <chris.mason@oracle.com> wrote:
> Hello everyone,
>
>  The unstable tree is still format compatible with v0.14, and it now includes
>  the ability to remove devices online.  In mirror configurations, IO errors to
>  one of the mirrors are also handled, although it doesn't currently kick off a
>  rebuild or other magic.
>
>  To try things out:
>
>  mkfs.btrfs -d raid1 -m raid1 /dev/sdb /dev/sdc
>  mount /dev/sdb /mnt
>  # put data on /mnt
>  # then add /dev/sdd to the FS
>  btrfs-vol -a /dev/sdd /mnt
>
>  At this point we've got a raid1 filesystem with data spread across sdb and
>  sdc.  If we remove /dev/sdc, all the existing data will be remirrored onto
>  sdd:
>

Is there a way to check the progress of the remirror/rebuild ?
(somewhat similar to what /proc/mdstat provides when a mirror is being synced)



-- 
Miguel Sousa Filipe
