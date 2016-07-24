Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33919 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbcGXCvY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 22:51:24 -0400
Received: by mail-oi0-f49.google.com with SMTP id l65so211471701oib.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 19:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b8dd2$3f01d229$9a93b58$84a3b39a@cox.net>
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org> <pan$b8dd2$3f01d229$9a93b58$84a3b39a@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 20:51:23 -0600
Message-ID: <CAJCQCtQdu2euKqFgMQ6L0_ojGQT5qk9ZX0bHRO8-7+5znvk1UQ@mail.gmail.com>
Subject: Re: Force recalculation of a data block checksum
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The negative of --init-csum-tree is that it's going to work on all
data extents. It's going to take a while. It's probably faster to
extract the suspect file with restore onto another file system and
check its integrity by other means (compare to backup, database
integrity check, etc).


-- 
Chris Murphy
