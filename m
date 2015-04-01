Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36835 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbDAR0z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 13:26:55 -0400
Received: by wgra20 with SMTP id a20so60856817wgr.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 10:26:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
 <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
 <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
 <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com> <CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 13:26:33 -0400
Message-ID: <CACPiFCKx7G3pYdSs_MBne5Z6XP+zbgQK_iaNWvMQPs76R=VQNg@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 1:03 PM, Chris Murphy <lists@colorremedies.com> wrote:
> mount /dev/sda6 /mnt
> btrfs inspect-internal inode-resolve 39841 /mnt

on the booted system...
# uname -a
Linux tp-martin.remote-learner.net 3.18.9-200.fc21.x86_64 #1 SMP Mon
Mar 9 15:10:50 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
# btrfs inspect-internal inode-resolve 39841 /
//etc/shadow-
# diff -u /etc/shadow{,-}
--- /etc/shadow 2015-03-04 02:26:59.478255332 -0500
+++ /etc/shadow-        2015-03-04 02:26:59.000000000 -0500
@@ -42,4 +42,3 @@
 systemd-timesync:!!:16498::::::
 systemd-network:!!:16498::::::
 systemd-resolve:!!:16498::::::
-systemd-bus-proxy:!!:16498::::::

Bizarre.

cheers,



m
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
