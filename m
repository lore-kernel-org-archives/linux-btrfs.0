Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36094 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbcKBABh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 20:01:37 -0400
Received: by mail-qk0-f194.google.com with SMTP id z190so13107679qkc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Nov 2016 17:01:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: badara+ml@gmail.com
From: Ahmed Badr <badara+ml@gmail.com>
Date: Wed, 2 Nov 2016 02:00:55 +0200
Message-ID: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
Subject: Snapper & apt-btrfs-snapshot on Ubuntu
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Btrfs newbie here trying to figure out how to use it properly on Ubuntu
16.04 server.

I have root formated using Btrfs, and installed Snapper and everything
seems to works fine. I installed apt-btrfs-snapshot which takes snapshot
before and after apt-get just like OpenSUSE/Zypper and that seems to work
fine too.

The problem is, unlike OpenSUSE/Zypper, on Ubuntu neither Snapper nor
apt-btrfs-snapshot see the snapshots made by the other program. So I cannot
list, compare or manage the apt-btrfs snapshots using snapper. Any way to
fix this?

Thanks.
--
A.B.
