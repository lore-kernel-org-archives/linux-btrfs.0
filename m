Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33728 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbcKBLKd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 07:10:33 -0400
Received: by mail-qk0-f180.google.com with SMTP id x190so11642160qkb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 04:10:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: badara+ml@gmail.com
In-Reply-To: <pan$af500$48f5b197$b20e4aa3$ec6e2ea2@cox.net>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
 <pan$af500$48f5b197$b20e4aa3$ec6e2ea2@cox.net>
From: Ahmed Badr <badara+ml@gmail.com>
Date: Wed, 2 Nov 2016 13:09:51 +0200
Message-ID: <CAN5=xXkE4rq54RiEjUcT8B16aHujsfC3ky2uYpKB+YqOUPKGNg@mail.gmail.com>
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 2, 2016 at 8:03 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Btrfs tends to have scaling issues if you let the number of snapshots get
> too high.  Try to keep it under 300 snapshots per subvolume (combined
> between all tools) if at all possible, and if your use-case makes it easy
> enough, try to keep it under 100 snapshots per subvolume.  Definitely
> don't let it get into the thousands of snapshots per subvolume, or
> commands such as btrfs balance and btrfs check will take MUCH longer and
> use MANY TIMES more memory.

Thanks for the heads up on that. I didn't find this info anywhere so I
will  definitely do that. I don't think I'll even need that many
snapshots in the first place. Since this is a dedicated backup server
that I'll set and forget, I'll keep a snapshot every couple of hours
for the first day and a daily snapshot for a week. I'll be backing the
root partition on another computer anyway.

Since I'll be trying out several backup software to see which one
suits me best I'll use Snapper prior to installing each software. I'm
very excited since Btrfs will make this super easy
