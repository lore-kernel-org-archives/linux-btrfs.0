Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58036 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab2FZQF4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 12:05:56 -0400
Received: by dady13 with SMTP id y13so86057dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 09:05:56 -0700 (PDT)
Message-ID: <1340726750.3124.2.camel@localhost>
Subject: inode cache slows down startup of system
From: Maciej Piechotka <uzytkownik2@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Tue, 26 Jun 2012 09:05:50 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have interpreted sentence "This option may slow down your system at
first run." as "it might slow down after first time you boot". However
it seems to take long time once every tenth boot or so.

Is it error in documentation or bug in btrfs?

Best regards

