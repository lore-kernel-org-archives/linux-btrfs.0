Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33296 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbL2AMO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 19:12:14 -0500
Received: by mail-ig0-f180.google.com with SMTP id mv3so125236151igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 16:12:13 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Dec 2015 17:12:13 -0700
Message-ID: <CAJCQCtTKWdAknD9Cbr0kfVNsZ5GW0jH+ZE8ZsNmJ14223aVo2A@mail.gmail.com>
Subject: [bug] btrfs fi usage reports bogus 16EiB free space
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filed a bug:
https://bugzilla.kernel.org/show_bug.cgi?id=110111

The gist is that with a full USB stick, 'btrfs fi usage' reports:

    Free (estimated):  16.00EiB (min: 16.00EiB)

Which is clearly wrong, but very exciting to imagine what such a thing
would look like!


-- 
Chris Murphy
