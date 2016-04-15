Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38083 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbcDOWEz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 18:04:55 -0400
Received: by mail-wm0-f47.google.com with SMTP id u206so49960845wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 15:04:54 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Apr 2016 18:04:53 -0400
Message-ID: <CAD=QJKjqh_yyfwGdjbBFp-UF0-szpr3xKGV2Bfvnbzc7kVgndA@mail.gmail.com>
Subject: btrfrs send ... | ... receive ... stores files sparsely?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I happened to notice this when checking free space of my backup and
primary system.  I'll use an example of a file that won't have any
private or confidential information.  For du -hc
./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache; ls -alh
./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache; sha512sum
./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache

On the sending system:
11M     ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
11M     total
-rw-r--r-- 1 kdm nogroup 11M Apr  2 18:00
./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
0ba53df610f35ef5170fe33fda4304456f4df2e9944447fa06467f8f6cfc89adc7da1698a1882929df56ce6be0e0846380cccfa411b4c7857f10a5c23d7797cb
 ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache

On the receiving system:
64K     ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
64K     total
-rw-r--r-- 1 114 nogroup 11M Apr  2 18:00
./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
0ba53df610f35ef5170fe33fda4304456f4df2e9944447fa06467f8f6cfc89adc7da1698a1882929df56ce6be0e0846380cccfa411b4c7857f10a5c23d7797cb
 ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache

The only thing I can think of is that something in btrfs send ... |
... receive ... is converting to sparse storage.  Is this intentional?
 I suppose with a COW filesystem preallocating empty space to prevent
fragmentation doesn't work, because as soon as that
cache/database/whatever_file changes the filesystem COWs the changes
to a location that will almost certainly require a seek...  That said,
will the way btrfs-progs is doing it cause similar issues with
converting to sparse storage that I've observed with tar and rsync?

Best regards,
Nicholas
