Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35908 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971421AbdDYRuq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 13:50:46 -0400
Received: by mail-wm0-f54.google.com with SMTP id u65so29450330wmu.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Apr 2017 10:50:45 -0700 (PDT)
Received: from [192.168.77.22] (val06-1-88-182-161-34.fbx.proxad.net. [88.182.161.34])
        by smtp.gmail.com with ESMTPSA id y190sm3742284wmy.15.2017.04.25.10.50.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Apr 2017 10:50:43 -0700 (PDT)
From: Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: File system corruption, btrfsck abort
Message-Id: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
Date: Tue, 25 Apr 2017 19:50:42 +0200
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I”ve been trying to run btrfs as my primary work filesystem for about 3-4 months now on Fedora 25 systems. I ran a few times into filesystem corruptions. At least one I attributed to a damaged disk, but the last one is with a brand new 3T disk that reports no SMART errors. Worse yet, in at least three cases, the filesystem corruption caused btrfsck to crash.

The last filesystem corruption is documented here: https://bugzilla.redhat.com/show_bug.cgi?id=1444821. The dmesg log is in there.

The btrfsck crash is here: https://bugzilla.redhat.com/show_bug.cgi?id=1435567. I have two crash modes: either an abort or a SIGSEGV. I checked that both still happens on master as of today.

The cause of the abort is that we call set_extent_dirty from check_extent_refs with rec->max_size == 0. I’ve instrumented to try to see where we set this to 0 (see https://github.com/c3d/btrfs-progs/tree/rhbz1435567), and indeed, we do sometimes see max_size set to 0 in a few locations. My instrumentation shows this:

78655 [1.792241:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139eb80 max_size 16384 tmpl 0x7fffffffd120
78657 [1.792242:0x451cb8] MAX_SIZE_ZERO: Set max size 0 for rec 0x139ec50 from tmpl 0x7fffffffcf80
78660 [1.792244:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139ed50 max_size 16384 tmpl 0x7fffffffd120

I don’t really know what to make of it.

The cause of the SIGSEGV is that we try to free a list entry that has its next set to NULL.

#0  list_del (entry=0x555555db0420) at /usr/src/debug/btrfs-progs-v4.10.1/kernel-lib/list.h:125
#1  free_all_extent_backrefs (rec=0x555555db0350) at cmds-check.c:5386
#2  maybe_free_extent_rec (extent_cache=0x7fffffffd990, rec=0x555555db0350) at cmds-check.c:5417
#3  0x00005555555b308f in check_block (flags=<optimized out>, buf=0x55557b87cdf0, extent_cache=0x7fffffffd990, root=0x55555587d570) at cmds-check.c:5851
#4  run_next_block (root=root@entry=0x55555587d570, bits=bits@entry=0x5555558841

I don’t know if the two problems are related, but they seem to be pretty consistent on this specific disk, so I think that we have a good opportunity to improve btrfsck to make it more robust to this specific form of corruption. But I don’t want to hapazardly modify a code I don’t really understand. So if anybody could make a suggestion on what the right strategy should be when we have max_size == 0, or how to avoid it in the first place.

I don’t know if this is relevant at all, but all the machines that failed that way were used to run VMs with KVM/QEMU. DIsk activity tends to be somewhat intense on occasions, since the VMs running there are part of a personal Jenkins ring that automatically builds various projects. Nominally, there are between three and five guests running (Windows XP, WIndows 10, macOS, Fedora25, Ubuntu 16.04).


Thanks
Christophe de Dinechin

