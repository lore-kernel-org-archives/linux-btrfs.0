Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39962 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2G2TN7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jul 2012 15:13:59 -0400
Received: by lbbgm6 with SMTP id gm6so3145360lbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jul 2012 12:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120729T205902-38@post.gmane.org>
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it>
 <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it>
 <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Sun, 29 Jul 2012 14:13:38 -0500
Message-ID: <CAGAVQTFADbS95X9NbtOBx7m=R3tXB1exauQtSpPfBc2m72tNqg@mail.gmail.com>
Subject: Re: severe hardlink bug
To: Konstantin Dmitriev <ksee.zelgadis@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 29, 2012 at 2:02 PM, Konstantin Dmitriev
<ksee.zelgadis@gmail.com> wrote:
> Dipl.-Ing. Michael Niederle <mniederle <at> gmx.at> writes:
>
>> I reinstalled over 700 packages - plt-scheme beeing the only one failing due to
>> the btrfs link restriction.
>>
>
> I have hit the same issue - tried to run BackupPC with a pool on btrfs
> filesystem. After some time the error of "too many links (31)" appeared to me.
> Now I'm forced to migrate to some other filesystem...

btrfs only fails when you have hundreds of hardlinks to the same file
in the *same* directory ... certainly not a standard use case.

use snapshots to your advantage:
 - snap source
 - rsync --inplace source to target (with some other opts that have
been discussed on list)
 - snap target
 - {rinse-and-repeat-in-24-hrs}

-- 

C Anthony
