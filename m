Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:33760 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756097AbcH1VlY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 17:41:24 -0400
Received: by mail-ua0-f179.google.com with SMTP id l94so154809516ual.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 14:41:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c7cb948d-5831-7b97-937e-c21c5335e76c@googlemail.com>
References: <c7cb948d-5831-7b97-937e-c21c5335e76c@googlemail.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Sun, 28 Aug 2016 17:41:22 -0400
Message-ID: <CA+X5Wn6BPhSR4Zsjp9xOgOap=GXKE2bCcgFtbpouMJ2y+++Qwg@mail.gmail.com>
Subject: Re: btrfs send extremely slow (almost stuck)
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 28, 2016 at 12:15 PM, Oliver Freyermuth
<o.freyermuth@googlemail.com> wrote:
> For me, this means I have to stay with rsync backups, which are sadly incomplete since special FS attrs
> like "C" for nocow are not backed up.

Should be able to make a script that creates a textfile with lsattr
for every file.  Then either just leave that file as part of the
backup in case it's needed some day, or making a corresponding script
on the backup machine to restore those.
