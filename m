Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:37678 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753965AbdIDUdn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 16:33:43 -0400
Received: by mail-lf0-f43.google.com with SMTP id 80so106252lfy.4
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 13:33:43 -0700 (PDT)
Subject: Re: \o/ compsize
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Cc: Adam Borowski <kilobyte@angband.pl>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
From: A L <crimsoncottage@gmail.com>
Message-ID: <8eb521a6-03d9-a8d3-b7e7-bf86d5320235@gmail.com>
Date: Mon, 4 Sep 2017 22:33:40 +0200
MIME-Version: 1.0
In-Reply-To: <20170904151154.vkhshc57t2mi2sze@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/4/2017 5:11 PM, Adam Borowski wrote:
> Hi!
> Here's an utility to measure used compression type + ratio on a set of files
> or directories: https://github.com/kilobyte/compsize

Great tool. Just tried it on some of my backup snapshots.

    # compsize portage.20170904T2200
    142432 files.
    all   78%  329M/ 422M
    none 100%  227M/ 227M
    zlib  52%  102M/ 195M

    # du -sh  portage.20170904T2200
    787M    portage.20170904T2200

    # btrfs fi du -s  portage.20170904T2200
         Total   Exclusive  Set shared  Filename
     271.61MiB     6.34MiB   245.51MiB portage.20170904T2200

Interesting results. How do I interpret them?


Compsize also doesn't seem to like some non-standard files and throws an 
error (even though they should be ignored?):

# compsize usb-backup/volumes/root/root.20170727T2321/
open("usb-backup/volumes/root/root.20170727T2321//tmp/screen/S-root/2757.pts-1.e350"): 
No such device or address

# dir 
usb-backup/volumes/root/root.20170727T2321//tmp/screen/S-root/2757.pts-1.e350
srwx------ 1 root root 0 Dec 31  2015 
usb-backup/volumes/root/root.20170727T2321//tmp/screen/S-root/2757.pts-1.e350=


