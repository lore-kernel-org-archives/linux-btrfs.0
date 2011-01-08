From: Mikael Cluseau <nwrk@linux.nc>
Subject: Re: transid problem after a power-failure
Date: Sat, 08 Jan 2011 20:19:26 +1100
Message-ID: <1294478366.5240.34.camel@localhost>
References: <1294261344.5764.34.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-8Vl5Ye5ufzoLUMyzCUiw"
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294261344.5764.34.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>


--=-8Vl5Ye5ufzoLUMyzCUiw
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello again,

(this is a status update)

from what I begin to understand, the real problem is not the transid,
which is a kind of warning, but the failed assertion on "tree_root",
meaning that the read_tree_block call at disk-io.nc:736 fails.

The GDB backtrace is the following :

Reading symbols from /root/btrfs-progs-unstable/btrfsck...done.
(gdb) Starting program: /root/btrfs-progs-unstable/btrfsck /dev/dm-0
parent transid verify failed on 657818017792 wanted 85879 found 85878
parent transid verify failed on 657818017792 wanted 85879 found 85878
parent transid verify failed on 657818017792 wanted 85879 found 85878
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' fail=
ed.

Program received signal SIGABRT, Aborted.
0x00007ffff7885ee5 in raise () from /lib/libc.so.6
(gdb) #0  0x00007ffff7885ee5 in raise () from /lib/libc.so.6
#1  0x00007ffff7887896 in abort () from /lib/libc.so.6
#2  0x00007ffff787e7a5 in __assert_fail () from /lib/libc.so.6
#3  0x000000000040a96a in open_ctree_fd (fp=3D5, path=3D0x14f77 <Address 0x=
14f77 out of bounds>, sb_bytenr=3D<value optimized out>, writes=3D<value op=
timized out>) at disk-io.c:663
#4  0x000000000040adca in open_ctree (filename=3D0x7fffffffde9e "/dev/dm-0"=
, sb_bytenr=3D0, writes=3D0) at disk-io.c:587
#5  0x00000000004052ec in main (ac=3D<value optimized out>, av=3D0x7fffffff=
db68) at btrfsck.c:2859


Then I did some changes in disk-io.c#read_tree_block to tell him that
its parent_transid is 85878 when it is called with 85879 (a completely
blind change on consistency issues but my only guess for now). I also
added some printk's to see what is going on. For details, see the
disk-io.[ch].patch files attached. Now btrfsck fails on this:

-- entering read_tree_block...
called with parent_transid=3D85879, setting it to 85878
btrfs_buffer_uptodate: extent_buffer_uptodate FAIL
btrfs_buffer_uptodate @657818017792 / transid wanted 85878
-- search loop [transid=3D85878] --
`-> extend buffer informations follow
    |-> start:      657818017792
    |-> dev_bytenr: 659437019136
    |-> len:        4096
    |-> refs:       2
    `-> flags:      0
