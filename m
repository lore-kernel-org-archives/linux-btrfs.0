From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfs defragment: ioctl failed, ret -1 errno 28
Date: Tue, 18 Oct 2011 07:26:42 -0500
Message-ID: <CAKcLGm9qtXML1oESSmDveW0=xc5N1DyHFkwa-yOVF0zojVgWZw@mail.gmail.com>
References: <4E9D59DA.4000403@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <tch@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9D59DA.4000403@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2011 at 5:50 AM, Tomasz Chmielewski <tch@wpkg.org> wrote:
> I'm trying to defragment a 280 GB file when running 3.1.0-rc9 kernel:
>
> # filefrag /mnt/btrfs/images/srv1-backup.qcow2
> /mnt/btrfs/images/srv1-backup.qcow2: 1139699 extents found
>
>
> # btrfs filesystem defragment /mnt/btrfs/images/srv1-backup.qcow2
> ioctl failed on /mnt/btrfs/images/srv1-backup.qcow2 ret -1 errno 28
> total 1 failures
>
>
> Some files fail to defragment like this; some are defragmented correctly.
>
> Why does it fail?
>

Error 28 is ENOSPC (error, no space).

Since btrfs will be trying to COW the file, it is looking for at least
280 GB of free space.  Also, I've run into situations where btrfs
seemed to need way more free space to complete an operation than
appeared necessary on the surface.

The btrfs defragment command has some capabilities to defragment just
segments of a file at a time.  But you may want to test that
capability on some less important files first.
