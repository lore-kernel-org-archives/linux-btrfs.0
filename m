Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55220 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753213AbeGCHhv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 03:37:51 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1faFqc-0005dk-5t
        for linux-btrfs@vger.kernel.org; Tue, 03 Jul 2018 09:35:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unsolvable technical issues?
Date: Tue, 3 Jul 2018 07:35:30 +0000 (UTC)
Message-ID: <pan$f3f7b$53185d9e$ee073b92$d7d590bf@cox.net>
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
        <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
        <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
        <64876ad1-9f63-f6f0-9d55-0fa4999f0bf5@gmail.com>
        <pan$15832$609432db$876d9a8a$e5840f46@cox.net>
        <9b482289-c96f-dac3-d2e7-db6a32596334@gmail.com>
        <ea1a9c9b-7132-87f1-04fc-85b278975925@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 02 Jul 2018 07:49:05 -0400 as
excerpted:

> Notably, most Intel systems I've seen have the SATA controllers in the
> chipset enumerate after the USB controllers, and the whole chipset
> enumerates after add-in cards (so they almost always have this issue),
> while most AMD systems I've seen demonstrate the exact opposite
> behavior,
> they enumerate the SATA controller from the chipset before the USB
> controllers, and then enumerate the chipset before all the add-in cards
> (so they almost never have this issue).

Thanks.  That's a difference I wasn't aware of, and would (because I tend 
to favor amd) explain why I've never seen a change in enumeration order 
unless I've done something like unplug my sata cables for maintenance and 
forget which ones I had plugged in where -- random USB stuff left plugged 
in doesn't seem to matter, even choosing different boot media from the 
bios doesn't seem to matter by the time the kernel runs (I'm less sure 
about grub).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

