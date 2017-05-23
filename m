Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41335 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031104AbdEWVxX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 17:53:23 -0400
Date: Tue, 23 May 2017 14:53:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Message-ID: <20170523215321.GO29894@merlins.org>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com> <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com> <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net> <20170523170025.sweg3oyzs5f2jxca@merlins.org> <CAJCQCtT1QKpPWmoKhM-LTN3bweW-Yq=fGMjJU+b4wW+h98ydJg@mail.gmail.com> <20170523214943.GN29894@merlins.org> <CAJCQCtTkszst4EqWRJrdpgyHm6=2j9WntecUiLzNY8=CZ_5Jww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtTkszst4EqWRJrdpgyHm6=2j9WntecUiLzNY8=CZ_5Jww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 23, 2017 at 03:51:43PM -0600, Chris Murphy wrote:
> On Tue, May 23, 2017 at 3:49 PM, Marc MERLIN <marc@merlins.org> wrote:
> > On Tue, May 23, 2017 at 03:38:01PM -0600, Chris Murphy wrote:
> >> > I've tried an ext4 to btrfs conversion 3 times in the last 3 years, it
> >> > never worked properly any of those times, sadly.
> >>
> >> Since the 4.6 total rewrite? There are also recent bug fixes related
> >> to convert in the changelog, it should be working now and if there are
> >> problems Qu is probably interested in getting them fixed.
> >
> > It was a 4.9 kernel from debian.
> 
> Convert is done by user space code, so btrfs-progs version is relevant.

Sigh, I think you found the issue. That system only had btrfs-tools 4.4 :(

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
