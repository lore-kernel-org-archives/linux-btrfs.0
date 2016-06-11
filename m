Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36164 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbcFKXKM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 19:10:12 -0400
Received: by mail-io0-f173.google.com with SMTP id n127so93407413iof.3
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 16:10:11 -0700 (PDT)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Sun, 12 Jun 2016 01:09:51 +0200
Message-ID: <CAGwxe4j4VQ522QBFriD3fmd8irhR6R=pqDGw+HJcQC8FBbsvhA@mail.gmail.com>
Subject: "parent transid verify failed"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I am getting some "parent transid verify failed"-errors. Is there any
way to find out what's affected? Are these errors in metadata, data or
both - and if they are errors in the data: How can I find out which
files are affected?

Regards,
Tobias
