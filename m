Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34489 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbcA2SFM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 13:05:12 -0500
Received: by mail-io0-f174.google.com with SMTP id 9so18171497iom.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 10:05:12 -0800 (PST)
MIME-Version: 1.0
From: John Smith <lenovomi@gmail.com>
Date: Fri, 29 Jan 2016 19:04:42 +0100
Message-ID: <CAAcrkYJmDHNijZx45cdfZNTgVCgvih_06WROGJg+pjYsQT-=tg@mail.gmail.com>
Subject: csum failed : d-raid0, m-raid1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

i built btrfs volume using 2x3tb brand new /tested for badblocks
drives. I copied into volume around 5Tb of data.

I tried to read one file which is around 4GB and i got input / output error.

Dmesg contains:

[154159.040059] BTRFS warning (device sdd): csum failed ino 9995246
off 4506214400 csum 383964635 expected csum 6478505


Any idea what is it? Whats the reason that this happened? Can I recover?


Thank you!
