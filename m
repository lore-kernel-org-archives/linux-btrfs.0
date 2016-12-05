Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34278 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbcLERzJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 12:55:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com> <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Dec 2016 09:55:07 -0800
Message-ID: <CA+55aFxeWe2VQaW30qGR0syiZ75jSwFwg3Ac+wS20KDtf5UKNw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: multipart/mixed; boundary=94eb2c0ef0e209e7520542ecfd94
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--94eb2c0ef0e209e7520542ecfd94
Content-Type: text/plain; charset=UTF-8

On Mon, Dec 5, 2016 at 9:09 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> The warning shows that it made it past the list_empty_careful() check
> in finish_wait() but then bugs out on the &wait->task_list
> dereference.
>
> Anything stick out?

I hate that shmem waitqueue garbage. It's really subtle.

I think the problem is that "wake_up_all()" in shmem_fallocate()
doesn't necessarily wake up everything. It wakes up TASK_NORMAL -
which does include TASK_UNINTERRUPTIBLE, but doesn't actually mean
"everything on the list".

I think that what happens is that the waiters somehow move from
TASK_UNINTERRUPTIBLE to TASK_RUNNING early, and this means that
wake_up_all() will ignore them, leave them on the list, and now that
list on stack is no longer empty at the end.

And the way *THAT* can happen is that the task is on some *other*
waitqueue as well, and that other waiqueue wakes it up. That's not
impossible, you can certainly have people on wait-queues that still
take faults.

Or somebody just uses a directed wake_up_process() or something.

Since you apparently can recreate this fairly easily, how about trying
this stupid patch?

NOTE! This is entirely untested. I may have screwed this up entirely.
You get the idea, though - just remove the wait queue head from the
list - the list entries stay around, but nothing points to the stack
entry (that we're going to free) any more.

And add the warning to see if this actually ever triggers (and because
I'd like to see the callchain when it does, to see if it's another
waitqueue somewhere or what..)

                  Linus

--94eb2c0ef0e209e7520542ecfd94
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwcdn84y0

ZGlmZiAtLWdpdCBhL21tL3NobWVtLmMgYi9tbS9zaG1lbS5jCmluZGV4IDE2NmViZjVkMmJjZS4u
YTgwMTQ4YjQzNDc2IDEwMDY0NAotLS0gYS9tbS9zaG1lbS5jCisrKyBiL21tL3NobWVtLmMKQEAg
LTI2NjUsNiArMjY2NSw4IEBAIHN0YXRpYyBsb25nIHNobWVtX2ZhbGxvY2F0ZShzdHJ1Y3QgZmls
ZSAqZmlsZSwgaW50IG1vZGUsIGxvZmZfdCBvZmZzZXQsCiAJCXNwaW5fbG9jaygmaW5vZGUtPmlf
bG9jayk7CiAJCWlub2RlLT5pX3ByaXZhdGUgPSBOVUxMOwogCQl3YWtlX3VwX2FsbCgmc2htZW1f
ZmFsbG9jX3dhaXRxKTsKKwkJaWYgKFdBUk5fT05fT05DRSghbGlzdF9lbXB0eSgmc2htZW1fZmFs
bG9jX3dhaXRxLnRhc2tfbGlzdCkpKQorCQkJbGlzdF9kZWwoJnNobWVtX2ZhbGxvY193YWl0cS50
YXNrX2xpc3QpOwogCQlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7CiAJCWVycm9yID0gMDsK
IAkJZ290byBvdXQ7Cg==
--94eb2c0ef0e209e7520542ecfd94--
