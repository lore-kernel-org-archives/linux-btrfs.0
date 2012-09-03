Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50044 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab2ICQbR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2012 12:31:17 -0400
Received: by qaas11 with SMTP id s11so2273836qaa.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Sep 2012 09:31:17 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 3 Sep 2012 09:31:16 -0700
Message-ID: <CAPF83mvX6ueqaR62bvRygapGtw6RPuSTo1+oeYUrYAD0MPsULA@mail.gmail.com>
Subject: Btrfs-Progs integration branch question
From: Suman C <schakrava@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I would like to get the latest btrfs-progs code. To me, Chris Mason's
repo at git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
seems latest but obviously its missing the last several patches I see
in the mailing list. I also tried Hugo Mills' integration repo at
http://git.darksatanic.net/repo/btrfs-progs-unstable.git and unless I
am looking at it wrong, it seems behind.

Can someone please point me to the latest process that is followed for
testing/developing recent btrfs-progs?

I am trying to integrate the quota patch from August 10th by Jan
Schmidt and getting conflicts when I git apply.

Thanks
Suman
