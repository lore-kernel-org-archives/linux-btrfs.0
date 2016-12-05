Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33526 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbcLESZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 13:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrX9+eS3KYdN2UBvmBsMhKr3f-PBSC8UHqrnK8WhE6_guw@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CALCETrX9+eS3KYdN2UBvmBsMhKr3f-PBSC8UHqrnK8WhE6_guw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Dec 2016 10:25:46 -0800
Message-ID: <CA+55aFzPPz9E6=0qGO2QbTx6E0hWogORgQ-0NSsmw9jmLLwSwQ@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Andy Lutomirski <luto@kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 5, 2016 at 10:11 AM, Andy Lutomirski <luto@kernel.org> wrote:
>
> So your kernel has been smp-alternatived.  That 3e comes from
> alternatives_smp_unlock.  If you're running on SMP with UP
> alternatives, things will break.

I'm assuming he's just running in a VM with a single CPU.

The problem that I pointed out with assuming wake_up_all() actually
removes all wait queue entries does not depend on SMP. The race is
much more fundamental and long-lived.

               Linus
