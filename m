Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39340 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3CZX2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 19:28:23 -0400
Received: by mail-oa0-f44.google.com with SMTP id h1so8236803oag.17
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 16:28:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 00:28:23 +0100
Message-ID: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
Subject: "No space left on device" although df reports only 55% in use
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using a btrfs loopback mounted file with lzo-compression on
Linux-3.7.9, and I ran into "No space left on device" messages,
although df reports only 55% of space is used:

# touch testfile
touch: cannot touch `testfile': No space left on device

# df
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/loop0      32768000  17383924  14649172  55% /home/ce/anditest

# btrfs filesystem df .
Data: total=28.22GB, used=14.25GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.50GB, used=1.16GB
Metadata: total=8.00MB, used=0.00

Any ideas what is going wrong here?

Thank you in advance, Clemens
