From: Phillip Michael <oopsicrappe@gmail.com>
Subject: Re: Btrfs Partition Reaches 'Disk Full' Early
Date: Thu, 4 Feb 2010 07:58:54 -0800
Message-ID: <45e1b66a1002040758x6093f05dx3bb355c600ebc22c@mail.gmail.com>
References: <26a1f7961002031843t665677aeh53e5b7cc6aaab6a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <26a1f7961002031843t665677aeh53e5b7cc6aaab6a6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 3, 2010 at 6:43 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> Josef Bacik's 'btrfsctl -i' command reported:
> # btrfsctl -i /mnt/sabayon-btrfs/
> Metadata, DUP: total=1.67GB, used=813.89MB
> System, DUP: total=8.00MB, used=4.00KB
> Data: total=10.00GB, used=10.00GB
> Metadata: total=8.00MB, used=0.00
> System: total=4.00MB, used=0.00
> operation complete
> Btrfs Btrfs v0.19

Is it possible the 1.67GB reserved for metadata reported by btrfsctl
-i is only for one copy of the metadata? That would mean the actual
amount would be double that.
