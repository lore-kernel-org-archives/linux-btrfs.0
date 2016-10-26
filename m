Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36583 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935204AbcJZWWf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 18:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
References: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk> <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk> <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk> <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk> <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk> <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com> <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2016 15:21:53 -0700
Message-ID: <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Chris Mason <clm@fb.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: multipart/mixed; boundary=94eb2c033370729385053fcc0d65
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--94eb2c033370729385053fcc0d65
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 26, 2016 at 2:52 PM, Chris Mason <clm@fb.com> wrote:
>
> This one is special because CONFIG_VMAP_STACK is not set.  Btrfs triggers in < 10 minutes.
> I've done 30 minutes each with XFS and Ext4 without luck.

Ok, see the email I wrote that crossed yours - if it's really some
list corruption on ctx->rq_list due to some locking problem, I really
would expect CONFIG_VMAP_STACK to be entirely irrelevant, except
perhaps from a timing standpoint.

> WARNING: CPU: 6 PID: 4481 at lib/list_debug.c:33 __list_add+0xbe/0xd0
> list_add corruption. prev->next should be next (ffffe8ffffd80b08), but was ffff88012b65fb88. (prev=ffff880128c8d500).
> Modules linked in: crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper i2c_piix4 cryptd i2c_core virtio_net serio_raw floppy button pcspkr sch_fq_codel autofs4 virtio_blk
> CPU: 6 PID: 4481 Comm: dbench Not tainted 4.9.0-rc2-15419-g811d54d #319
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 04/01/2014
>  ffff880104eff868 ffffffff814fde0f ffffffff8151c46e ffff880104eff8c8
>  ffff880104eff8c8 0000000000000000 ffff880104eff8b8 ffffffff810648cf
>  ffff880128cab2c0 000000213fc57c68 ffff8801384e8928 ffff880128cab180
> Call Trace:
>  [<ffffffff814fde0f>] dump_stack+0x53/0x74
>  [<ffffffff8151c46e>] ? __list_add+0xbe/0xd0
>  [<ffffffff810648cf>] __warn+0xff/0x120
>  [<ffffffff810649a9>] warn_slowpath_fmt+0x49/0x50
>  [<ffffffff8151c46e>] __list_add+0xbe/0xd0
>  [<ffffffff814dec38>] blk_sq_make_request+0x388/0x580
>  [<ffffffff814d5444>] generic_make_request+0x104/0x200

Well, it's very consistent, I have to say. So I really don't think
this is random corruption.

Could you try the attached patch? It adds a couple of sanity tests:

 - a number of tests to verify that 'rq->queuelist' isn't already on
some queue when it is added to a queue

 - one test to verify that rq->mq_ctx is the same ctx that we have locked.

I may be completely full of shit, and this patch may be pure garbage
or "obviously will never trigger", but humor me.

          Linus

--94eb2c033370729385053fcc0d65
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iurhkann0

