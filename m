Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35471 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935055AbcIZAmy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 20:42:54 -0400
Received: by mail-qk0-f173.google.com with SMTP id t7so150499324qkh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Sep 2016 17:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <df57cbab-f316-c6a1-fccc-0a1c1e6dc276@suse.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net> <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
 <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com> <CAGfcS_=hK1EpuBwJt1nost7=A3mgmyf3Cth0Bn10UQTtNs=fuw@mail.gmail.com>
 <df57cbab-f316-c6a1-fccc-0a1c1e6dc276@suse.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Sun, 25 Sep 2016 19:42:52 -0500
Message-ID: <CAGfcS_mhq6meu-d7BxwxaMLQBhm=STPG31OzVTf-ZaKb6a3KNw@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 25, 2016 at 7:39 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>
> I'm not sure about other distros, but at least with SLES/openSUSE you
> can configure kdump to /just/ dump the dmesg.
>

Well, on Gentoo I wrote the official docs on how it works, quite some
time ago...  :)  It is purely manual, so you can of course capture
whatever you want.  Just have it reboot to a shell and then save what
you need to.  An automated cross-distro core capture tool would
probably be useful.  I wonder if there is a generic one floating
around somewhere.

--
RIch
