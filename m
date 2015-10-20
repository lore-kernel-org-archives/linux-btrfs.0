Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34012 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbbJTDtu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 23:49:50 -0400
Received: by lbbwb3 with SMTP id wb3so5181751lbb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 20:49:49 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Oct 2015 23:49:48 -0400
Message-ID: <CA+X5Wn7d3PLLn0qO9DeN4uWHsD3pnWprjD1BsVqw0pmq4gYKAw@mail.gmail.com>
Subject: Non-RAID1 areas in RAID1, data 8MB, Metadata 8MB, System 4MB
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The create RAID1 example illustrates my question, at:

https://btrfs.wiki.kernel.org/index.php/UseCases#How_do_I_create_a_RAID1_mirror_in_Btrfs.3F

It shows:

mkfs.btrfs -m raid1 -d raid1 /dev/sda1 /dev/sdb1

will result in:

btrfs fi df /mount

Data, RAID1: total=1.00GB, used=128.00KB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=24.00KB
Metadata: total=8.00MB, used=0.00


What's the 8MB, System 4MB, and Metadata 8MB areas that appear not to
be redundant?

I'm seeing these small areas on my own RAID1, but using the example
for simplicity.

I'm sure it has to be OK those spaces aren't redundant, but I don't
get what could be there that wouldn't be critical...
