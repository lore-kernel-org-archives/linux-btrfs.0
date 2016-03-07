Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35288 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbcCGWzs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 17:55:48 -0500
Received: by mail-ob0-f180.google.com with SMTP id fp4so5787307obb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 14:55:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Mar 2016 23:55:47 +0100
Message-ID: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
Subject: btrfs and containers
From: Tobias Hunger <tobias.hunger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been running systemd-nspawn containers on top of a btrfs
filesystem for a while now.

This works great: Snapshots are a huge help to manage containers!

But today I ran btrfs subvol list . *inside* a container. To my
surprise I got a list of *all* subvolumes on that drive. That is
basically a complete list of containers running on the machine. I do
not want to have that kind of information exposed to my containers.

Is there a way to stop btrfs from listing subvolumes "above" the
current location? So that "btrfs subvol list /" in a container will
only show subvolumes that are set up in the container?

Best Regards,
Tobias
