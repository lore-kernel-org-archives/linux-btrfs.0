Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43783 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753906AbeFTDWM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 23:22:12 -0400
MIME-Version: 1.0
References: <1528804105-24100-1-git-send-email-allen.lkml@gmail.com>
 <b40f794f-16b6-0369-cb0d-bbb5b12aa46a@suse.com> <20180619131041.6v3blgpegciu6fyi@twin.jikos.cz>
In-Reply-To: <20180619131041.6v3blgpegciu6fyi@twin.jikos.cz>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 20 Jun 2018 08:51:59 +0530
Message-ID: <CAOMdWS+pc5EQ6DNKz3eF2U=N_omV6q5H6L6=sWLjEKXKA9D8iQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: stop using get_seconds()
To: dsterba@suse.cz, nborisov@suse.com, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, jbackik@fb.com, dsterba@suse.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >
> > On 12.06.2018 14:48, Allen Pais wrote:
> > > The get_seconds() function is deprecated as it truncates
> > > the timestamp to 32 bits. Change to either ktime_get_seconds()
> > > or ktime_get_real_seconds()
> >
> > nit: In your patch you are only changing them to get-real-seconds. So
> > the "ktime_get_seconds() or" part of the changelog is unnecessary.
>
> Updated, and changed the subject line to "btrfs: replace get_seconds with
> new 64bit time API"

Thank you.
