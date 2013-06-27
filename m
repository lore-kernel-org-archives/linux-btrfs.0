Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36863 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3F0Nyn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 09:54:43 -0400
Received: by mail-bk0-f51.google.com with SMTP id ji1so321077bkc.24
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 06:54:42 -0700 (PDT)
Received: from [10.0.1.28] ([109.205.68.194])
        by mx.google.com with ESMTPSA id kz11sm1467744bkb.11.2013.06.27.06.54.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 27 Jun 2013 06:54:41 -0700 (PDT)
Message-ID: <51CC4419.6030108@gmail.com>
Date: Thu, 27 Jun 2013 15:54:33 +0200
From: =?ISO-8859-1?Q?St=E9phane_Mutz?= <stephane.mutz@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Problem with btrfsck / couurpted filesystem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to fix a btrfs file system. BTRFSCK reports errors in the
extend tree.
I've tryong to use --repair option but it ended up with an assertion
failure.

I'm also trying to understand how the filesystem can have become corrupted.
I'm running Ubuntu 12.10.

Any suggestion on ways to fix the problem would be really appreciated.

Regards, Stéphane.
