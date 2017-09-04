Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50444 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753658AbdIDPL7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 11:11:59 -0400
Date: Mon, 4 Sep 2017 17:11:54 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Cc: Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.cz>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: \o/ compsize
Message-ID: <20170904151154.vkhshc57t2mi2sze@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
Here's an utility to measure used compression type + ratio on a set of files
or directories: https://github.com/kilobyte/compsize

It should be of great help for users, and also if you:
* muck with compression levels
* add new compression types
* add heurestics that could err on withholding compression too much

(Thanks for Knorrie and his python-btrfs project that made figuring out the
ioctls much easier.)

Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
