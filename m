From: Andrew Lutomirski <andy@luto.us>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
Date: Mon, 28 Mar 2011 23:50:01 -0400
Message-ID: <AANLkTikCKjrtSJbcR7_GmcZfxS+jfekkkiOP9jyAaM7F@mail.gmail.com>
References: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
 <1297438671-sup-21@think> <AANLkTimLeCMFO++RYnCXOPSMeNzxf2SAovEZ-q-q5TzF@mail.gmail.com>
 <1297696565-sup-8163@think>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf307f39b49774cc049f96f513
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297696565-sup-8163@think>
List-ID: <linux-btrfs.vger.kernel.org>

--20cf307f39b49774cc049f96f513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 14, 2011 at 10:22 AM, Chris Mason <chris.mason@oracle.com> wrot=
e:
> Excerpts from Andrew Lutomirski's message of 2011-02-11 19:35:02 -0500:
>> On Fri, Feb 11, 2011 at 10:44 AM, Chris Mason <chris.mason@oracle.com> w=
rote:

>> >
>> > We can tell more if you post the full traces from latencytop. =A0I hav=
e a
>> > patch here for latencytop that adds a -c mode, which dumps the traces
>> > out to a text files.
>> >
>> > http://oss.oracle.com/~mason/latencytop.patch
>> >
>> > Based on what you have here, I think it's probably a latency problem
>> > between btrfs and the dm-crypt stuff. =A0How easily can setup a test
>> > partition without dm-crypt?
>>
>> Done, on the same physical disk as before. =A0The latency is just as
>> bad. =A0On this test, I wrote a total of 3.1G, which is under half of my
>> RAM. =A0That should rule out lots of VM issues. =A0latencytop trace belo=
w.
>
> Just to confirm, you say on a physical disk you mean without dm-crypt?

Sorry for the exceedingly slow reply.

This problem is really bad with 2.6.38.1.  To make it a little easier
to demonstrate, I wrote a tool that shows off the problem.

I made a test btrfs partition on a plain disk partition (same disk as
my dm-crypt but an unencrypted partition).  Now clone a kernel tree
there and run make -j8.  Wait until the disk starts to write data out
in earnest (takes awhile to dirty enough pages).  Watch crap like this
happen (with nr_requests =3D 2048, scheduler =3D deadline).

io_latency_watch read <1M file on test partition>

read took 0.000 seconds (worst =3D 0.963s)
read took 0.000 seconds (worst =3D 0.963s)
read took 0.022 seconds (worst =3D 0.963s)
read took 0.000 seconds (worst =3D 0.963s)
read took 0.028 seconds (worst =3D 0.963s)
read took 1.430 seconds (worst =3D 1.430s)
read took 0.270 seconds (worst =3D 1.430s)
read took 1.237 seconds (worst =3D 1.430s)
read took 0.282 seconds (worst =3D 1.430s)
read took 0.131 seconds (worst =3D 1.430s)

io_latency_watch read <1M file on other partition on same disk> is
similar, and io_latency_test write <dir on other partition> is even
worse.

The cfq scheduler is similar.

--Andy

--20cf307f39b49774cc049f96f513
Content-Type: text/x-csrc; charset=US-ASCII; name="io_latency_watch.c"
Content-Disposition: attachment; filename="io_latency_watch.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gluafk4y0

