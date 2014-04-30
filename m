Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64159 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbaD3SQL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 14:16:11 -0400
Received: by mail-qc0-f171.google.com with SMTP id c9so2303782qcz.16
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 11:16:10 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Apr 2014 20:16:10 +0200
Message-ID: <CAFz=ag4x7TY5AYpx-Oubi6S-9xR7bXRBYK3zLihMpgpmSVOi3w@mail.gmail.com>
Subject: btrfs on bcache
From: Felix Homann <linuxaudio@showlabor.de>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
a couple of months ago there has been some discussion about issues
when using btrfs on bcache:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018

>From looking at the mailing list archives I cannot tell whether or not
this issue has been resolved in current kernels from either bcache's
or btrfs' side.

Can anyone tell me what's the current state of this issue? Should it
be safe to use btrfs on bcache by now?

Thanks and kind regards,
Felix
