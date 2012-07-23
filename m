Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54470 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2GWL5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 07:57:22 -0400
Received: by pbbrp8 with SMTP id rp8so10776882pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2012 04:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <juhp57$5aq$1@dough.gmane.org>
References: <juhp57$5aq$1@dough.gmane.org>
Date: Mon, 23 Jul 2012 05:57:21 -0600
Message-ID: <CAE5mzviKfn7VGfKHgtGojuuWnC89Hv0mE-Uk77Wx1vFxVL8T2A@mail.gmail.com>
Subject: Re: btrfs-convert complains that fs is mounted even if it isn't
From: cwillu <cwillu@cwillu.com>
To: Jochen <jochen3941@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 22, 2012 at 2:51 PM, Jochen <jochen3941@gmail.com> wrote:
> Hi,
>
> I'm trying to run btrfs-convert on a system that has three raid partitions
> (boot/md1, swap/md2 and root/md3). When I boot a rescue system from md1, and
> try to run "btrfs-convert /dev/md3", it complains that /dev/md3 is already
> mounted, although it definitely is not. The only partition mounted is
> /dev/md1 because of the rescue system. When I replicate the setup in a local
> VM, booting the rescue system from another disk (no /dev/md1 mounted) helps,
> btrfs-convert runs. However, I cannot do this on the server.
>
> Is there anything I can do about this?

Can you mount and cleanly umount /dev/md3 and try the convert again?
