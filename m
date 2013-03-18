Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33838 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3CRScQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 14:32:16 -0400
Received: by mail-wi0-f177.google.com with SMTP id hm14so2958418wib.10
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 11:32:15 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Mar 2013 19:32:14 +0100
Message-ID: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
Subject: Btrfs in multiple different disc -d sigle -m raid1 one drive failure...
From: Jan Beranek <jan233321@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I'm preparing a strorage pool for large data with quite low importance
- there will be at least 3 hdd in "-d single" and "-m raid1"
configuration.

mkfs.btrfs -d single -m raid1 /dev/sda /dev/sdb /dec/sdc

What happen if one hdd fails? Do I lost everything from all three
discs or only data from one disc? (if from only one disc, then is it
acceptable otherwise not...)

I read all documentation and a lot of discussions on the web and
answer is not clear at all...

Kind Regards

Jan.
