Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40457 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab2GSBmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 21:42:42 -0400
Received: by lbbgm6 with SMTP id gm6so2895946lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 18:42:41 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Jul 2012 11:42:40 +1000
Message-ID: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
Subject: Very slow samba file transfer speed... any ideas ?
From: Shavi N <shavi64@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have btrfs volume, shared via samba.
I have a directory of documents that I want to backup on my server.
win7 reports a maximum of ~3.10MB/s transfer
transferring the same directory on a ext4 samba share I get 25MB/s +

Any ideas?
Is it like that because of how btrfs works and is setup?

Thanks,
