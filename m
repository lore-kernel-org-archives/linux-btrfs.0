Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34923 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcLEULA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 15:11:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
 <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
 <CA+55aFxeWe2VQaW30qGR0syiZ75jSwFwg3Ac+wS20KDtf5UKNw@mail.gmail.com> <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 5 Dec 2016 21:10:57 +0100
Message-ID: <CAOMGZ=G_wM13ikKt7cTUt1gppsf4TAzFwg2kybUYMvEuzJyj2w@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 December 2016 at 20:11, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 5 December 2016 at 18:55, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Dec 5, 2016 at 9:09 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Since you apparently can recreate this fairly easily, how about trying
>> this stupid patch?
>>
>> NOTE! This is entirely untested. I may have screwed this up entirely.
>> You get the idea, though - just remove the wait queue head from the
>> list - the list entries stay around, but nothing points to the stack
>> entry (that we're going to free) any more.
>>
>> And add the warning to see if this actually ever triggers (and because
>> I'd like to see the callchain when it does, to see if it's another
>> waitqueue somewhere or what..)
>
> ------------[ cut here ]------------
> WARNING: CPU: 22 PID: 14012 at mm/shmem.c:2668 shmem_fallocate+0x9a7/0xac0
> Kernel panic - not syncing: panic_on_warn set ...

So I noticed that panic_on_warn just after sending the email and I've
been waiting for it it to trigger again.

The warning has triggered twice more without panic_on_warn set and I
haven't seen any crash yet.


Vegard
