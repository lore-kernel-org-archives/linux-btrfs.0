Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:36516 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932074AbdC2MYi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 08:24:38 -0400
Received: by mail-wr0-f177.google.com with SMTP id w11so12708894wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 05:24:36 -0700 (PDT)
Subject: Re: send snapshot from snapshot incremental
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: wertstoffe@nurfuerspam.de
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <j33rqd-nkh.ln1@aldebaran.xundeenergie.at>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Mar 2017 14:24:40 +0200
Message-ID: <1490790280.3490.22.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

>Jakob Schürz Tue, 28 Mar 2017 15:16:28 -0700

>Thanks for that explanation. 

>I'm sure, i didn't understand the -c option... and my english is pretty
>good enough for the most things I need to know in Linux-things... but
>not for this. :-(
]zac[

In one of my scripts I use this method:

subvolume            X
readonly snapshot    X1
readonly snapshot    X2
readonly snapshot    X3
....

send 1           btrfs send       X1
send 2           btrfs send -p X1 X2
send 3           btrfs send -p X2 X3
....


Any other sequence does not work, in the receive subvolume there must be the full parent (X1 then X2 then ...).


Gdb


https://sourceforge.net/projects/btrfsmanage/