LyogaW9fbGF0ZW5jeV90ZXN0LmMKICogQ29weXJpZ2h0IChjKSAyMDExIEFuZHkgTHV0b21pcnNr
aQogKiBMaWNlbnNlZCB1bmRlciBHUEx2Mi4KICoKICogQ29tcGlsZSB3aXRoIGdjYyAtTzIgLXN0
ZD1nbnU5OSAtbHJ0CiAqLwoKI2RlZmluZSBfRklMRV9PRkZTRVRfQklUUyA2NAojZGVmaW5lIF9H
TlVfU09VUkNFCiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRl
IDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN0ZGJvb2wuaD4KI2luY2x1ZGUgPHRpbWUuaD4KI2luY2x1
ZGUgPHN0ZGludC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2lu
Y2x1ZGUgPGludHR5cGVzLmg+CiNpbmNsdWRlIDxmY250bC5oPgoKdm9sYXRpbGUgY29uc3QgY2hh
ciAqZmlsZV90b191bmxpbms7Cgp2b2lkIGhhbmRsZXIoaW50IHgpCnsKICBpZiAoZmlsZV90b191
bmxpbmspCiAgICB1bmxpbmsoKGNoYXIqKWZpbGVfdG9fdW5saW5rKTsKCiAgX2V4aXQoMCk7Cn0K
CnZvaWQgZG9fcmVhZChjb25zdCBjaGFyICpuYW1lKQp7CiAgaW50IGZkID0gb3BlbihuYW1lLCBP
X1JET05MWSB8IE9fRElSRUNUKTsKICBpZiAoZmQgPCAwKSB7CiAgICBwZXJyb3IoIm9wZW4iKTsK
ICAgIGV4aXQoMSk7CiAgfQoKICB1aW50NjRfdCB3b3JzdCA9IDA7CiAgb2ZmX3Qgc2l6ZSA9IGxz
ZWVrKGZkLCAwLCBTRUVLX0VORCk7CiAgaWYgKHNpemUgPT0gKG9mZl90KS0xKSB7CiAgICBwZXJy
b3IoImxzZWVrIik7CiAgICBhYm9ydCgpOwogIH0KCiAgc2l6ZSAtPSAoc2l6ZSAlIDQwOTYpOwoK
ICBpZiAoc2l6ZSA8IDQwOTYpIHsKICAgIHByaW50ZigiRmlsZSBpcyBzbWFsbGVyIHRoYW4gNGtc
biIpOwogICAgZXhpdCgxKTsKICB9CgogIHByaW50ZigiRmlsZSBzaXplIGlzICUiIFBSSXU2NCAi
IGJ5dGVzIC0tIGJpZ2dlciBpcyBiZXR0ZXJcbiIsICh1aW50NjRfdClzaXplKTsKCiAgd2hpbGUo
dHJ1ZSkKICAgIHsKICAgICAgdWludDY0X3QgcG9zID0gNDA5NiAqIChyYW5kb20oKSAlIChzaXpl
IC8gNDA5NikpOwoKICAgICAgc3RydWN0IHRpbWVzcGVjIHN0YXJ0OwogICAgICBjbG9ja19nZXR0
aW1lKENMT0NLX01PTk9UT05JQywgJnN0YXJ0KTsKCiAgICAgIHVuc2lnbmVkIGNoYXIgeFs0MDk2
XTsKICAgICAgaWYgKHByZWFkKGZkLCB4LCA0MDk2LCBwb3MpICE9IDQwOTYpIHsKCXBlcnJvcigi
cHJlYWQiKTsKCWFib3J0KCk7CiAgICAgIH0KCiAgICAgIHN0cnVjdCB0aW1lc3BlYyBlbmQ7CiAg
ICAgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmZW5kKTsKICAgICAgCiAgICAgIHVp
bnQ2NF90IG5zID0gKGVuZC50dl9uc2VjIC0gc3RhcnQudHZfbnNlYykgKyAxMDAwMDAwMDAwVUxM
ICogKGVuZC50dl9zZWMgLSBzdGFydC50dl9zZWMpOwoKICAgICAgaWYgKG5zID4gd29yc3QpCgl3
b3JzdCA9IG5zOwoKICAgICAgcHJpbnRmKCJyZWFkIHRvb2sgJS4zZiBzZWNvbmRzICh3b3JzdCA9
ICUuM2ZzKVxuIiwKCSAgICAgMWUtOSAqIG5zLCAxZS05ICogd29yc3QpOwoKICAgICAgaWYgKHBv
c2l4X2ZhZHZpc2UoZmQsIDAsIHNpemUsIFBPU0lYX0ZBRFZfRE9OVE5FRUQpICE9IDApCglwZXJy
b3IoInBvc2l4X2ZhZHZpc2UiKTsKCiAgICAgIHVzbGVlcCgxMDAwMDAwKTsKICAgIH0KfQoKdm9p
ZCBkb193cml0ZShjb25zdCBjaGFyICpkaXIpCnsKICBjaGFyICpuYW1lOwogIGlmIChhc3ByaW50
ZigmbmFtZSwgIiVzL3RtcC5YWFhYWFgiLCBkaXIpID09IC0xKQogICAgYWJvcnQoKTsKCiAgaW50
IGZkID0gbWtzdGVtcChuYW1lKTsKICBpZiAoZmQgPT0gLTEpIHsKICAgIHBlcnJvcigibWtzdGVt
cCIpOwogICAgYWJvcnQoKTsKICB9CgogIGZpbGVfdG9fdW5saW5rID0gbmFtZTsKCiAgdWludDY0
X3Qgd29yc3QgPSAwOwoKICB1bnNpZ25lZCBjaGFyIHg7CiAgd2hpbGUodHJ1ZSkKICAgIHsKICAg
ICAgeCsrOwogICAgICBzdHJ1Y3QgdGltZXNwZWMgc3RhcnQ7CiAgICAgIGNsb2NrX2dldHRpbWUo
Q0xPQ0tfTU9OT1RPTklDLCAmc3RhcnQpOwoKICAgICAgaWYgKHB3cml0ZShmZCwgJngsIDEsIDAp
ICE9IDEpIHsKCXBlcnJvcigicHdyaXRlIik7CglhYm9ydCgpOwogICAgICB9CgogICAgICBpZiAo
ZmRhdGFzeW5jKGZkKSAhPSAwKSB7CglwZXJyb3IoImZkYXRhc3luYyIpOwoJYWJvcnQoKTsKICAg
ICAgfQoKICAgICAgc3RydWN0IHRpbWVzcGVjIGVuZDsKICAgICAgY2xvY2tfZ2V0dGltZShDTE9D
S19NT05PVE9OSUMsICZlbmQpOwogICAgICAKICAgICAgdWludDY0X3QgbnMgPSAoZW5kLnR2X25z
ZWMgLSBzdGFydC50dl9uc2VjKSArIDEwMDAwMDAwMDBVTEwgKiAoZW5kLnR2X3NlYyAtIHN0YXJ0
LnR2X3NlYyk7CgogICAgICBpZiAobnMgPiB3b3JzdCkKCXdvcnN0ID0gbnM7CgogICAgICBwcmlu
dGYoIndyaXRlICsgZnN5bmMgdG9vayAlLjNmIHNlY29uZHMgKHdvcnN0ID0gJS4zZnMpXG4iLAoJ
ICAgICAxZS05ICogbnMsIDFlLTkgKiB3b3JzdCk7CgogICAgICB1c2xlZXAoMTAwMDAwMCk7CiAg
ICB9Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewogIGlmIChhcmdjICE9IDMp
IHsKICAgIHByaW50ZigiVXNhZ2U6ICVzIHdyaXRlIDxkaXI+IG9yICVzIHJlYWQgPGZpbGU+XG4i
LCBhcmd2WzBdLCBhcmd2WzBdKTsKICAgIHJldHVybiAxOwogIH0KCiAgYm9vbCB3cml0ZTsKICBp
ZiAoIXN0cmNtcChhcmd2WzFdLCAid3JpdGUiKSkgewogICAgd3JpdGUgPSB0cnVlOwogIH0gZWxz
ZSBpZiAoIXN0cmNtcChhcmd2WzFdLCAicmVhZCIpKSB7CiAgICB3cml0ZSA9IGZhbHNlOwogIH0g
ZWxzZSB7CiAgICBwcmludGYoIkJhZCBtb2RlXG4iKTsKICAgIHJldHVybiAxOwogIH0KCiAgc3Ry
dWN0IHNpZ2FjdGlvbiBzYTsKICBzYS5zYV9oYW5kbGVyID0gaGFuZGxlcjsKICBzaWdlbXB0eXNl
dCgmc2Euc2FfbWFzayk7CiAgc2Euc2FfZmxhZ3MgPSAwOwogIGlmIChzaWdhY3Rpb24oU0lHSU5U
LCAmc2EsIDApICE9IDApIHsKICAgIHBlcnJvcigic2lnYWN0aW9uIik7CiAgICBleGl0KDEpOwog
IH0KCiAgaWYgKHdyaXRlKQogICAgZG9fd3JpdGUoYXJndlsyXSk7CiAgZWxzZQogICAgZG9fcmVh
ZChhcmd2WzJdKTsKCiAgcmV0dXJuIDA7Cn0K
--20cf307f39b49774cc049f96f513--
