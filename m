Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33866 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbcEZWm2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 18:42:28 -0400
Received: by mail-vk0-f48.google.com with SMTP id c189so121373864vkb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 15:42:27 -0700 (PDT)
MIME-Version: 1.0
From: Diego Torres <diego.torres@gmail.com>
Date: Fri, 27 May 2016 00:42:07 +0200
Message-ID: <CAKg6aQzTx7NLjC6gZxKUKkuACo313N3ZqxQ0SXO4WXEwGPFNkg@mail.gmail.com>
Subject: btrfs stability
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I've been using btrfs with a raid5 configuration with 3 disks for 6
months, and then with 4 disks for a couple of months more. I run a
weekly scrub, and a monthly balance. Btrfs is the only fs that can add
drives one by one to an existing raid setup, and use the new space
inmediately, without replacing all the drives. For me, this is one of
the strongest points.

And, as far as I understand, If I keep and eye on the free space
available, and no drives fail, the filesystem would last indefinitely.
However, the code to replace a failed/missing drive is not yet final,
as I have discovered reading some wikis and this mailing list. Maybe
I'm wrong.

I haven't been able to find a timeline/roadmap about when the replace
command will be stable/ready for use.

Is this someone's priority? Is it planned for the next one,two or
three years coming?

Thanks in advance.

-- 
-- Use of a keyboard or mouse may be linked to serious injuries or disorders.
diego dot torres at gmail dot com - Madrid / Spain