IGJsb2NrL2Jsay1tcS5jIHwgOSArKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlv
bnMoKykKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstbXEuYyBiL2Jsb2NrL2Jsay1tcS5jCmluZGV4
IGRkYzJlZWQ2NDc3MS4uNGY1NzVkZTdmZGQwIDEwMDY0NAotLS0gYS9ibG9jay9ibGstbXEuYwor
KysgYi9ibG9jay9ibGstbXEuYwpAQCAtNTIxLDYgKzUyMSw4IEBAIHZvaWQgYmxrX21xX2FkZF90
b19yZXF1ZXVlX2xpc3Qoc3RydWN0IHJlcXVlc3QgKnJxLCBib29sIGF0X2hlYWQpCiAJICovCiAJ
QlVHX09OKHJxLT5jbWRfZmxhZ3MgJiBSRVFfU09GVEJBUlJJRVIpOwogCitXQVJOX09OX09OQ0Uo
IWxpc3RfZW1wdHkoJnJxLT5xdWV1ZWxpc3QpKTsKKwogCXNwaW5fbG9ja19pcnFzYXZlKCZxLT5y
ZXF1ZXVlX2xvY2ssIGZsYWdzKTsKIAlpZiAoYXRfaGVhZCkgewogCQlycS0+Y21kX2ZsYWdzIHw9
IFJFUV9TT0ZUQkFSUklFUjsKQEAgLTgzOCw2ICs4NDAsNyBAQCBzdGF0aWMgdm9pZCBfX2Jsa19t
cV9ydW5faHdfcXVldWUoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgpCiAJCQlxdWV1ZWQrKzsK
IAkJCWJyZWFrOwogCQljYXNlIEJMS19NUV9SUV9RVUVVRV9CVVNZOgorV0FSTl9PTl9PTkNFKCFs
aXN0X2VtcHR5KCZycS0+cXVldWVsaXN0KSk7CiAJCQlsaXN0X2FkZCgmcnEtPnF1ZXVlbGlzdCwg
JnJxX2xpc3QpOwogCQkJX19ibGtfbXFfcmVxdWV1ZV9yZXF1ZXN0KHJxKTsKIAkJCWJyZWFrOwpA
QCAtMTAzNCw2ICsxMDM3LDggQEAgc3RhdGljIGlubGluZSB2b2lkIF9fYmxrX21xX2luc2VydF9y
ZXFfbGlzdChzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwKIAogCXRyYWNlX2Jsb2NrX3JxX2lu
c2VydChoY3R4LT5xdWV1ZSwgcnEpOwogCitXQVJOX09OX09OQ0UoIWxpc3RfZW1wdHkoJnJxLT5x
dWV1ZWxpc3QpKTsKKwogCWlmIChhdF9oZWFkKQogCQlsaXN0X2FkZCgmcnEtPnF1ZXVlbGlzdCwg
JmN0eC0+cnFfbGlzdCk7CiAJZWxzZQpAQCAtMTEzNyw2ICsxMTQyLDcgQEAgdm9pZCBibGtfbXFf
Zmx1c2hfcGx1Z19saXN0KHN0cnVjdCBibGtfcGx1ZyAqcGx1ZywgYm9vbCBmcm9tX3NjaGVkdWxl
KQogCQkJZGVwdGggPSAwOwogCQl9CiAKK1dBUk5fT05fT05DRSghbGlzdF9lbXB0eSgmcnEtPnF1
ZXVlbGlzdCkpOwogCQlkZXB0aCsrOwogCQlsaXN0X2FkZF90YWlsKCZycS0+cXVldWVsaXN0LCAm
Y3R4X2xpc3QpOwogCX0KQEAgLTExNzIsNiArMTE3OCw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBi
bGtfbXFfbWVyZ2VfcXVldWVfaW8oc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgsCiAJCWJsa19t
cV9iaW9fdG9fcmVxdWVzdChycSwgYmlvKTsKIAkJc3Bpbl9sb2NrKCZjdHgtPmxvY2spOwogaW5z
ZXJ0X3JxOgorV0FSTl9PTl9PTkNFKHJxLT5tcV9jdHggIT0gY3R4KTsKIAkJX19ibGtfbXFfaW5z
ZXJ0X3JlcXVlc3QoaGN0eCwgcnEsIGZhbHNlKTsKIAkJc3Bpbl91bmxvY2soJmN0eC0+bG9jayk7
CiAJCXJldHVybiBmYWxzZTsKQEAgLTEzMjYsNiArMTMzMyw3IEBAIHN0YXRpYyBibGtfcWNfdCBi
bGtfbXFfbWFrZV9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgYmlvICpi
aW8pCiAJCQkJb2xkX3JxID0gc2FtZV9xdWV1ZV9ycTsKIAkJCQlsaXN0X2RlbF9pbml0KCZvbGRf
cnEtPnF1ZXVlbGlzdCk7CiAJCQl9CitXQVJOX09OX09OQ0UoIWxpc3RfZW1wdHkoJnJxLT5xdWV1
ZWxpc3QpKTsKIAkJCWxpc3RfYWRkX3RhaWwoJnJxLT5xdWV1ZWxpc3QsICZwbHVnLT5tcV9saXN0
KTsKIAkJfSBlbHNlIC8qIGlzX3N5bmMgKi8KIAkJCW9sZF9ycSA9IHJxOwpAQCAtMTQxMiw2ICsx
NDIwLDcgQEAgc3RhdGljIGJsa19xY190IGJsa19zcV9tYWtlX3JlcXVlc3Qoc3RydWN0IHJlcXVl
c3RfcXVldWUgKnEsIHN0cnVjdCBiaW8gKmJpbykKIAkJCXRyYWNlX2Jsb2NrX3BsdWcocSk7CiAJ
CX0KIAorV0FSTl9PTl9PTkNFKCFsaXN0X2VtcHR5KCZycS0+cXVldWVsaXN0KSk7CiAJCWxpc3Rf
YWRkX3RhaWwoJnJxLT5xdWV1ZWxpc3QsICZwbHVnLT5tcV9saXN0KTsKIAkJcmV0dXJuIGNvb2tp
ZTsKIAl9Cg==
--94eb2c033370729385053fcc0d65--
