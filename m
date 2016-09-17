Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36723 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753923AbcIQAI0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 20:08:26 -0400
Received: by mail-oi0-f53.google.com with SMTP id t83so1578678oie.3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 17:08:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com>
References: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 16 Sep 2016 18:08:25 -0600
Message-ID: <CAJCQCtSxcVuE_ZFNvHR=4gF5hDaYTYoav_yV_wEbdjeEfrpOTw@mail.gmail.com>
Subject: Re: Filesystem will remount read-only
To: Jeffrey Michels <jeffreym@skyward.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 8:57 AM, Jeffrey Michels <jeffreym@skyward.com> wrote:
> Hello,
>
> I have a system that has been in production for a few years.  The SAN the VM was running on had a hardware failure about a month ago and now one of the two btrfs filesystems will remount after boot read-only.  Here is the system information:
>
> uname -a
>
> Linux retain 3.0.101-0.47.71-default #1 SMP Thu Nov 12 12:22:22 UTC 2015 (b5b212e) x86_64 x86_64 x86_64 GNU/Linux
>
> Btrfs --version
>
> Btrfs v0.20+

Impressive that it's been running in production this long and with old
kernel. I like it!

Anyway, you could try mounting with -o recovery and see if that works.
That's about the only thing I'd trust with such an old kernel and
btrfs-progs. I don't even think it's worth trying the btrfsck on v0.20
just to see what the problems might be, and certainly not for actually
using the repair mode.  Actually I'm not even sure progs that old even
does repairs, it might be the era of notify only.

If -o recovery doesn't work, you'll need to use something newer, you
could use one of:

Fedora Rawhide nightly with 4.8rc6 kernel and btrfs-progs 4.7.2. This
is a small netinstall image. dd to a USB stick, choose Troubleshooting
option, then the Rescue option, then after startup use the 3 option to
get to a shell where you can try to mount normally, or use
btrfs-check. Limited tty, no sshd.
https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20160914.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-Rawhide-20160914.n.0.iso.n.0.iso

Or something more official with published hash's for the image and a
GUI, Fedora 24 workstation has kernel 4.5.5 and btrfs-progs 4.5.2
https://getfedora.org/en/workstation/download/




-- 
Chris Murphy
