Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60742 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIZOSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 10:18:38 -0400
Received: by mail-vc0-f175.google.com with SMTP id hy4so1956811vcb.34
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 07:18:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan.2014.09.25.21.21.47@googlemail.com>
References: <CAPL5yKfTfzkqBT9dQBpJAjuBtq2-=QqdCn_Pzfnnd1URKA_q4A@mail.gmail.com>
	<pan.2014.09.24.22.23.33@googlemail.com>
	<CAPL5yKdt7eTk-+0NP2Y9Aa8zNQqJpujTm31z_ee04OS3DocMXg@mail.gmail.com>
	<pan.2014.09.25.21.21.47@googlemail.com>
Date: Fri, 26 Sep 2014 10:18:37 -0400
Message-ID: <CAGfcS_koxt3d4kBv1o+5FnpDj-6+WA6tsPbPkBdehNnWcYnaKA@mail.gmail.com>
Subject: Re: 3.16 Managed to ENOSPC with <80% used
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 25, 2014 at 5:21 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> That's why I mentioned adding a second device - that will immediately
> allow cleanup with headroom. An additional 8GB tmpfs volume can works
> wonders.
>

If you add a single 8GB tmpfs to a RAID1 btrfs array, is it safe to
assume that you'll still always have a redundant copy of everything on
a disk somewhere during the recovery?  Would only a single tmpfs
volume actually help in this case?  I get a bit nervous about doing a
cleanup that involves moving metadata to tmpfs of all places, since
some kind of deadlock/etc could result in unrecoverable data loss.

Doing the same thing with an actual hard drive would concern me less.

--
Rich
