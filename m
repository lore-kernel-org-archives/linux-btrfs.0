Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:44254 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbdCQILS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 04:11:18 -0400
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id 5703BBA56
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 09:11:16 +0100 (CET)
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
Date: Fri, 17 Mar 2017 09:11:16 +0100
MIME-Version: 1.0
In-Reply-To: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 17/03/2017 à 05:32, Lionel Bouton a écrit :
> Hi,
>
> [...]
> I'll catch some sleep right now (it's 5:28 AM here) but I'll be able to
> work on this in 3 or 4 hours.

I woke up to this :

Mar 17 06:56:30 fileserver kernel: btree_readpage_end_io_hook: 104476
callbacks suppressed
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464
Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
block start 72340172838076673 3415463870464

and the server was unusable.

I just moved the client to a read-only backup server and we are trying
to find out if we can salvage this or if we start the full restore
procedure.

Help ?

Lionel
