Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42613 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3JWT0R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 15:26:17 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so1316673wgh.15
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 12:26:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Oct 2013 20:26:15 +0100
Message-ID: <CAHCKNJj2=qfWEpWWUOBit5cJakwd+oFr1U-xj8MS-w9oQo6YQg@mail.gmail.com>
Subject: 3.11 and 3.12rc continual hard lock ups
From: Sean Clarke <sean.clarke@sec-consulting.co.uk>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
   I have an Intel Core i7 based fileserver with 18TB BTRFS in a 6x
3TB RAID 1+0 configuration. The system was working fine running Ubuntu
13.04 (kernel 3.11.0-12-generic). The system was upgraded to Ubuntu
13.10 (kernel 3.11) and began to lock up daily, sometimes every couple
of hours. Previously it never crashed and was only taken down for
maintenance so a bug was files on launchpad
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1237794).

I have updated the system with mainline kernels "3.12.0-999-generic
#201310090426" and "3.12.0-999-generic #201310170405" and still the
lockups occur.

Absolutely nothing is logged in the syslog, it is a complete freeze. I
could get the system to hang by attempting to delete a 95GB tar file
from a client (over NFS), it would lock up every time. At other times
it just locks up (overnight for example).

I have had a top session running a couple of times when it locks up
and btrfs-transaction and btrfs-flush_del are using 3 to 5 cores at 50
to 100% (see top extract below).

top - 12:06:37 up 1:51, 1 user, load average: 3.33, 0.87, 0.33
Tasks: 226 total, 5 running, 221 sleeping, 0 stopped, 0 zombie
%Cpu(s): 0.0 us, 48.5 sy, 0.0 ni, 50.9 id, 0.1 wa, 0.0 hi, 0.5 si, 0.0 st
KiB Mem: 12295372 total, 12138296 used, 157076 free, 312 buffers
KiB Swap: 7831536 total, 56 used, 7831480 free, 24644 cached

  PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
 1005  root   20  0   0       0      0      R   100.    1 0.0 0:50.16
btrfs-transacti
 2462  root   20  0   0       0      0      R    75.8   0.0 0:06.66
btrfs-flush_del
 2459  root   20  0   0       0      0      S    72.5   0.0 0:10.18
btrfs-flush_del
 2463  root   20  0   0       0      0      S    70.5   0.0 0:14.41
btrfs-flush_del
 2457  root   20  0   0       0      0      R    38.6   0.0 0:28.35
btrfs-flush_del
 2458  root   20  0   0       0      0      S    17.0   0.0 0:39.31
btrfs-flush_del
 1959  root   20  0   0       0      0      R     9.6   0.0 0:31.68
btrfs-flush_del
  100  root    20  0   0       0      0      S    7.6    0.0 0:00.31 kswap


I have looked in bugzilla and can't relate this to anything already
reported, has anyone seen something similar to this?


Regards
Sean
