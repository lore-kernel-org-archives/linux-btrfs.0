Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:48779 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdJWSh1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 14:37:27 -0400
Received: by mail-it0-f52.google.com with SMTP id c3so7070666itc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 11:37:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi75xXn7gmAG5DNCH=drfVH0oboP_tDLWzHUQJtvzyDsjGQ@mail.gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com> <20170929162200.GP31640@twin.jikos.cz>
 <20171019153940.GL3521@twin.jikos.cz> <CAGqmi75Zz=RqsOymdFOHwHNE7X+2G3Viiitmq+ZROurBOon=FQ@mail.gmail.com>
 <20171020134511.GQ3521@suse.cz> <CAGqmi75xXn7gmAG5DNCH=drfVH0oboP_tDLWzHUQJtvzyDsjGQ@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 23 Oct 2017 21:36:45 +0300
Message-ID: <CAGqmi77Tvuf-XZP7ObgQBhGox++Vzm1P4ELHJYNDbeVF4OGq9A@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] Btrfs: populate heuristic with code
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="001a1144ab9c326540055c3b1d3a"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a1144ab9c326540055c3b1d3a
Content-Type: text/plain; charset="UTF-8"

2017-10-22 16:44 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> 2017-10-20 16:45 GMT+03:00 David Sterba <dsterba@suse.cz>:
>> On Fri, Oct 20, 2017 at 01:48:01AM +0300, Timofey Titovets wrote:
>>> 2017-10-19 18:39 GMT+03:00 David Sterba <dsterba@suse.cz>:
>>> > On Fri, Sep 29, 2017 at 06:22:00PM +0200, David Sterba wrote:
>>> >> On Thu, Sep 28, 2017 at 05:33:35PM +0300, Timofey Titovets wrote:
>>> >> > Compile tested, hand tested on live system
>>> >> >
>>> >> > Change v7 -> v8
>>> >> >   - All code moved to compression.c (again)
>>> >> >   - Heuristic workspaces inmplemented another way
>>> >> >     i.e. only share logic with compression workspaces
>>> >> >   - Some style fixes suggested by Devid
>>> >> >   - Move sampling function from heuristic code
>>> >> >     (I'm afraid of big functions)
>>> >> >   - Much more comments and explanations
>>> >>
>>> >> Thanks for the update, I went through the patches and they looked good
>>> >> enough to be put into for-next. I may have more comments about a few
>>> >> things, but nothing serious that would hinder testing.
>>> >
>>> > I did a final pass through the patches and edited comments wehre I was
>>> > not able to undrerstand them. Please check the updated patches in [1] if
>>> > I did not accidentally change the meaning.
>>>
>>> I don't see a link [1] in mail, may be you missed it?
>>
>> Yeah, sorry:
>> https://github.com/kdave/btrfs-devel/commits/ext/timofey/heuristic
>
> I did re-read updated comments, looks ok to me
> (i only found one typo, leave a comment).
>
>
> Thanks
> --
> Have a nice day,
> Timofey.

Can you please try that patch? (in attach)

I think some time about performance hit of heuristic and
how to avoid using sorting,

That patch will try prefind min/max values (before sorting) in array,
and (max - min), used to filter edge data cases where
byte core size < 64 or bigger > 200
It's a bit hacky workaround =\,
That show a ~same speedup on my data set as show using of radix sort.
(i.e. x2 speed up)

Thanks.

-- 
Have a nice day,
Timofey.

--001a1144ab9c326540055c3b1d3a
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-Btrfs-heuristic-try-avoid-bucket-sorting-on-edge-dat.patch"
Content-Disposition: attachment;
	filename="0001-Btrfs-heuristic-try-avoid-bucket-sorting-on-edge-dat.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j94ilpde0

RnJvbSBmYjJhMzI5ODI4ZTY0YWQwZTIyNGE4Y2I5N2RiYzE3MTQ3MTQ5NjI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaW1vZmV5IFRpdG92ZXRzIDxuZWZlbGltNGFnQGdtYWlsLmNv
bT4KRGF0ZTogTW9uLCAyMyBPY3QgMjAxNyAyMToyNDoyOSArMDMwMApTdWJqZWN0OiBbUEFUQ0hd
IEJ0cmZzOiBoZXVyaXN0aWMgdHJ5IGF2b2lkIGJ1Y2tldCBzb3J0aW5nIG9uIGVkZ2UgZGF0YSBj
YXNlcwoKSGVhcCBzb3J0IHVzZWQgaW4ga2VybmVsIGFyZSB0b28gc2xvdyBhbmQgY29zdGx5LApT
byBsZXQncyBtYWtlIHNvbWUgc3RhdGlzdGljIGFzc3VtZSBhYm91dCBlZ2RlIGlucHV0IGRhdGEg
Y2FzZXMKQmFzZWQgb24gb2JzZXJ2YXRpb24gb2YgZGlmZmVyZW5jZSBiZXR3ZWVuIG1pbi9tYXgg
dmFsdWVzIGluIGJ1Y2tldC4KClNpZ25lZC1vZmYtYnk6IFRpbW9mZXkgVGl0b3ZldHMgPG5lZmVs
aW00YWdAZ21haWwuY29tPgotLS0KIGZzL2J0cmZzL2NvbXByZXNzaW9uLmMgfCAzOCArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDM4IGluc2Vy
dGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9idHJmcy9jb21wcmVzc2lvbi5jIGIvZnMvYnRyZnMv
Y29tcHJlc3Npb24uYwppbmRleCAwY2ExNjkwOTg5NGUuLjU2YjY3ZWM0ZmI1YiAxMDA2NDQKLS0t
IGEvZnMvYnRyZnMvY29tcHJlc3Npb24uYworKysgYi9mcy9idHJmcy9jb21wcmVzc2lvbi5jCkBA
IC0xMzEwLDggKzEzMTAsNDYgQEAgc3RhdGljIGludCBieXRlX2NvcmVfc2V0X3NpemUoc3RydWN0
IGhldXJpc3RpY193cyAqd3MpCiAJdTMyIGk7CiAJdTMyIGNvcmVzZXRfc3VtID0gMDsKIAljb25z
dCB1MzIgY29yZV9zZXRfdGhyZXNob2xkID0gd3MtPnNhbXBsZV9zaXplICogOTAgLyAxMDA7CisJ
c3RydWN0IGJ1Y2tldF9pdGVtICptYXgsICptaW47CisJc3RydWN0IGJ1Y2tldF9pdGVtIHRtcDsK
IAlzdHJ1Y3QgYnVja2V0X2l0ZW0gKmJ1Y2tldCA9IHdzLT5idWNrZXQ7CiAKKworCS8qIFByZXNv
cnQgZm9yIGZpbmQgbWluL21heCB2YWx1ZSAqLworCW1heCA9ICZidWNrZXRbMF07CisJbWluID0g
JmJ1Y2tldFtCVUNLRVRfU0laRSAtIDFdOworCWZvciAoaSA9IDE7IGkgPCBCVUNLRVRfU0laRSAt
IDE7IGkrKykgeworCQlpZiAoYnVja2V0W2ldLmNvdW50ID4gbWF4LT5jb3VudCkgeworCQkJdG1w
ID0gKm1heDsKKwkJCSptYXggPSBidWNrZXRbaV07CisJCQlidWNrZXRbaV0gPSB0bXA7CisJCX0K
KwkJaWYgKGJ1Y2tldFtpXS5jb3VudCA8IG1pbi0+Y291bnQpIHsKKwkJCXRtcCA9ICptaW47CisJ
CQkqbWluID0gYnVja2V0W2ldOworCQkJYnVja2V0W2ldID0gdG1wOworCQl9CisJfQorCisJLyoK
KwkgKiBIYWNrcyBmb3IgYXZvaWQgc29ydGluZyBvbiBFZGdlIGRhdGEgY2FzZXMgKHNvcnRpbmcg
dG9vIGNvbnN0bHkpCisJICogaS5lLiB0aGF0IHdpbGwgZmFzdCBmaWx0ZXIgZWFzeSBjb21wcmVz
c2libGUKKwkgKiBhbmQgYmFkIGNvbXByZXNzaWJsZSBkYXRhCisJICogQmFzZWQgb24gb2JzZXJ2
YXRpb24gb2YgbnVtYmVyIGRpc3RyaWJ1dGlvbiBvbiBkaWZmZXJlbnQgZGF0YSBzZXRzCisJICoK
KwkgKiBBc3N1bWUgMTogRm9yIGJhZCBjb21wcmVzc2libGUgZGF0YSBkaXN0cmlidXRpb24gYmV0
d2VlbiBtaW4vbWF4CisJICogd2lsbCBiZSBsZXNzIHRoZW4gMC42JSBvZiBzYW1wbGUgc2l6ZQor
CSAqCisJICogQXNzdW1lIDI6IEZvciBnb29kIGNvbXByZXNzaWJsZSBkYXRhIGRpc3RyaWJ1dGlv
biBiZXR3ZWVuIG1pbi9tYXgKKwkgKiB3aWxsIGJlIGZhciBiaWdnZXIgdGhlbiA0JSBvZiBzYW1w
bGUgc2l6ZQorCSAqLworCisJaWYgKG1heC0+Y291bnQgLSBtaW4tPmNvdW50IDwgd3MtPnNhbXBs
ZV9zaXplICogNiAvIDEwMDApCisJCXJldHVybiBCWVRFX0NPUkVfU0VUX0hJR0ggKyAxOworCisJ
aWYgKG1heC0+Y291bnQgLSBtaW4tPmNvdW50ID4gd3MtPnNhbXBsZV9zaXplICogNCAvIDEwMCkK
KwkJcmV0dXJuIEJZVEVfQ09SRV9TRVRfTE9XIC0gMTsKKwogCS8qIFNvcnQgaW4gcmV2ZXJzZSBv
cmRlciAqLwogCXNvcnQoYnVja2V0LCBCVUNLRVRfU0laRSwgc2l6ZW9mKCpidWNrZXQpLCAmYnVj
a2V0X2NvbXBfcmV2LCBOVUxMKTsKIAotLSAKMi4xNC4yCgo=
--001a1144ab9c326540055c3b1d3a--
