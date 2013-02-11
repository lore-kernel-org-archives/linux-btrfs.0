Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64858 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3BKM2n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 07:28:43 -0500
Received: by mail-ie0-f177.google.com with SMTP id 16so7605877iea.36
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 04:28:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACP9TETrrxT=HyvXWt+uBDXjW9o9LGvJdrAPpUmzy4nb5iWXwQ@mail.gmail.com>
References: <CACP9TETrrxT=HyvXWt+uBDXjW9o9LGvJdrAPpUmzy4nb5iWXwQ@mail.gmail.com>
Date: Mon, 11 Feb 2013 16:28:43 +0400
Message-ID: <CACP9TETFnG2T3jqaOTRtLkrPV2TMiUn5bNdQoQfGEFzmwH18DA@mail.gmail.com>
Subject: Raid1 not working as expected
From: Alexey Polyakov <alexey.polyakov@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I created filesystem with two devices, 200gb partition each, raid1
both for data and metadata, and 16k leaf and node size. After using it
for day or two I got checksum error on one file. scrub reported about
70 more similar errors. Each error was mirrored on two drives, so
btrfsck and scrub showed everything as uncorrectable, attempts to make
a copy of damaged file just repeated checksum error messages. I had to
find and delete each file and then replace it by backup copy.
I'm trying to figure out what to do next to find source of a problem.
Can anyone help?

Thanks!

--
Alexey
