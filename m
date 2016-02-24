Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33745 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbcBXAkx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 19:40:53 -0500
Received: by mail-io0-f171.google.com with SMTP id z135so10589928iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 16:40:53 -0800 (PST)
Received: from gmail.com (blk-11-122-84.eastlink.ca. [76.11.122.84])
        by smtp.gmail.com with ESMTPSA id l9sm12304374igx.4.2016.02.23.16.40.51
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Feb 2016 16:40:52 -0800 (PST)
Date: Tue, 23 Feb 2016 20:40:46 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Input/Output errors
Message-ID: <20160224004045.GA20632@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running btrfs on DM-Crypt Luks running on LVM.

Occasionally I get files that are unreadable for some period of time.
Attempting to read from them results in an 

Input/output error

Sometimes they'll come back on their own, and sometimes a scrub seems to
help, but sometimes I just have to delete them.

Nothing shows up in dmesg when these occur, and I can't predict which
files it will be, or what causes it.

It's currently happening running 4.4.1-2-ARCH, but I've seen the same
thing for many previous kernel versions.

Does anyone have any suggestions?

