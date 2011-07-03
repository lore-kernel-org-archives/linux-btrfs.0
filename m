From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: TRIM support
Date: Sun, 3 Jul 2011 13:56:40 +0100
Message-ID: <CAAeznTpCXWz+dth4PiMneV23NiLyr8c+usiw07Gkn6=AvaVM9g@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<CAAeznTrfX9u9YXAz31cjsR=qxqrsnaPHLjZxqTaO4SDVBicF6A@mail.gmail.com>
	<CAAeznTpwk=Vu6g1xpQSR_By-=o6Sy2=B4cCG97Md4kHRibf6qQ@mail.gmail.com>
	<201107031420.45718.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016368e2b9f2ce73d04a729c8ec
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107031420.45718.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

--0016368e2b9f2ce73d04a729c8ec
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 3, 2011 at 1:20 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Sunday 03 of July 2011 00:40:46 Leonidas Spyropoulos wrote:
>> On Sat, Jul 2, 2011 at 11:39 PM, Leonidas Spyropoulos
>>
>> <artafinde@gmail.com> wrote:
>> > On Sat, Jul 2, 2011 at 8:45 PM, Calvin Walton <calvin.walton@kepstin.c=
a>
> wrote:
>> >> On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
>> >>> Hello,
>> >>>
>> >>> I just installed an archlinux with btrfs root partition and would li=
ke
>> >>> to set the correct mount properties
>> >>> Following this:
>> >>> https://wiki.archlinux.org/index.php/Solid_State_Drives
>> >>> it says there that I should use the discard mount parameter to enabl=
e
>> >>> TRIM.
>> >>>
>> >>> I would like to ask by using ssd mount parameter would TRIM be enabl=
ed?
>> >>> The SSD is Intel 320 Series 120Gb
>> >>
>> >> No, the "ssd" mount parameter has nothing to do with TRIM.
>> >>
>> >> The "ssd" mount parameter adjusts a couple of tuning parameters where
>> >> the default setting is designed to improve performance on spinning HD=
D,
>> >> and instead tunes for the random-access ability of an SSD.
>> >>
>> >> The ssd option is automatically enabled if the kernel detects that yo=
ur
>> >> drive is an SSD (you can check with 'cat /proc/mounts').
>> >>
>> >> The discard option is not currently automatically enabled; I think th=
ere
>> >> may have been some performance issues in certain cases with drives th=
at
>> >> have slow trim implementations. But feel free to give it a try.
>> >>
>> >> --
>> >> Calvin Walton <calvin.walton@kepstin.ca>
>>
>> On the same system when I try to compile the btrfs-tools I get an error.
>> Since on the wiki you mention only the packages for Fedora and Debian,
>>
>> Which are the requirements for the btrfs tools?
>>
>> PS: AUR package is broken as well.
>
> the AUR package is OK, problem is that the sources don't compile with new=
 gcc.
>
> Download Hugo's integration branch
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-201=
10630

I download the files:

git clone  http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
integration-20110630

> and apply my patch to it:
> http://www.spinics.net/lists/linux-btrfs/msg10965.html

Then I tried to apply the patch you mentioned:

patch < rem.diff

but it's failing:
The rem.diff is the file attached

> --
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=F3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
>
Here is the error I am getting:
patching file mkfs.c
Hunk #1 FAILED at 1060.
Hunk #2 FAILED at 1070.
2 out of 2 hunks FAILED -- saving rejects to file mkfs.c.rej
patching file volumes.c
Hunk #1 FAILED at 868.
Hunk #2 FAILED at 920.
2 out of 2 hunks FAILED -- saving rejects to file volumes.c.rej

I think the file I created is wrong.
What is the accepted format for the patch command?


--=20
Caution: breathing may be hazardous to your health.

--0016368e2b9f2ce73d04a729c8ec
Content-Type: text/x-patch; charset=US-ASCII; name="rem.diff"
Content-Disposition: attachment; filename="rem.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpo2b2mq0

