Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36298 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbcGFSYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:24:54 -0400
Received: by mail-qk0-f169.google.com with SMTP id 82so17370859qko.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:24:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com> <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Wed, 6 Jul 2016 21:24:52 +0300
Message-ID: <CAA91j0VEBRDUW+MehjtUqhZHi2dehnbY9w-_quEihRc1D=cpvQ@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: Chris Murphy <lists@colorremedies.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 8:19 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> I'm mainly concerned with rootfs. And I'm mainly concerned with a very
> simple 2 disk raid1. With a simple user opt in using
> rootflags=degraded, it should be possible to boot the system. Right
> now it's not possible. Maybe just deleting 64-btrfs.rules would fix
> this problem, I haven't tried it.
>

While deleting this rule will fix your specific degraded 2 disk raid 1
it will break non-degraded multi-device filesystem. Logic currently
implemented by systemd assumes that mount is called after
prerequisites have been fulfilled. Deleting this rule will call mount
as soon as the very first device is seen; such filesystem is obviously
not mountable.

Equivalent of this rule is required under systemd and desired in
general to avoid polling. On systemd list I outlined possible
alternative implementation as systemd service instead of really
hackish udev rule.
