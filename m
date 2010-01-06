From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: snapshot/subvolume removal
Date: Wed, 06 Jan 2010 09:30:35 +0900
Message-ID: <4B43D9AB.1090606@jp.fujitsu.com>
References: <4B43AC9B.5030109@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: piavka@cs.bgu.ac.il
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B43AC9B.5030109@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We can delete snapshot with btrfsctl -D . It's available for
your btrfs-progs version.

And parameters of btrfsctl -s/S are not coherent at the last
argument.
In creating snapshots, the last argument implies the directory
where subvolume is to be created, but in taking snapshots,
the last argument implies subvolume we take snapshot of, and
snapshots are created under current directory.

So,
> shell>  btrfsctl  -s rsync-snap rsync
> operation complete

snapshot rsync-snap is created under current directory, and,

> Btrfs v0.19-4-gab8fb4c-dirty
> shell>  btrfsctl  -S rsync-snap rsync
> operation complete

subvolume rsync-snap is created under rsync directory in current
directory. They are created under different directories.

Regards,
taruisi

(2010/01/06 6:18), Piavlo wrote:
>  Hi,
> 
> Does btrfs support snapshot or/and subvolume removal ?
> If yes how, since I could not find the commands to do that?
> If not is there any estimation when this feature will be available?
> 
> Is there a tool to list the existing subvolumes/snapshots?
> 
> It looks like the snapshots can overridden by subvolumes, see below:
> 
> shell>  btrfsctl  -s rsync-snap rsync
> operation complete
> Btrfs v0.19-4-gab8fb4c-dirty
> shell>  btrfsctl  -S rsync-snap rsync
> operation complete
> Btrfs v0.19-4-gab8fb4c-dirty
> shell> btrfsctl  -s rsync-snap rsync
> ioctl:: File exists
> shell>
> 
> Is that expected?
> What happens to the snapshot  then it is overridden by subvolume?
> It does not seem reasonable that snapshot can be converted into 
> subvolume, since newly created subvolume
> holds no data ,while the snapshot is a snapshot of other previously
> existing subvolume and holds data.
> So is snapshots simply destroyed prior to subvolume creation, in the
> above scenario?
> 
>  Thanks
>  Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

