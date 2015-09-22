Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35269 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbbIVSfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 14:35:42 -0400
Received: by vkao3 with SMTP id o3so12559734vka.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 11:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <560155C4.2080701@gmail.com>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
	<pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
	<CA+WRLO94UekKmT1cy3+t4+pHSCMj=HRoEF4oqtJDimS=EWnbhA@mail.gmail.com>
	<m49fv27cxyc.fsf@coffee.modeemi.fi>
	<56013C3C.6010005@gmail.com>
	<56014ECA.1050002@gmx.com>
	<560155C4.2080701@gmail.com>
Date: Tue, 22 Sep 2015 12:35:40 -0600
Message-ID: <CAJCQCtSK0AyjS8WX2V0K6nMgM3AmhFjTT6s5GcPF8EW8eKFN9Q@mail.gmail.com>
Subject: Re: RAID1 storage server won't boot with one disk missing
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Erkki Seppala <flux-btrfs@inside.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 7:21 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> It's not a bad idea, except that it changes established usage, and there are
> probably some people out there who depend on the current behavior. If we do
> go that way, mount needs to spit out a big obnoxious warning (as in, not
> through dmesg or mount options, but directly on stderr) if the filesystem
> gets mounted degraded automatically.

Definitely there needs to be a user space message. Even now when
trying to mount a volume with a missing device without -o degraded the
generic fs type unrecognized message is misleading.

>  A better option might be to add a
> compat feature bit, and if that bit is set, then use the above logic,
> otherwise use the current logic.

Yeah opt-in rather than opt-out.

-- 
Chris Murphy
