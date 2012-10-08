Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51931 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2JHLiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 07:38:50 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2665387eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 04:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50726DE1.20101@petaramesh.org>
References: <50714AC8.4010100@petaramesh.org>
	<loom.20121007T141248-114@post.gmane.org>
	<50718151.8090506@petaramesh.org>
	<201210071644.19815.Martin@lichtvoll.de>
	<5072066B.4020604@gmail.com>
	<50726DE1.20101@petaramesh.org>
Date: Mon, 8 Oct 2012 13:38:49 +0200
Message-ID: <CAJHuE_CjXaSmWRagSLxOCQpnEkpc1_S_sxSm0pVbXLiGocVA9w@mail.gmail.com>
Subject: Re: BTRFS, getting darn slower everyday
From: Goffredo Baroncelli <kreijack@gmail.com>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 8, 2012 at 8:08 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Le 08/10/2012 00:47, Goffredo Baroncelli a écrit :
>> Please could you clarify if you are using the "autodefrag" options
>> when you have the performance problem ?
>
> I use autodefrag on all volumes systematically, except on volumes that I
> use for really big files that would always be defragmenting (i.e.
> virtual machines, but I seldom use virtual machines, and my performance
> problem is general, I don't take VMs into consideration in this respect...)

The autodefrag option is per filesystem not per subvolume. The settings
of the first subvolueme is used also for the other ones.

So, because you mount the same filesystem both on

> /dev/VG1/BTR_POOL    /    btrfs
subvol=UBUNTU/@,space_cache,autodefrag,compress=lzo,relatime        0 0

and

> /dev/VG1/BTR_POOL    /data/VBOX_HIDDEN    btrfs
subvol=DATA/VBOX_HIDDEN,space_cache,compress=lzo,noatime    0 0
> /dev/VG1/BTR_POOL    /data/VBOX_VMS        btrfs
subvol=DATA/VBOX_VMS,space_cache,compress=lzo,noatime    0 0

the autodefrag option is enabled also for DATA/VBOX_HIDDEN and DATA/VBOM_VMS

>
>> Are you in position to to reduce the number of snapshot from hundreds
>> to few  ?
>
> I might do this as an experiment, but it would defeat one of the
> prominent purposes for which I use BTRFS, and the number of snapshots
> would grow immediately again, as I use the excellent OpenSuSE "snapper"
> tool, that makes a snapshot every single hour...

I am not suggesting that as solution, but this would help to
investigate the problem.

If you don't have any needs of the snapshot, you can delete it, wait
that the cleaner
kernel thread does its job (it could require a bit of time), then
reboot the machine.
If I am right the performance should goes high.

I fear that both the combination of autodefrag and the high number of
snapshot could
be the root-cause of the the bad performance.

>
> Kind regards.

Ciao
Goffredo

> --
> Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
>
