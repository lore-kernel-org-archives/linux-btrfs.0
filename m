Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50208 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3GWNJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 09:09:46 -0400
Received: by mail-ob0-f175.google.com with SMTP id tb18so910858obb.34
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 06:09:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 16:09:45 +0300
Message-ID: <CAELSAVaARfuzb+rVU5EhUDWoUtEkv-p_vNUM4janOYjiL-ywwA@mail.gmail.com>
Subject: Bug 60608 - general protection fault: 0000 on btrfs_clean_one_deleted_snapshot+0x46/0xe3
From: Emil Karlson <jekarlson@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings

Encountered this bug on linux-3.11-rc2
https://bugzilla.kernel.org/show_bug.cgi?id=60608

Best Regards
