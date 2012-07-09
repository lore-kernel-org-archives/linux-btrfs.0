Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61310 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2GIWtN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 18:49:13 -0400
Received: by pbbrp8 with SMTP id rp8so19923241pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 15:49:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFB59BF.1050104@arndnet.de>
References: <4FFB59BF.1050104@arndnet.de>
Date: Mon, 9 Jul 2012 16:49:13 -0600
Message-ID: <CAE5mzvizLBtMbVmGfQc1HYve8BoFk+G93j2B=1759JWLH_4w+w@mail.gmail.com>
Subject: Re: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in /proc/mounts
From: cwillu <cwillu@cwillu.com>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 9, 2012 at 4:22 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
> Hi,
>
> using btrfs with LVM snapshots seems to be confusing /proc/mounts
> After mounting a snapshot of an original filesystem, the devicename of the
> original filesystem is overwritten with that of the snapshot in /proc/mounts.

If the lvm snapshot is visible to btrfs (i.e., btrfs dev scan), it
will appear as another device which belongs to the original filesystem
with a duplicate devid.  This might result in bad things happening, or
possibly just hilarity.

You have a backup that isn't just an lvm snapshot, right?
