Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33570 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdGOXDt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 19:03:49 -0400
Received: by mail-qk0-f173.google.com with SMTP id a66so84990157qkb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Jul 2017 16:03:49 -0700 (PDT)
MIME-Version: 1.0
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Sun, 16 Jul 2017 02:03:48 +0300
Message-ID: <CAN4oSBc3WX6jDcMXYB_MEOT+t9NZaWWzU__vQHmpcTLV22P_Uw@mail.gmail.com>
Subject: Destination's Received UUID and source's UUID are not the same
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few days ago I tried to copy my backups to another machine by using
my external hard drive. `btrfs send my-backup | btrfs receive
/path/to/backup/dir` didn't go right since destination snapshot's
"Received UUID" does not match with source's "UUID". Here are relevant
stackoverflow question:

https://unix.stackexchange.com/questions/377914/how-to-test-if-two-btrfs-snapshots-are-identical

Is it a bug?
