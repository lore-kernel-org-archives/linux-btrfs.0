Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:32971 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbbGPALM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 20:11:12 -0400
Received: by pdbqm3 with SMTP id qm3so33488244pdb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 17:11:11 -0700 (PDT)
Received: from sharpeth.aviatis.com (c-107-3-142-14.hsd1.ca.comcast.net. [107.3.142.14])
        by smtp.gmail.com with ESMTPSA id fc3sm5874841pab.16.2015.07.15.17.11.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 15 Jul 2015 17:11:11 -0700 (PDT)
From: Johannes Ernst <johannes.ernst@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: I'd like a -r flag on btrfs subvolume delete
Message-Id: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
Date: Wed, 15 Jul 2015 17:11:11 -0700
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rationale: cleaning up after containers, which may have created their own subvolumes.

E.g.
	systemd-nspawn —boot —directory dir

where dir is a subvolume. When done with the container, deleting fir directly doesn’t work, because we now also have a subvolume at
	dir/var/lib/machines
and obviously there may be more that the container might have created.

Cleaning this all up is a bit of pain, and
	btrfs subvolume delete -r dir
would solve it nicely.

Cheers,



Johannes Ernst
Blog: http://upon2020.com/
Twitter: @Johannes_Ernst
GPG key: http://upon2020.com/public/pubkey.txt
Check out UBOS, the Linux distro for personal servers I work on: http://ubos.net/

