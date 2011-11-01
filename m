From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: ENOSPC on almost empty FS
Date: Tue, 1 Nov 2011 09:01:05 -0500
Message-ID: <CAKcLGm9wTHWfcR9_2RtEdpQX2hx9JpvCvE0itWtotHNtSfwekA@mail.gmail.com>
References: <slrnjavbrs.81n.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnjavbrs.81n.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 1, 2011 at 3:36 AM, Stephane CHAZELAS
<stephane_chazelas@yahoo.fr> wrote:
> Hiya,
>
> trying to restore a FS from a backup (tgz) on a freshly made
> btrfs this morning, I got ENOSPCs after about 100MB out of 4GB
> have been extracted. strace indicates that the ENOSPC are upon
> the open(O_WRONLY).
>
> Restoring with:
>
> mkfs.btrfs /dev/mapper/VG_USB-root
> mount -o compress-force,ssd $_ /mnt
> cd /mnt
> pv ~/backup.tgz | gunzip | sudo bsdtar -xpSf - --numeric-owner
>
>
> That's on a LVM LV with the PV on a USB key.
>
> If I supspend the job and resume it, then the ENOSPCs go away.
>
> The only way I could restore the backup was via rate limiting
> the untar:
>
> zcat ~/backup.tgz | pv -L 3000000 | sudo bsdtar -xpSf - --numeric-owner
>
> That 3MB/s wasn't even enough, as 3 files triggered a ENOSPC,
> but I did untar them separately afterwards.
>
> That's with debian's 3.0.0-1 amd64 kernel.
>
> Is that expected behavior due to the way allocation works in
> btrfs?
>

I have also run into similar behavior while restoring a volume with tar.

I believe this is fixed by one of Josef's recent patches, but it might
be one of the patches queued for 3.2.
