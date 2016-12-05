Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36637 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbcLEUKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 15:10:31 -0500
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
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Dec 2016 12:10:29 -0800
Message-ID: <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: multipart/mixed; boundary=001a113efc341e88880542eee1fa
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a113efc341e88880542eee1fa
Content-Type: text/plain; charset=UTF-8

On Mon, Dec 5, 2016 at 11:11 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> ------------[ cut here ]------------
> WARNING: CPU: 22 PID: 14012 at mm/shmem.c:2668 shmem_fallocate+0x9a7/0xac0

Ok, good. So that's confirmed as the cause of this problem.

And the call chain that I wanted is obviously completely
uninteresting, because it's call cghain on the other side (the page
fault side) that would show the nested wake queue behavior. I was just
being stupid about it.

I wonder if we have any other places where we just blithely assume
that "wake_up_all()" will actually empty the whole wait queue. It's
_usually_ true, but as noted, nested waiting does happen.

Anyway, can you try this patch instead? It should actually cause the
wake_up_all() to always remove all entries, and thus the WARN_ON()
should no longer happen (and I removed the "list_del()" hackery).

                       Linus

--001a113efc341e88880542eee1fa
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwcih6wv1

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
--001a113efc341e88880542eee1fa--
