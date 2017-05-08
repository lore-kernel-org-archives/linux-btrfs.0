Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36268 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdEHP2t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 11:28:49 -0400
Received: by mail-pf0-f196.google.com with SMTP id v14so10230359pfd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 08:28:49 -0700 (PDT)
Date: Mon, 8 May 2017 11:28:42 -0400
From: Sanidhya Solanki <lkml.page@gmail.com>
To: Alexandru Guzu <alexguzu@gmail.com>
Cc: Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Message-ID: <20170508112617.7e33bed6@ad>
In-Reply-To: <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
        <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com>
        <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 8 May 2017 10:16:44 -0400
Alexandru Guzu <alexguzu@gmail.com> wrote:
 
> Sean, how would you approach the copy of the data back and forth if
> the OS is on it? Would a Send-receive and then back work?

You could use a Live-USB and then just dd it to remote or attached storage, if
you want to be absolutely sure the data is not affected.

SS
