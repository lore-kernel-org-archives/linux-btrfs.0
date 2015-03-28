Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35460 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbC1VeY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 17:34:24 -0400
Received: by qgh3 with SMTP id 3so144885790qgh.2
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2015 14:34:23 -0700 (PDT)
MIME-Version: 1.0
From: Ames Cornish <ames@cornishes.net>
Date: Sat, 28 Mar 2015 14:34:02 -0700
Message-ID: <CAP6pX27aRSaht0a1UEur0Y-UPdDdx9wCKpD+R3jcBHQoyoXp3Q@mail.gmail.com>
Subject: Buttersink 0.6.2 - sync over ssh
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just released version 0.6.2 of buttersink.  It now supports
syncing snapshots between a local btrfs and a local or remote btrfs
over ssh, as well as syncing with S3 buckets.

The utility is on PyPi as "buttersink", and the GitHub page is here:
  https://github.com/AmesCornish/buttersink.

Thanks in advance for any feedback!

-- Ames
