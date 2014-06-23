Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:53789 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFWWSw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 18:18:52 -0400
Received: by mail-qg0-f46.google.com with SMTP id q107so6491720qgd.33
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 15:18:51 -0700 (PDT)
MIME-Version: 1.0
From: Mike Hartman <mike@hartmanipulation.com>
Date: Mon, 23 Jun 2014 18:18:31 -0400
Message-ID: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
Subject: Btrfs suddenly unmountable, open_ctree failed
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Distro: Linux Mint 16
Kernel: 3.11.0-12-generic
Btrfs (used to create): 0.20-rc1 (current version in Mint repo)
Btrfs (used to troubleshoot): 3.14.2

Setup: sda6 is a luks container with btrfs inside. Btrfs has
subvolumes @ (/) and @home (/home).

I was doing nothing in particular on my laptop (normal web browsing)
when I noticed my system had gone read-only. dmesg showed an IO error
of some kind between btrfs and the underlying drive. I didn't think to
save it out on the web.

I rebooted and successfully unlocked the luks container, but the btrfs
volumes failed to mount. dmesg showed output like:

[92039.112690] device fsid b1205e06-7943-4aaf-9e13-4df0cf1394bc devid
1 transid 214454 /dev/mapper/sda6_crypt
[92039.113633] btrfs: disk space caching is enabled
[92039.116754] btrfs bad tree block start 10446918091381484860 760696832
[92039.116956] btrfs bad tree block start 7222353813307377896 760696832
[92039.141820] btrfs: open_ctree failed

I dded an image of the partition, grabbed the latest btrfs-progs from
git, and then tried every troubleshooting/recovery method I could find
online with no luck. The complete transcript is available here:

http://pastebin.com/PSHL7UxZ

Summary:

"mount -o ro,recovery", "btrfs-image", "btrfs-debug-tree",
"btrfs-zero-log", "btrfs check" and "btrfs restore" all failed.

"btrfs rescue super-recover" said the supers are fine.
"btrfs-find-root" said it found the tree root. "btrfs rescue
chunk-recover" said it was successful.

The drive itself seems to be ok, but I haven't tried any tests that
would write to it. (The original btrfs data is still there and
untouched.)

Can anyone offer any suggestions? Is this data really unrecoverable? I
have no idea what could have gone so severely wrong.
