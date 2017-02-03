Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linux-ag.de ([62.245.157.206]:34401 "EHLO mail.linux-ag.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752496AbdBCM53 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Feb 2017 07:57:29 -0500
Received: from localhost (mail.linux-ag.de [62.245.157.206])
        by mail.linux-ag.de (Postfix) with ESMTP id 0CC39157A
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Feb 2017 13:57:27 +0100 (CET)
Date: Fri, 3 Feb 2017 13:57:25 +0100
From: "Juergen 'Louis' Fluk" <jfluk@linux-ag.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_drop_snapshot "IO failure" after RAID controller reset
References: <20170203101651.GA20944@midas.ntm-gmbh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170203101651.GA20944@midas.ntm-gmbh.de>
Message-Id: <20170203125727.0CC39157A@mail.linux-ag.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 03, 2017 at 11:16:51AM +0100, Juergen 'Louis' Fluk wrote:
> Dear all,
> 
> the RAID controller underneath our 32T BTRFS container had a sudden reset,
> and after rebooting BTRFS drops to readonly after some list of messages.
> 
> I did recovery + btrfs-zero-log + recovery (using a LVM snapshot), yet
> the error persists. From "transid verify failed" I understand that journal
> and data are not in sync (data is newer). BTRFS tries to drop a snapshot
> and fails there - is there a way to ignore it or force it?
> 
> RAID controller does not signal new errors so I assume it's not a problem
> of accessing some single disk block, but possibly some information was not
> written to disk at the time of controller reset.
...
> 
>   mount -o recovery /dev/vg/snap /mnt/backup
> 
> Feb 3 08:05:57 zeus kernel: [336619.494618] BTRFS info (device dm-2): enabling auto recovery
> Feb 3 08:05:57 zeus kernel: [336619.494625] BTRFS info (device dm-2): disk space caching is enabled
> Feb 3 08:09:32 zeus kernel: [336834.568348] BTRFS: checking UUID tree
> Feb 3 08:10:44 zeus kernel: [336905.752787] BTRFS info (device dm-2): The free space cache file (814462533632) is invalid. skip it
> Feb 3 08:10:44 zeus kernel: [336905.752787]
> Feb 3 08:11:26 zeus kernel: [336948.358199] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
> Feb 3 08:11:26 zeus kernel: [336948.397901] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
> Feb 3 08:11:46 zeus kernel: [336968.341996] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
> Feb 3 08:11:46 zeus kernel: [336968.362567] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
> Feb 3 08:11:46 zeus kernel: [336968.406344] BTRFS: error (device dm-2) in btrfs_drop_snapshot:8367: errno=-5 IO failure
> Feb 3 08:11:46 zeus kernel: [336968.418816] BTRFS info (device dm-2): forced readonly
>
...
> The server is running kernel 3.19.0-79-generic (ubuntu 14.04), btrfs-tools 3.12-1ubuntu0.1.
> Does it make sense to use newer kernel and/or tools to recover?


Running on kernel 4.4.0-62-generic now, procedure looks quite similar:

  mount -o recovery /dev/vg/snap /mnt/backup

Feb 3 11:38:30 zeus kernel: [ 297.414369] BTRFS info (device dm-2): enabling auto recovery
Feb 3 11:38:30 zeus kernel: [ 297.414375] BTRFS info (device dm-2): disk space caching is enabled
Feb 3 11:41:54 zeus kernel: [ 501.145009] BTRFS: checking UUID tree
Feb 3 11:43:02 zeus kernel: [ 568.938947] BTRFS info (device dm-2): The free space cache file (814462533632) is invalid. skip it
Feb 3 11:43:02 zeus kernel: [ 568.938947]
Feb 3 11:44:57 zeus kernel: [ 683.656849] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:44:57 zeus kernel: [ 683.718674] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:44:59 zeus kernel: [ 686.344684] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:44:59 zeus kernel: [ 686.370777] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:44:59 zeus kernel: [ 686.374094] BTRFS: error (device dm-2) in btrfs_drop_snapshot:9008: errno=-5 IO failure
Feb 3 11:44:59 zeus kernel: [ 686.377772] BTRFS info (device dm-2): forced readonly

  umount /mnt/backup

Feb 3 11:46:36 zeus kernel: [ 783.112240] BTRFS error (device dm-2): cleaner transaction attach returned -30

  btrfs-zero-log /dev/vg/snap # takes 180s, no messages

  mount -o recovery /dev/vg/snap /mnt/backup

Feb 3 11:49:35 zeus kernel: [ 961.805605] BTRFS info (device dm-2): enabling auto recovery
Feb 3 11:49:35 zeus kernel: [ 961.805611] BTRFS info (device dm-2): disk space caching is enabled
Feb 3 11:53:03 zeus kernel: [ 1170.373099] BTRFS: checking UUID tree
Feb 3 11:54:12 zeus kernel: [ 1238.660425] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:54:12 zeus kernel: [ 1238.807281] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:54:25 zeus kernel: [ 1252.132065] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:54:25 zeus kernel: [ 1252.422404] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 11:54:25 zeus kernel: [ 1252.425953] BTRFS: error (device dm-2) in btrfs_drop_snapshot:9008: errno=-5 IO failure
Feb 3 11:54:25 zeus kernel: [ 1252.429649] BTRFS info (device dm-2): forced readonly
Feb 3 11:59:14 zeus kernel: [ 1541.593077] BTRFS warning (device dm-2): btrfs_uuid_scan_kthread failed -30
Feb 3 12:00:28 zeus kernel: [ 1614.931233] BTRFS error (device dm-2): parent transid verify failed on 4052043694080 wanted 451805 found 451973
Feb 3 12:00:28 zeus kernel: [ 1615.014242] BTRFS error (device dm-2): parent transid verify failed on 4052043694080 wanted 451805 found 451973
Feb 3 12:00:34 zeus kernel: [ 1621.247906] BTRFS error (device dm-2): parent transid verify failed on 4050351652864 wanted 451804 found 451973
Feb 3 12:00:34 zeus kernel: [ 1621.259342] BTRFS error (device dm-2): parent transid verify failed on 4050351652864 wanted 451804 found 451973
Feb 3 12:00:40 zeus kernel: [ 1626.875601] BTRFS error (device dm-2): parent transid verify failed on 4052066533376 wanted 451806 found 451974
Feb 3 12:00:40 zeus kernel: [ 1627.015048] BTRFS error (device dm-2): parent transid verify failed on 4052066533376 wanted 451806 found 451974
Feb 3 12:00:46 zeus kernel: [ 1632.837738] BTRFS error (device dm-2): parent transid verify failed on 4051971883008 wanted 451804 found 451973
Feb 3 12:00:46 zeus kernel: [ 1632.884797] BTRFS error (device dm-2): parent transid verify failed on 4051971883008 wanted 451804 found 451973
Feb 3 12:00:47 zeus kernel: [ 1634.432228] BTRFS error (device dm-2): parent transid verify failed on 4050367676416 wanted 451804 found 451973
Feb 3 12:00:47 zeus kernel: [ 1634.551432] BTRFS error (device dm-2): parent transid verify failed on 4050367676416 wanted 451804 found 451973
Feb 3 12:00:51 zeus kernel: [ 1637.714149] BTRFS error (device dm-2): parent transid verify failed on 4052133838848 wanted 451807 found 451974
Feb 3 12:00:51 zeus kernel: [ 1637.768666] BTRFS error (device dm-2): parent transid verify failed on 4052133838848 wanted 451807 found 451974
Feb 3 12:00:51 zeus kernel: [ 1638.554131] BTRFS error (device dm-2): parent transid verify failed on 4051397328896 wanted 451804 found 451973
Feb 3 12:00:52 zeus kernel: [ 1638.665906] BTRFS error (device dm-2): parent transid verify failed on 4051397328896 wanted 451804 found 451973
Feb 3 12:00:52 zeus kernel: [ 1639.356236] BTRFS error (device dm-2): parent transid verify failed on 4052072022016 wanted 451806 found 451974
Feb 3 12:00:52 zeus kernel: [ 1639.437114] BTRFS error (device dm-2): parent transid verify failed on 4052072022016 wanted 451806 found 451974
Feb 3 12:05:33 zeus kernel: [ 1920.132049] INFO: task btrfs-transacti:8053 blocked for more than 120 seconds.
Feb 3 12:07:33 zeus kernel: [ 2040.156049] INFO: task btrfs-transacti:8053 blocked for more than 120 seconds.
Feb 3 12:09:33 zeus kernel: [ 2160.164049] INFO: task btrfs-transacti:8053 blocked for more than 120 seconds.
Feb 3 12:11:33 zeus kernel: [ 2280.180054] INFO: task btrfs-transacti:8053 blocked for more than 120 seconds.

  umount /mnt/backup

Feb 3 12:55:37 zeus kernel: [ 4924.048310] BTRFS error (device dm-2): cleaner transaction attach returned -30

  mount /dev/vg/snap /backup

Feb 3 12:55:45 zeus kernel: [ 4932.561424] BTRFS info (device dm-2): disk space caching is enabled
Feb 3 12:59:04 zeus kernel: [ 5130.898771] BTRFS: checking UUID tree
Feb 3 12:59:34 zeus kernel: [ 5160.957529] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 12:59:34 zeus kernel: [ 5160.994059] BTRFS error (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 12:59:34 zeus kernel: [ 5160.996986] BTRFS: error (device dm-2) in btrfs_drop_snapshot:9008: errno=-5 IO failure
Feb 3 12:59:34 zeus kernel: [ 5161.000282] BTRFS info (device dm-2): forced readonly
Feb 3 13:00:36 zeus kernel: [ 5223.300104] BTRFS warning (device dm-2): btrfs_uuid_scan_kthread failed -30


So the OOPS after btrfs-zero-log is gone, and we reduced to a single "parent transid verify failed" and just "btrfs_drop_snapshot:9008: errno=-5 IO failure".

louis
-- 
Jürgen 'Louis' Fluk
Linux Information Systems AG
Thomas-Dehler-Str. 9, 81737 München

Fon: +49 89 993412-21, Fax: +49 89 993412-99
jfluk@linux-ag.com, http://www.linux-ag.com
----------------------------------------------------------
Sitz der Gesellschaft: Thomas-Dehler-Str. 9, 81737 München
Amtsgericht München: HRB 128 019
Vorstand: Rudolf Strobl
Aufsichtsrat: Michael Tarabochia (Vorsitzender)

*** Die bestere IT für den Mittelstand ***
