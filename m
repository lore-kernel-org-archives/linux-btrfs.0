Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42793 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3E0MyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 08:54:09 -0400
Received: by mail-qa0-f51.google.com with SMTP id ii15so958832qab.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 05:54:08 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 May 2013 15:54:08 +0300
Message-ID: <CADV-EXEA3MgspNXFqii3r4DADKSY8WSKWC1b3qx3_9mQZnDfFA@mail.gmail.com>
Subject: Is move/rename operation atomic?
From: Yevhen Kyriukha <kirgene@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Could you say is move/rename operation atomic?
I want to create a snapshot of subvolume and then rename it using "mv".
Is it safe on power failure?

Best regards,
Yevhen
