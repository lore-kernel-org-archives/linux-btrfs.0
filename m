Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50917 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdIOPfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 11:35:08 -0400
Date: Fri, 15 Sep 2017 17:34:57 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: [RFC 0/3]: settable compression level for zstd
Message-ID: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
Here's a patch set that allows changing the compression level for zstd,
currently at mount time only.  I've played with it for a month, so despite
being a quick hack, it's reasonably well tested.  Tested on 4.13 +
btrfs-for-4.14 only, though -- I've booted 11th-day-of-merge-window only an
hour ago on one machine, no explosions yet.

As a quick hack, it doesn't conserve memory as it should: all workspace
allocations assume level 15 and waste space otherwise.

Because of an (easily changeable) quirk of compression level encoding, the
max is set at 15, but I guess higher levels are pointless for 128KB blocks. 
Nick and co can tell us more -- for me zstd is mostly a black box so it's
you who knows anything about tuning it.

There are three patches:
* [David Sterba] btrfs: allow to set compression level for zlib
  Unmodified version of the patch from Jul 24, I'm re-sending it for
  convenience.
* btrfs: allow setting zlib compression level via :9
  Some bikeshedding: it looks like Chris Mason also favours zlib:9 over
  zlib9 as the former is more readable.  If you disagree... well, it's up
  to you to decide anyway.  This patch accepts both syntaxes.
* btrfs: allow setting zstd level


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