`-> eb found and set uptodate!
btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] =
=3D=3D 0)' failed.

I dd'ed the block to have a backup, I attached it here, if it can useful
for anything. Here's the dd command, if I'm wrong somewhere, please tell
me:

dd bs=3D1 count=3D4096 skip=3D659437019136 if=3D/dev/dm-0 of=3Dblock

My next move will be to analyse the BTRFS's structure more deeply to
understand how I can try to figure out what exactly is impacted and how
to get access to a least what is not impacted (corruption on impacted
data is something I can live with much better than losing access to
these 3TB of data "just" because of this ;)).

Any link/help welcome, of course. And also tell me if you consider my
status updates as useless for this list, so I don't spam you guys. My
first goal is to get the data back, of course, but a good secondary goal
is to help have btrfsck handle these cases (but my C is pretty old now).

Regards,
Mika=EBl.

--=-8Vl5Ye5ufzoLUMyzCUiw
Content-Disposition: attachment; filename="disk-io.c.patch"
Content-Type: text/x-patch; name="disk-io.c.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2Rpc2staW8uYyBiL2Rpc2staW8uYw0KaW5kZXggYTZlMTAwMC4uMTc4MDhm
ZCAxMDA2NDQNCi0tLSBhL2Rpc2staW8uYw0KKysrIGIvZGlzay1pby5jDQpAQCAtMTg1LDE2ICsx
ODUsMjkgQEAgc3RydWN0IGV4dGVudF9idWZmZXIgKnJlYWRfdHJlZV9ibG9jayhzdHJ1Y3QgYnRy
ZnNfcm9vdCAqcm9vdCwgdTY0IGJ5dGVuciwNCiAJaW50IG1pcnJvcl9udW0gPSAwOw0KIAlpbnQg
bnVtX2NvcGllczsNCiANCisJcHJpbnRrKCItLSBlbnRlcmluZyByZWFkX3RyZWVfYmxvY2suLi5c
biIpOw0KKw0KKwlpZiAocGFyZW50X3RyYW5zaWQgPT0gODU4NzkpIHsNCisJCXByaW50aygiY2Fs
bGVkIHdpdGggcGFyZW50X3RyYW5zaWQ9ODU4NzksIg0KKwkJCSIgc2V0dGluZyBpdCB0byA4NTg3
OFxuIik7DQorCQlwYXJlbnRfdHJhbnNpZCA9IDg1ODc4Ow0KKwl9DQorDQogCWViID0gYnRyZnNf
ZmluZF9jcmVhdGVfdHJlZV9ibG9jayhyb290LCBieXRlbnIsIGJsb2Nrc2l6ZSk7DQogCWlmICgh
ZWIpDQogCQlyZXR1cm4gTlVMTDsNCiANCiAJaWYgKGJ0cmZzX2J1ZmZlcl91cHRvZGF0ZShlYiwg
cGFyZW50X3RyYW5zaWQpKQ0KIAkJcmV0dXJuIGViOw0KKwkNCisJcHJpbnRrKCJidHJmc19idWZm
ZXJfdXB0b2RhdGUgQCVsbHUgLyB0cmFuc2lkIHdhbnRlZCAlbGx1XG4iLA0KKwkJKHVuc2lnbmVk
IGxvbmcgbG9uZykgZWItPnN0YXJ0LA0KKwkJKHVuc2lnbmVkIGxvbmcgbG9uZykgcGFyZW50X3Ry
YW5zaWQpOw0KIA0KIAlkZXZfbnIgPSAwOw0KIAlsZW5ndGggPSBibG9ja3NpemU7DQogCXdoaWxl
ICgxKSB7DQorCQlwcmludGsoIi0tIHNlYXJjaCBsb29wIFt0cmFuc2lkPSVsbHVdIC0tXG4iLCBw
YXJlbnRfdHJhbnNpZCk7DQogCQlyZXQgPSBidHJmc19tYXBfYmxvY2soJnJvb3QtPmZzX2luZm8t
Pm1hcHBpbmdfdHJlZSwgUkVBRCwNCiAJCQkJICAgICAgZWItPnN0YXJ0LCAmbGVuZ3RoLCAmbXVs
dGksIG1pcnJvcl9udW0pOw0KIAkJQlVHX09OKHJldCk7DQpAQCAtMjA0LDEwICsyMTcsMTQgQEAg
c3RydWN0IGV4dGVudF9idWZmZXIgKnJlYWRfdHJlZV9ibG9jayhzdHJ1Y3QgYnRyZnNfcm9vdCAq
cm9vdCwgdTY0IGJ5dGVuciwNCiAJCWViLT5kZXZfYnl0ZW5yID0gbXVsdGktPnN0cmlwZXNbMF0u
cGh5c2ljYWw7DQogCQlrZnJlZShtdWx0aSk7DQogCQlyZXQgPSByZWFkX2V4dGVudF9mcm9tX2Rp
c2soZWIpOw0KKwkJaWYgKHBhcmVudF90cmFuc2lkID09IDg1ODc4KSB7DQorCQkJcHJpbnRfZXh0
ZW50X2J1ZmZlcl9pbmZvKGViKTsNCisJCX0NCiAJCWlmIChyZXQgPT0gMCAmJiBjaGVja190cmVl
X2Jsb2NrKHJvb3QsIGViKSA9PSAwICYmDQogCQkgICAgY3N1bV90cmVlX2Jsb2NrKHJvb3QsIGVi
LCAxKSA9PSAwICYmDQogCQkgICAgdmVyaWZ5X3BhcmVudF90cmFuc2lkKGViLT50cmVlLCBlYiwg
cGFyZW50X3RyYW5zaWQpID09IDApIHsNCiAJCQlidHJmc19zZXRfYnVmZmVyX3VwdG9kYXRlKGVi
KTsNCisJCQlwcmludGsoImAtPiBlYiBmb3VuZCBhbmQgc2V0IHVwdG9kYXRlIVxuIik7DQogCQkJ
cmV0dXJuIGViOw0KIAkJfQ0KIAkJbnVtX2NvcGllcyA9IGJ0cmZzX251bV9jb3BpZXMoJnJvb3Qt
PmZzX2luZm8tPm1hcHBpbmdfdHJlZSwNCkBAIC0yMjEsNiArMjM4LDcgQEAgc3RydWN0IGV4dGVu
dF9idWZmZXIgKnJlYWRfdHJlZV9ibG9jayhzdHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdCwgdTY0IGJ5
dGVuciwNCiAJCX0NCiAJfQ0KIAlmcmVlX2V4dGVudF9idWZmZXIoZWIpOw0KKwlwcmludGsoIi0t
IG5vdCBmb3VuZCAtLVxuIik7DQogCXJldHVybiBOVUxMOw0KIH0NCiANCkBAIC0xMDE2LDEwICsx
MDM0LDE0IEBAIGludCBidHJmc19idWZmZXJfdXB0b2RhdGUoc3RydWN0IGV4dGVudF9idWZmZXIg
KmJ1ZiwgdTY0IHBhcmVudF90cmFuc2lkKQ0KIAlpbnQgcmV0Ow0KIA0KIAlyZXQgPSBleHRlbnRf
YnVmZmVyX3VwdG9kYXRlKGJ1Zik7DQotCWlmICghcmV0KQ0KKwlpZiAoIXJldCkgew0KKwkJcHJp
bnRrKCJidHJmc19idWZmZXJfdXB0b2RhdGU6IGV4dGVudF9idWZmZXJfdXB0b2RhdGUgRkFJTFxu
Iik7DQogCQlyZXR1cm4gcmV0Ow0KKwl9DQogDQogCXJldCA9IHZlcmlmeV9wYXJlbnRfdHJhbnNp
ZChidWYtPnRyZWUsIGJ1ZiwgcGFyZW50X3RyYW5zaWQpOw0KKwlpZiAocmV0KQ0KKwkJcHJpbnRr
KCJidHJmc19idWZmZXJfdXB0b2RhdGU6IHZlcmlmeV9wYXJlbnRfdHJhbnNpZCBGQUlMXG4iKTsN
CiAJcmV0dXJuICFyZXQ7DQogfQ0KIA0KQEAgLTEwMjcsMyArMTA0OSwxMyBAQCBpbnQgYnRyZnNf
c2V0X2J1ZmZlcl91cHRvZGF0ZShzdHJ1Y3QgZXh0ZW50X2J1ZmZlciAqZWIpDQogew0KIAlyZXR1
cm4gc2V0X2V4dGVudF9idWZmZXJfdXB0b2RhdGUoZWIpOw0KIH0NCisNCit2b2lkIHByaW50X2V4
dGVudF9idWZmZXJfaW5mbyhzdHJ1Y3QgZXh0ZW50X2J1ZmZlciAqZWIpIHsNCisJcHJpbnRrKCJg
LT4gZXh0ZW5kIGJ1ZmZlciBpbmZvcm1hdGlvbnMgZm9sbG93XG4iKTsNCisJcHJpbnRrKCIgICAg
fC0+IHN0YXJ0OiAgICAgICVsbHVcbiIsIGViLT5zdGFydCAgICAgKTsNCisJcHJpbnRrKCIgICAg
fC0+IGRldl9ieXRlbnI6ICVsbHVcbiIsIGViLT5kZXZfYnl0ZW5yKTsNCisJcHJpbnRrKCIgICAg
fC0+IGxlbjogICAgICAgICVpXG4iLCAgIGViLT5sZW4gICAgICAgKTsNCisJcHJpbnRrKCIgICAg
fC0+IHJlZnM6ICAgICAgICVpXG4iLCAgIGViLT5yZWZzICAgICAgKTsNCisJcHJpbnRrKCIgICAg
fC0+IGZsYWdzOiAgICAgICVpXG4iLCAgIGViLT5mbGFncyAgICAgKTsNCit9DQorDQo=


--=-8Vl5Ye5ufzoLUMyzCUiw
Content-Disposition: attachment; filename="disk-io.h.patch"
Content-Type: text/x-patch; name="disk-io.h.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2Rpc2staW8uaCBiL2Rpc2staW8uaA0KaW5kZXggNDllNTY5Mi4uYjhhOWY5
NSAxMDA2NDQNCi0tLSBhL2Rpc2staW8uaA0KKysrIGIvZGlzay1pby5oDQpAQCAtNzUsNCArNzUs
NyBAQCBpbnQgY3N1bV90cmVlX2Jsb2NrX3NpemUoc3RydWN0IGV4dGVudF9idWZmZXIgKmJ1Ziwg
dTE2IGNzdW1fc2VjdG9yc2l6ZSwNCiBpbnQgY3N1bV90cmVlX2Jsb2NrKHN0cnVjdCBidHJmc19y
b290ICpyb290LCBzdHJ1Y3QgZXh0ZW50X2J1ZmZlciAqYnVmLA0KIAkJICAgIGludCB2ZXJpZnkp
Ow0KIGludCBidHJmc19yZWFkX2J1ZmZlcihzdHJ1Y3QgZXh0ZW50X2J1ZmZlciAqYnVmLCB1NjQg
cGFyZW50X3RyYW5zaWQpOw0KKw0KK3ZvaWQgcHJpbnRfZXh0ZW50X2J1ZmZlcl9pbmZvKHN0cnVj
dCBleHRlbnRfYnVmZmVyICplYik7DQorDQogI2VuZGlmDQo=


--=-8Vl5Ye5ufzoLUMyzCUiw
Content-Type: application/x-gzip; name="block.gz"
Content-Disposition: attachment; filename="block.gz"
Content-Transfer-Encoding: base64

H4sIAEwiKE0AA53WezhU+QPH8ZlyvwyGZsWUzBBDGLkNlhBKoZlU65aK2p1QDW0j1kwjY1yaX+4U
JkxsRkOikVtIG6HJdHHZmCKb1VjZYiWX/HTs7tP+zu/ZP873v/m+znue88/nec64kbIF7F+Ojc+6
3vBO769rNDWxxBRvIuzwGtzllXv4KsOloqcPk4QurASh0x1en4YLdc+qzC+vHr3PP6z2rQUuw2GM
j8Of/VuVlct/wjwA5mBYAGARAYJFADrAsARABhg+AXAQDMsAGIIBNvIZppVBAAegGQxrAEgGw1oA
9oFBCgAdMEgDIFECgQwAAjDIAsAAgxwAu8EgDwAKDAoAjCiCQBEAPhiUAIgCgzIALmBAAKAMBhUA
BhRAoArAVTCoAXASDEgAbMGgDoAUGDQA6JEHwToA8sCAAuAYGL4CAA8GTQAW5ECwHoB2MGgBkP4n
zP45LwYM3yJ/b+XizAqg/wFERcFn4EnBYA9X/iWx/OMGkmBuc+x/LEZ3aiVhwyaShmH9t+lV217y
U7DZZTDpDiYzuhNDVwiY7zcY76DaOPqGlLSUiNWnI1xbnnlN1FyKKBGXjwZuZKZdg3skTMCHDjAY
7AYnhOrxmSKpl5VuMR/0aj68XT6YqpHFN5hsrHa55bU5Di0twLvKx+5H9rdP13CN23bNIe8Ws0le
N3kLRiNHiXZyHV5DqZ0DkoD0IkHh1ztreaUxWp3WJ+5NFukNs7dh4rXu5nm+NROFz3rgTli+60Lr
a5jyfd78UWD2gC4xbKh7f4dY2dgjuScTjFIPuu6woT5YJ9+WRYqCIeR1fJqj7LY2pqpWe5wtb3hL
Pz4mSW8WaJZn9C3vijCYZAxV//7K15wTdNbEg+sH166bvYVyJWXrfjSatdh+hlhVhxF/avRNDcEb
zCsVT1w0XiNSt8QdS7kS+rI2LblCYdy7VN4wx0fSRGnHzu9u935RaZ5ivKVJeeRXqqGu1UG1DUu7
MRwJJ/UbjSNPh1ps+YP6scEtNwhTPvOhoVspCVVBPrNafTdzD9x0/8n4OVOWi8uNrqGd6DEJ614g
sERuDxBRuAYWW2Dnl1YWVFrhPZz8seBQVcKjk7eOlXgOuh+1jqwr8esJUSGj0tx78jCdTyqKURmu
Vv2YjQt5KLU3kc1Yzo3HO2Q8hVhkfd71Lu2ZPRFT9JZfjhyf9actn1bYPncsfECISzQxT7gpFnY1
pwY1Xb0zr+ckQsnbi1khU7LX2xD1vIhY53dlmRK65qW9heGm+VhFgr1l3GKjbALF/zknlp3x1HbO
d/xaK9N3xHDdTjX3WZvGsIelwTOZuXuetqVj73Ps/N/7TTnCojpEdwNeB8lcH6WQMi63kQgKB1j2
RXtye7LUbbQrngvF3fU+zkdEhbfL/c5eGbRrLXnxy70n5xoCEvszf65DCR26ESbRNbc9hxRH9qdT
7V6bx+/Fc8kH+YO1+upJfovotYqKr8R1GKo2hlM82DRwPFuOrVb9xIuyqze5VUROlPd2zI/6zV6E
7OBqXO7mTaPdwrZwMyx/emchuKBEmd7l/CrHFq8QnGV5PtNUOmfaU8y45j+29O2maUfzQL7vBV/l
+wJ4Qygh9YpKCK1CpXc+OFBf+qQ0umCMwIu36gs+kzvm/WNOo0/A9zI4bZfTWB03FTVFlTWOCOty
jN7PPNO6aNNlmuR1tVzy1XPPBAdEmTgn7xhxjf+wWX5LcpNJTPb2jVN+JPijku+fviYSt7RaVsV3
OJ7lW6x7aem699dvkrpH87oQWzk66JwH8Q4PMWWRy45lc7Qm9xs5LGfiJzJdBxvECvlR+CZwLRaJ
PiXkXiI/rgp4QCZR/M9bnh6VnxnJHb3oURf/DmkqpJqMkdnflc/GFsgWkp4zA72y6MpJSdXblPJ5
Rbo0XFkjCnlhKa1HCbskQ3Ade/GDM6eNmBpsc8gU78BGhthgf3CJORzAnu6mzjUjY6uMPgyY0bIV
JsgtVgbrpdoeDdFTI2lZTC/cJm7i+VPM4qxAFXXZ0q602s5uY+3e0LTdh3ZUaF1WjVC1EAsTLqTE
auy4PVvogh+PC2E5BP9xxDdDElbWiubLaasdlehSacbjBlKR3KP7JxVZ9DZ8g73H4+WuvrFmjX0M
f06mf9KrXHXOaUK5xzM9VbneyjOGVO1zp5at7d63V1LirOIW4WxEfH0G+aKCnwT+zG3GfKTIyHpy
YYi58rq2BeFGpn99pcBUYX8fOMzJrvb+/1x++dDf0V8fP6uR7Wr0xeWXD/3/CE+AEG2ygRCpWkOI
YFYQot8tIETDWyFEInMIUSseQlRlBiEqMoUQpZlAiBhbIEQUYwjRYSMIEREHIXIyhLInAyh72gxl
T/pQ9qQHZU8YKHvShbKnTVD2pANlTxuh7GkDlD2hoexJG8qetKDsaT2UPWlC2dNX/xr9F/l11TkA
EAAA


--=-8Vl5Ye5ufzoLUMyzCUiw--