IG1rZnMuYyAgICB8ICAgIDMgLS0tCiB2b2x1bWVzLmMgfCAgICAyIC0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ta2ZzLmMg
Yi9ta2ZzLmMKaW5kZXggMWI1ZWYwNi4uZDQwYjJlOCAxMDA2NDQKLS0tIGEvbWtmcy5jCisrKyBi
L21rZnMuYwpAQCAtMTA2MCw3ICsxMDYwLDYgQEAgc3RhdGljIGludCBtYWtlX2ltYWdlKGNoYXIg
KnNvdXJjZV9kaXIsIHN0cnVjdCBidHJmc19yb290ICpyb290LCBpbnQgb3V0X2ZkKQogICAgICAg
c3RydWN0IGJ0cmZzX3RyYW5zX2hhbmRsZSAqdHJhbnM7CgogICAgICAgc3RydWN0IHN0YXQgcm9v
dF9zdDsKLSAgICAgICBpbnQgcm9vdF9sZW47CgogICAgICAgc3RydWN0IGRpcmVjdG9yeV9uYW1l
X2VudHJ5IGRpcl9oZWFkOwoKQEAgLTEwNzAsOCArMTA2OSw2IEBAIHN0YXRpYyBpbnQgbWFrZV9p
bWFnZShjaGFyICpzb3VyY2VfZGlyLCBzdHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdCwgaW50IG91dF9m
ZCkKICAgICAgICAgICAgICAgZ290byBmYWlsOwogICAgICAgfQoKLSAgICAgICByb290X2xlbiA9
IHN0cmxlbihzb3VyY2VfZGlyKTsKLQogICAgICAgSU5JVF9MSVNUX0hFQUQoJmRpcl9oZWFkLmxp
c3QpOwoKICAgICAgIHRyYW5zID0gYnRyZnNfc3RhcnRfdHJhbnNhY3Rpb24ocm9vdCwgMSk7CmRp
ZmYgLS1naXQgYS92b2x1bWVzLmMgYi92b2x1bWVzLmMKaW5kZXggNjFhZjg0NS4uOTVjMmUwZCAx
MDA2NDQKLS0tIGEvdm9sdW1lcy5jCisrKyBiL3ZvbHVtZXMuYwpAQCAtODY4LDcgKzg2OCw2IEBA
IGludCBidHJmc19hbGxvY19kYXRhX2NodW5rKHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRy
YW5zLAogICAgICAgc3RydWN0IGxpc3RfaGVhZCAqZGV2X2xpc3QgPSAmZXh0ZW50X3Jvb3QtPmZz
X2luZm8tPmZzX2RldmljZXMtPmRldmljZXM7CiAgICAgICBzdHJ1Y3QgbGlzdF9oZWFkICpjdXI7
CiAgICAgICBzdHJ1Y3QgbWFwX2xvb2t1cCAqbWFwOwotICAgICAgIHU2NCBwaHlzaWNhbDsKICAg
ICAgIHU2NCBjYWxjX3NpemUgPSA4ICogMTAyNCAqIDEwMjQ7CiAgICAgICBpbnQgbnVtX3N0cmlw
ZXMgPSAxOwogICAgICAgaW50IHN1Yl9zdHJpcGVzID0gMDsKQEAgLTkyMCw3ICs5MTksNiBAQCBp
bnQgYnRyZnNfYWxsb2NfZGF0YV9jaHVuayhzdHJ1Y3QgYnRyZnNfdHJhbnNfaGFuZGxlICp0cmFu
cywKICAgICAgICAgICAgICAgYnRyZnNfc2V0X3N0YWNrX3N0cmlwZV9kZXZpZChzdHJpcGUsIGRl
dmljZS0+ZGV2aWQpOwogICAgICAgICAgICAgICBidHJmc19zZXRfc3RhY2tfc3RyaXBlX29mZnNl
dChzdHJpcGUsIGRldl9vZmZzZXQpOwogICAgICAgICAgICAgICBtZW1jcHkoc3RyaXBlLT5kZXZf
dXVpZCwgZGV2aWNlLT51dWlkLCBCVFJGU19VVUlEX1NJWkUpOwotICAgICAgICAgICAgICAgcGh5
c2ljYWwgPSBkZXZfb2Zmc2V0OwogICAgICAgICAgICAgICBpbmRleCsrOwogICAgICAgfQo=
--0016368e2b9f2ce73d04a729c8ec--
