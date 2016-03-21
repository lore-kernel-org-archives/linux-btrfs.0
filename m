Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36453 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbcCUDnw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 23:43:52 -0400
Received: by mail-ig0-f173.google.com with SMTP id nk17so62445367igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 20:43:52 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 20 Mar 2016 21:43:52 -0600
Message-ID: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
Subject: overlay file to test btrfs repairs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

So I just ran into this:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

This is a device mapper overlay file - not overlayfs.

For the repairs that are sometimes uncertain what's next, maybe this
is a viable option to avoid changing the file system? I'm thinking
chunk-recover might take up too much space, I'm not sure how that one
works, if chunks are just being read or if they have to be rewritten
or if it's just the chunk tree? But for 'btrfs check' and 'btrfs
rescue super-recover/zero-log' there should be very little being
written so the overlay idea might be a good step?

Opinions?

-- 
Chris Murphy
