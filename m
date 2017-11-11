Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:47940 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdKKTLu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Nov 2017 14:11:50 -0500
Received: by mail-ot0-f172.google.com with SMTP id s4so1532496ote.4
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Nov 2017 11:11:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD8FQQ3XSsLt4XYdeMg7r3oX9WUerW27f8RMuKurjL4cpY8=1g@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
 <1484297967.48018.1508985286675@email.1and1.com> <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
 <CAJCQCtSR3aSe5OfEW3A2vxvv8j71pqTu-mOeYSvjaKhGogT=Jg@mail.gmail.com> <CAD8FQQ3XSsLt4XYdeMg7r3oX9WUerW27f8RMuKurjL4cpY8=1g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 11 Nov 2017 12:11:49 -0700
Message-ID: <CAJCQCtT+ZTi1BMchk5orGaraO2079SbSJterVMgVjO+fiYC1=Q@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Zak Kohler <y2k@y2kbugger.com>
Cc: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 11, 2017 at 11:27 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
> It seems that since the errors were due to a very slight instability in
> computer due to overclock, the online and offline scrub's causing different
> stresses or paths. Could it be that one is telling the drives to use some
> level of caching where the offline is explicitly tells it not to(or one of
> many similar scenarios)? There must be some line to draw about supporting
> faulty Hardware but I think having all forms of scrubbing in agreement must
> be within scope.

I think once you're in some non-deterministic state, all bets are off.
But I don't know anything about what physical parts of a CPU could
cause more or less error, or more or less determinism, based on code
differences.


-- 
Chris Murphy
