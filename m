Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:36322 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3EHVbc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 May 2013 17:31:32 -0400
Received: by mail-lb0-f195.google.com with SMTP id 13so593935lba.10
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 14:31:30 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 May 2013 23:31:30 +0200
Message-ID: <CAHgo1RLxWEyiOzJwJY-P8ZHgD3XqDM2xTJjAcv9o0WBfg6xN8g@mail.gmail.com>
Subject: Dup System chunks: is this the way to go?
From: "John ." <btrfsprob@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

Just to absolutely sure I am doing the right thing here I wanted to
ask you a question about system chunk duplication.

I performed the following command on my converted root volume to
enable metadata duplication:

root@host:~# btrfs balance start -mconvert=dup /
Done, had to relocate 1 out of 5 chunks

I noticed the system chunks were not in duplication mode, which would
be solved by running
