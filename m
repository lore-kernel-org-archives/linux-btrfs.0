Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02A3C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Feb 2022 15:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244081AbiBDPZs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 10:25:48 -0500
Received: from pio-pvt-msa3.bahnhof.se ([79.136.2.42]:51842 "EHLO
        pio-pvt-msa3.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiBDPZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Feb 2022 10:25:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTP id E9DB63F447
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Feb 2022 16:25:45 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa3.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa3.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SpMsEkzTQ4wB for <linux-btrfs@vger.kernel.org>;
        Fri,  4 Feb 2022 16:25:44 +0100 (CET)
Received: by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTPA id C08893F439
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Feb 2022 16:25:44 +0100 (CET)
Received: from [192.168.0.134] (port=45982)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1nG0T1-0004qg-Md
        for linux-btrfs@vger.kernel.org; Fri, 04 Feb 2022 16:25:44 +0100
Message-ID: <3bc3dd16-f5ae-9731-a798-1a3422371555@tnonline.net>
Date:   Fri, 4 Feb 2022 16:25:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To:     linux-btrfs@vger.kernel.org
Content-Language: en-US
From:   Forza <forza@tnonline.net>
Subject: Problem with 'btrfs property set <file> compression no'
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!

According to https://btrfs.wiki.kernel.org/index.php/Changelog it should 
be possible to set the 'NOCOMPRESS' attribute using

btrfs property set <file> compression no

Likewise it is also possible to set this using 'chattr +m'.

However in my testing on a 5.15.16 kernel (btrfs-progs v5.16), only the 
latter works as I expected. Should it be possible to prevent compression 
using 'btrfs property set'?


Example on a system with 'compress-force=zstd' mount option.

~~~~8<~~~~8<~~~~
# touch foobar
# btrfs property set foobar compression zstd
# lsattr
--------c------------- ./foobar

# btrfs property set foobar compression no
# lsattr
---------------------- ./foobar

# dd if=/dev/zero of=foobar count=100
100+0 records in
100+0 records out
51200 bytes (51 kB, 50 KiB) copied, 0.000799556 s, 64.0 MB/s

# compsize foobar
Processed 1 file, 1 regular extents (1 refs), 0 inline.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL        7%      4.0K          52K          52K
zstd         7%      4.0K          52K          52K

# truncate -s 0 foobar
# chattr +m foobar
---------------------m ./foobar

# dd if=/dev/zero of=foobar count=100
100+0 records in
100+0 records out
51200 bytes (51 kB, 50 KiB) copied, 0.000883995 s, 57.9 MB/s

# compsize foobar
Processed 1 file, 1 regular extents (1 refs), 0 inline.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL      100%       52K          52K          52K
none       100%       52K          52K          52K

~~~~8<~~~~8<~~~~


Thanks,
Forza

