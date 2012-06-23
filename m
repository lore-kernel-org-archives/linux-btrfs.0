Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63969 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2FWJPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 05:15:55 -0400
Received: by eaak11 with SMTP id k11so798213eaa.19
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 02:15:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Jun 2012 11:15:54 +0200
Message-ID: <CAELiMBOxo+R+A-wcHmxJsVpOaf+DRS4AG91ENnYTiNBQJKvXXA@mail.gmail.com>
Subject: Tool to calc. 4k / 16k utilization / overhead
From: Sandra Schlichting <littlesandra88@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

When having a non-btrfs fs and want to migrate to btrfs, it is hard to
know which sector size to choose in terms of disk utilization and
speed.

So I would like to make a script that scans the non-btrfs fs's
directory structure to find all file sizes and calculate how much
space these would take on btrfs 4k and 16k sector size.

Can anyone help me with a formulae to calculate this for a file?

It doesn't have to be exact, just enough to make a decision between 4k and 16k.

Best regards,
Sandra
