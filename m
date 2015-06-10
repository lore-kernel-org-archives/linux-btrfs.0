Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34562 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530AbbFJH2m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 03:28:42 -0400
Received: by lbcmx3 with SMTP id mx3so23304969lbc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 00:28:40 -0700 (PDT)
MIME-Version: 1.0
From: Federico Pedemonte <pedemonte@gmail.com>
Date: Wed, 10 Jun 2015 09:28:09 +0200
Message-ID: <CAFQiR=S6uSkuC1rvh4coPMSr8AtewMLF8xejEfBdC45iYoqsKw@mail.gmail.com>
Subject: SSD mode on hybrid disk (SSHD)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I've replaced my notebook HDD with an SSHD hybrid disk (Seagate ST1000LM).
contrary to my experience with other similar machines, the disk
performance are really poor.

I suspect that it depends on btrfs detecting it as an SSD disk
(according to this dmesg message):

BTRFS: detected SSD devices, enabling SSD mode

is this the way it is supposed to be for hybrid disks?
is there a way to disable SSD mode (and, is it something I should try?)

thanks,
Federico
