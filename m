Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37486 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbcLFImJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 03:42:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMGZ=H6gAnMHkbLjHmSiCmcqvL7gK=_x0Aj-roErpdB5h8xxQ@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
 <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
 <CA+55aFxeWe2VQaW30qGR0syiZ75jSwFwg3Ac+wS20KDtf5UKNw@mail.gmail.com>
 <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com>
 <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
 <CA+55aFwC3nfmum6oPoBRU325CKjK-g3MuqW+bhq3+9DnE_4fgw@mail.gmail.com> <CAOMGZ=H6gAnMHkbLjHmSiCmcqvL7gK=_x0Aj-roErpdB5h8xxQ@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 6 Dec 2016 09:42:05 +0100
Message-ID: <CAOMGZ=Gi3g_ALFRv-WiDaRT0pR5EN04OUzCtLX8mARp3_Gwv5A@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 December 2016 at 22:33, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 5 December 2016 at 21:35, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Note for Ingo and Peter: this patch has not been tested at all. But
>> Vegard did test an earlier patch of mine that just verified that yes,
>> the issue really was that wait queue entries remained on the wait
>> queue head just as we were about to return and free it.
>
> The second patch has been running for 1h+ without any problems of any
> kind. I should typically have seen 2 crashes by now. I'll let it run
> overnight to be sure.

Alright, so nearly 12 hours later I don't see either the new warning
or the original crash at all, so feel free to add:

Tested-by: Vegard Nossum <vegard.nossum@oracle.com>.

That said, my 8 VMs had all panicked in some way due to OOMs (which is
new since v4.8), although some got page allocation stalls for >20s and
died because "khugepaged blocked for more than 120 seconds", others
got "Out of memory and no killable processes".


Vegard
