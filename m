Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:40686 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbeEBTpm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 15:45:42 -0400
Received: by mail-pg0-f44.google.com with SMTP id l2-v6so11368969pgc.7
        for <linux-btrfs@vger.kernel.org>; Wed, 02 May 2018 12:45:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMosweg23md=bTDkKYyOX68DrghCa4sDeBGUJ6nJyK2N9mJhFA@mail.gmail.com>
References: <CAMoswehF-GGV-yi_5fFnuvmZWVkeb71F7OcgOgr80r1F-=R_tg@mail.gmail.com>
 <CAA7pwKOGS1MfwiO7AvfGPMP5ddhA6EMF+u3eZ+yE++RYvM=bfg@mail.gmail.com>
 <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com>
 <20edd001-152b-edbb-548b-dcb2647d828a@gmx.com> <CAMosweg23md=bTDkKYyOX68DrghCa4sDeBGUJ6nJyK2N9mJhFA@mail.gmail.com>
From: Paul Richards <paul.richards@gmail.com>
Date: Wed, 2 May 2018 20:45:41 +0100
Message-ID: <CAMoswegro+xDfdnr_KPqwVSSWxYD8qTsA9b9dkE=4tCFYZaWOw@mail.gmail.com>
Subject: Re: fs/btrfs/ctree.h:1559 warnings
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 May 2018 at 20:43, Paul Richards <paul.richards@gmail.com> wrote:
> The issue I have now is that the filesystem cannot be unmounted.
> "umount" reports "target is busy", but I cannot find anything relevant
> with "lsof" or "fuser" (this is a very quiet home NAS).  Is this
> something related to the resize?
>

Oh please ignore me.  I forgot to unmount "/storage/.snapshots" before
"/storage".

Everything looks fine.
