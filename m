Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33462 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754912AbcIQA4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 20:56:49 -0400
Received: by mail-oi0-f42.google.com with SMTP id r126so130997794oib.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 17:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSxcVuE_ZFNvHR=4gF5hDaYTYoav_yV_wEbdjeEfrpOTw@mail.gmail.com>
References: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com> <CAJCQCtSxcVuE_ZFNvHR=4gF5hDaYTYoav_yV_wEbdjeEfrpOTw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 16 Sep 2016 18:56:47 -0600
Message-ID: <CAJCQCtQGOQ0=vmkGeDBBRug05jD1_Chm_=JQf+V+AJpym8JrUw@mail.gmail.com>
Subject: Re: Filesystem will remount read-only
Cc: Jeffrey Michels <jeffreym@skyward.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 6:08 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> If -o recovery doesn't work, you'll need to use something newer, you
> could use one of:
>
> Fedora Rawhide nightly with 4.8rc6 kernel and btrfs-progs 4.7.2. This
> is a small netinstall image. dd to a USB stick, choose Troubleshooting
> option, then the Rescue option, then after startup use the 3 option to
> get to a shell where you can try to mount normally, or use
> btrfs-check. Limited tty, no sshd.
> https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20160914.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-Rawhide-20160914.n.0.iso.n.0.iso
>
> Or something more official with published hash's for the image and a
> GUI, Fedora 24 workstation has kernel 4.5.5 and btrfs-progs 4.5.2
> https://getfedora.org/en/workstation/download/

Just to complete the thought... use these just to boot and have access
to something newer. I'm not suggesting install them. First try a
normal mount, and if that fails, try -o recovery, if that fails, I'm
curious about

btrfs rescue super-recover -v <dev>
btrfs check <dev>

What I'm after is a way to get it to mount cleanly with a new kernel,
and then hoping you can then just reboot with the ancient kernel and
it'll be back to normal.


-- 
Chris Murphy
