Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44825 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JHMKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 08:10:03 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2887355lbo.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 05:10:02 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Date: Mon, 8 Oct 2012 14:09:22 +0200
Message-ID: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com>
Subject: working quota example?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I tried without success to get a working Btrfs+quota setup.
I created a new Btrfs filesystem on a new
partition, then activated quota management ('btrfs quota enable'), and
created a few subvolumes.
I created a qgroup (with id 100) with 'btrfs qgroup create', and tried to
apply a quota on one of my subvolumes using 'btrfs qgroup limit'

So far I've been unable to get this working, I can create a file (using dd)
inside the subvolume that will happily eat all my FS space without triggering
anything that could look like a quota limitation.
btrfs-progs help is not really useful, it's more like a quick reminder than
a real 'help'.
So I have 2 questions for experimented Btrfs developers and users:
-Could someone post a working example of a quota configuration on 1 or
several subvolumes? Minimal/simplest working configuration.
-How can I see the used/remaining space for each subvolume that has a quota
set (I guess it should be done with 'btrfs qgroup show ' but its output is
rather terse (returns '0/100 0 0' on my system).

Thanks in advance for your help, and all the work done to bring us so many
features.
