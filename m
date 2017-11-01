Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:52199 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753212AbdKALbs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 07:31:48 -0400
Received: by mail-wm0-f45.google.com with SMTP id b9so4335742wmh.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 04:31:47 -0700 (PDT)
Message-ID: <1509535904.1662.93.camel@gmail.com>
Subject: Re: Reasonable amount of snapshots
From: ST <smntov@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 01 Nov 2017 13:31:44 +0200
In-Reply-To: <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
References: <1509534294.1662.91.camel@gmail.com>
         <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2017-11-01 at 19:17 +0800, Qu Wenruo wrote:
> 
> On 2017年11月01日 19:04, ST wrote:
> > Hello,
> > 
> > I read in different places that one should keep amount of snapshots low
> > - around 15-20. My question - is this limitation on total number of
> > snapshots on the system or only on related (parent<->child) chain of
> > snapshots?
> 
> Independent subvolume doesn't count, and it's filesystem based.
> 
> So only snapshots (with source exists, and still shares a lot of trees
> with source) counts.
> 
> And if you have multiple btrfs fses, then the count should be based on
> each fs.
> 
> > What I want to do is the following: create (and then rotate) last 7
> > daily snapshots (and maybe 4 weekly) for each user in his /home dir.
> > For
> > around 100 users. So if limitation is only on related snapshots then I'm
> > OK since only each 7 (or maybe 7+4) of them are related which is well
> > under the 15-20 limit. However in total there could be 700 snapshots. So
> > what is true?
> 
> You're OK since independent subvolumes won't cause too much stress for
> backref walk.
> 
> The only thing you may need to consider is to limit the ability to
> reflink data between subvolumes.
> Like cp --reflink or even offline dedupe.

Thank you very much! How can I limit this ability? (I'm on Debian9)

All the best!

