Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32797 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdDNRRR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 13:17:17 -0400
Received: by mail-yw0-f181.google.com with SMTP id l189so37522892ywb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 10:17:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGu9HqL=0VS+apM9r6CSRbxBcZzX5=HmF1K_51wYHyRbiw@mail.gmail.com>
References: <CAPktuGu9HqL=0VS+apM9r6CSRbxBcZzX5=HmF1K_51wYHyRbiw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Apr 2017 11:17:15 -0600
Message-ID: <CAJCQCtRbkt=o6doBd0ZG0XZfrhP4pBQsPCp573LiZU2RSZvuVQ@mail.gmail.com>
Subject: Re: Remounting read-write after error is not allowed
To: Alexandru Guzu <alexguzu@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can you ro mount it and:

btrfs fi show /mnt
btrfs fi df /mnt

And then next update the btrfs-progs to something newer like 4.9.2 or
4.10.2 and then do another 'btrfs check' without repair. And then
separately do it again with --mode=lowmem and post both sets of
results?


Chris Murphy
