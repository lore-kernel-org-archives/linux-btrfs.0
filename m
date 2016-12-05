Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33192 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbcLEUfy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 15:35:54 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
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
 <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com> <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Dec 2016 12:35:52 -0800
Message-ID: <CA+55aFwC3nfmum6oPoBRU325CKjK-g3MuqW+bhq3+9DnE_4fgw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: multipart/mixed; boundary=001a1140b544e98c390542ef3b1e
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a1140b544e98c390542ef3b1e
Content-Type: text/plain; charset=UTF-8

Adding the scheduler people to the participants list, and re-attaching
the patch, because while this patch is internal to the VM code, the
issue itself is not.

There might well be other cases where somebody goes "wake_up_all()"
will wake everybody up, so I can put the wait queue head on the stack,
and then after I've woken people up I can return".

Ingo/PeterZ: the reason that does *not* work is that "wake_up_all()"
does make sure that everybody is woken up, but the usual autoremove
wake function only removes the wakeup entry if the process was woken
up by that particular wakeup. If something else had woken it up, the
entry remains on the list, and the waker in this case returned with
the wait head still containing entries.

Which is deadly when the wait queue head is on the stack.

So I'm wondering if we should make that "synchronous_wake_function()"
available generally, and maybe introduce a DEFINE_WAIT_SYNC() helper
that uses it.

Of course, I'm really hoping that this shmem.c use is the _only_ such
case.  But I doubt it.

Comments?

Note for Ingo and Peter: this patch has not been tested at all. But
Vegard did test an earlier patch of mine that just verified that yes,
the issue really was that wait queue entries remained on the wait
queue head just as we were about to return and free it.

           Linus


On Mon, Dec 5, 2016 at 12:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, can you try this patch instead? It should actually cause the
> wake_up_all() to always remove all entries, and thus the WARN_ON()
> should no longer happen (and I removed the "list_del()" hackery).
>
>                        Linus

--001a1140b544e98c390542ef3b1e
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwcj8nhg1

ZGlmZiAtLWdpdCBhL21tL3NobWVtLmMgYi9tbS9zaG1lbS5jCmluZGV4IDE2NmViZjVkMmJjZS4u
MTdiZWI0NGU5ZjRmIDEwMDY0NAotLS0gYS9tbS9zaG1lbS5jCisrKyBiL21tL3NobWVtLmMKQEAg
LTE4NDgsNiArMTg0OCwxOSBAQCBhbGxvY19ub2h1Z2U6CQlwYWdlID0gc2htZW1fYWxsb2NfYW5k
X2FjY3RfcGFnZShnZnAsIGluZm8sIHNiaW5mbywKIAlyZXR1cm4gZXJyb3I7CiB9CiAKKy8qCisg
KiBUaGlzIGlzIGxpa2UgYXV0b3JlbW92ZV93YWtlX2Z1bmN0aW9uLCBidXQgaXQgcmVtb3ZlcyB0
aGUgd2FpdCBxdWV1ZQorICogZW50cnkgdW5jb25kaXRpb25hbGx5IC0gZXZlbiBpZiBzb21ldGhp
bmcgZWxzZSBoYWQgYWxyZWFkeSB3b2tlbiB0aGUKKyAqIHRhcmdldC4KKyAqLworc3RhdGljIGlu
dCBzeW5jaHJvbm91c193YWtlX2Z1bmN0aW9uKHdhaXRfcXVldWVfdCAqd2FpdCwgdW5zaWduZWQg
bW9kZSwgaW50IHN5bmMsIHZvaWQgKmtleSkKK3sKKwlpbnQgcmV0ID0gZGVmYXVsdF93YWtlX2Z1
bmN0aW9uKHdhaXQsIG1vZGUsIHN5bmMsIGtleSk7CisJbGlzdF9kZWxfaW5pdCgmd2FpdC0+dGFz
a19saXN0KTsKKwlyZXR1cm4gcmV0OworfQorCisKIHN0YXRpYyBpbnQgc2htZW1fZmF1bHQoc3Ry
dWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHN0cnVjdCB2bV9mYXVsdCAqdm1mKQogewogCXN0cnVj
dCBpbm9kZSAqaW5vZGUgPSBmaWxlX2lub2RlKHZtYS0+dm1fZmlsZSk7CkBAIC0xODgzLDcgKzE4
OTYsNyBAQCBzdGF0aWMgaW50IHNobWVtX2ZhdWx0KHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1h
LCBzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKIAkJICAgIHZtZi0+cGdvZmYgPj0gc2htZW1fZmFsbG9j
LT5zdGFydCAmJgogCQkgICAgdm1mLT5wZ29mZiA8IHNobWVtX2ZhbGxvYy0+bmV4dCkgewogCQkJ
d2FpdF9xdWV1ZV9oZWFkX3QgKnNobWVtX2ZhbGxvY193YWl0cTsKLQkJCURFRklORV9XQUlUKHNo
bWVtX2ZhdWx0X3dhaXQpOworCQkJREVGSU5FX1dBSVRfRlVOQyhzaG1lbV9mYXVsdF93YWl0LCBz
eW5jaHJvbm91c193YWtlX2Z1bmN0aW9uKTsKIAogCQkJcmV0ID0gVk1fRkFVTFRfTk9QQUdFOwog
CQkJaWYgKCh2bWYtPmZsYWdzICYgRkFVTFRfRkxBR19BTExPV19SRVRSWSkgJiYKQEAgLTI2NjUs
NiArMjY3OCw3IEBAIHN0YXRpYyBsb25nIHNobWVtX2ZhbGxvY2F0ZShzdHJ1Y3QgZmlsZSAqZmls
ZSwgaW50IG1vZGUsIGxvZmZfdCBvZmZzZXQsCiAJCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7
CiAJCWlub2RlLT5pX3ByaXZhdGUgPSBOVUxMOwogCQl3YWtlX3VwX2FsbCgmc2htZW1fZmFsbG9j
X3dhaXRxKTsKKwkJV0FSTl9PTl9PTkNFKCFsaXN0X2VtcHR5KCZzaG1lbV9mYWxsb2Nfd2FpdHEu
dGFza19saXN0KSk7CiAJCXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAkJZXJyb3IgPSAw
OwogCQlnb3RvIG91dDsK
--001a1140b544e98c390542ef3b1e--
