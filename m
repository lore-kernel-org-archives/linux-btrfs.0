Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:45796 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdARHNO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 02:13:14 -0500
From: Christoph Groth <christoph@grothesque.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: gdb log of crashed "btrfs-image -s"
References: <87o9z7dzvd.fsf@grothesque.org>
        <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
        <871sw2cbzb.fsf@grothesque.org>
        <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
        <87lgu9cu2v.fsf@grothesque.org>
        <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
        <877f5tcmgk.fsf@grothesque.org>
Date: Wed, 18 Jan 2017 08:13:05 +0100
In-Reply-To: <877f5tcmgk.fsf@grothesque.org> (Christoph Groth's message of
        "Wed, 18 Jan 2017 00:10:03 +0100")
Message-ID: <87wpdsc03i.fsf_-_@grothesque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; format=flowed

Christoph Groth wrote:
> Chris Murphy wrote:
>> On Tue, Jan 17, 2017 at 1:25 PM, Christoph Groth
>> <christoph@grothesque.org> wrote:
>>> Any ideas on what could be done?  If you need help to debug 
>>> the problem with
>>> btrfs-image, please tell me what I should do.  I can keep the 
>>> broken file
>>> system around until an image can be created at some later 
>>> time.
>>
>> Try 4.9, or even 4.8.5, tons of bugs have been fixed since 
>> 4.7.3
>> although I don't know off hand if this particular bug is 
>> fixed. I did
>> recently do a btrfs-image with btrfs-progs v4.9 with -s and did 
>> not
>> get a segfault.
>
> I compiled btrfs-image.static from btrfs-tools 4.9 (from git) 
> and started it from Debian testing's initramfs.  The exact 
> command that I use is:
>
> /mnt/btrfs-image.static -c3 -s /dev/sda2 /mnt/mim-s.bim
>
> It runs for a couple of seconds (enough to write 20263936 bytes 
> of output) and then quits with
>
> *** Error in `/mnt/btrfs-image.static`: double free or 
> corruption  (!prev): 0x00000000009f0940 ***
> ====== Backtrace: ======
> [0x45fb97]
> [0x465442]
> [0x465c1e]
> [0x402694]
> [0x402dcb]
> [0x4031fe]
> [0x4050ff]
> [0x405783]
> [0x44cb73]
> [0x44cdfe]
> [0x400b2a]
>
> (I had to type the above off the other screen, but I double 
> checked that there are no errors.)
>
> The executable that I used can be downloaded from 
> http://groth.fr/btrfs-image.static
> Its md5sum is 48abbc82ac6d3c0cb88cba1e5edb85fd.
>
> I hope that this can help someone to see what's going on.

I ran the same executable under gdb from a live system.  The log 
is attached.


--=-=-=
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=btrfs-image.log
Content-Transfer-Encoding: base64

cm9vdEB4dWJ1bnR1Oi9tZWRpYS94dWJ1bnR1L3dkMXQjIGdkYiBidHJmcy1pbWFnZS5zdGF0aWMK
R05VIGdkYiAoVWJ1bnR1IDcuMTEtMHVidW50dTEpIDcuMTEKQ29weXJpZ2h0IChDKSAyMDE2IEZy
ZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgSW5jLgpMaWNlbnNlIEdQTHYzKzogR05VIEdQTCB2ZXJz
aW9uIDMgb3IgbGF0ZXIgPGh0dHA6Ly9nbnUub3JnL2xpY2Vuc2VzL2dwbC5odG1sPgpUaGlzIGlz
IGZyZWUgc29mdHdhcmU6IHlvdSBhcmUgZnJlZSB0byBjaGFuZ2UgYW5kIHJlZGlzdHJpYnV0ZSBp
dC4KVGhlcmUgaXMgTk8gV0FSUkFOVFksIHRvIHRoZSBleHRlbnQgcGVybWl0dGVkIGJ5IGxhdy4g
IFR5cGUgInNob3cgY29weWluZyIKYW5kICJzaG93IHdhcnJhbnR5IiBmb3IgZGV0YWlscy4KVGhp
cyBHREIgd2FzIGNvbmZpZ3VyZWQgYXMgIng4Nl82NC1saW51eC1nbnUiLgpUeXBlICJzaG93IGNv
bmZpZ3VyYXRpb24iIGZvciBjb25maWd1cmF0aW9uIGRldGFpbHMuCkZvciBidWcgcmVwb3J0aW5n
IGluc3RydWN0aW9ucywgcGxlYXNlIHNlZToKPGh0dHA6Ly93d3cuZ251Lm9yZy9zb2Z0d2FyZS9n
ZGIvYnVncy8+LgpGaW5kIHRoZSBHREIgbWFudWFsIGFuZCBvdGhlciBkb2N1bWVudGF0aW9uIHJl
c291cmNlcyBvbmxpbmUgYXQ6CjxodHRwOi8vd3d3LmdudS5vcmcvc29mdHdhcmUvZ2RiL2RvY3Vt
ZW50YXRpb24vPi4KRm9yIGhlbHAsIHR5cGUgImhlbHAiLgpUeXBlICJhcHJvcG9zIHdvcmQiIHRv
IHNlYXJjaCBmb3IgY29tbWFuZHMgcmVsYXRlZCB0byAid29yZCIuLi4KUmVhZGluZyBzeW1ib2xz
IGZyb20gYnRyZnMtaW1hZ2Uuc3RhdGljLi4uZG9uZS4KKGdkYikgcnVuIC1jMyAtcyAvZGV2L3Nk
YTIgL21lZGlhL3h1YnVudHUvd2QxdC9taW0tcy5iaW0KU3RhcnRpbmcgcHJvZ3JhbTogL21lZGlh
L3h1YnVudHUvd2QxdC9idHJmcy1pbWFnZS5zdGF0aWMgLWMzIC1zIC9kZXYvc2RhMiAvbWVkaWEv
eHVidW50dS93ZDF0L21pbS1zLmJpbQpbTmV3IExXUCAyMzM0XQpbTmV3IExXUCAyMzM1XQpbTmV3
IExXUCAyMzM2XQpbTmV3IExXUCAyMzM3XQoqKiogRXJyb3IgaW4gYC9tZWRpYS94dWJ1bnR1L3dk
MXQvYnRyZnMtaW1hZ2Uuc3RhdGljJzogZnJlZSgpOiBpbnZhbGlkIG5leHQgc2l6ZSAobm9ybWFs
KTogMHgwMDAwMDAwMDAwNzYyNTcwICoqKgo9PT09PT09IEJhY2t0cmFjZTogPT09PT09PT09Clsw
eDQ1ZmI5N10KWzB4NDY1NDQyXQpbMHg0NjVjMWVdClsweDQwMmRlYV0KWzB4NDAzMWZlXQpbMHg0
MDUwZmZdClsweDQwNTc4M10KWzB4NDRjYjczXQpbMHg0NGNkZmVdClsweDQwMGIyYV0KPT09PT09
PSBNZW1vcnkgbWFwOiA9PT09PT09PQowMDQwMDAwMC0wMDUyMTAwMCByLXhwIDAwMDAwMDAwIDA4
OjMxIDY4OSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgL21lZGlhL3h1YnVudHUvd2Qx
dC9idHJmcy1pbWFnZS5zdGF0aWMKMDA3MjEwMDAtMDA3MjgwMDAgcnctcCAwMDEyMTAwMCAwODoz
MSA2ODkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC9tZWRpYS94dWJ1bnR1L3dkMXQv
YnRyZnMtaW1hZ2Uuc3RhdGljCjAwNzI4MDAwLTAwODViMDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAg
MCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbaGVhcF0KN2ZmZmUwMDAwMDAwLTdm
ZmZlMDFhYTAwMCBydy1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmZmZlMDFhYTAwMC03ZmZmZTQwMDAw
MDAgLS0tcCAwMDAwMDAwMCAwMDowMCAwIAo3ZmZmZTQwMDAwMDAtN2ZmZmU0MDI1MDAwIHJ3LXAg
MDAwMDAwMDAgMDA6MDAgMCAKN2ZmZmU0MDI1MDAwLTdmZmZlODAwMDAwMCAtLS1wIDAwMDAwMDAw
IDAwOjAwIDAgCjdmZmZlODAwMDAwMC03ZmZmZTgxODYwMDAgcnctcCAwMDAwMDAwMCAwMDowMCAw
IAo3ZmZmZTgxODYwMDAtN2ZmZmVjMDAwMDAwIC0tLXAgMDAwMDAwMDAgMDA6MDAgMCAKN2ZmZmVj
MDAwMDAwLTdmZmZlYzE5NTAwMCBydy1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmZmZlYzE5NTAwMC03
ZmZmZjAwMDAwMDAgLS0tcCAwMDAwMDAwMCAwMDowMCAwIAo3ZmZmZjAwMDAwMDAtN2ZmZmYwMWIw
MDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAKN2ZmZmYwMWIwMDAwLTdmZmZmNDAwMDAwMCAtLS1w
IDAwMDAwMDAwIDAwOjAwIDAgCjdmZmZmNWZmNjAwMC03ZmZmZjVmZjcwMDAgcnctcCAwMDAwMDAw
MCAwMDowMCAwIAo3ZmZmZjVmZjcwMDAtN2ZmZmY1ZmY4MDAwIC0tLXAgMDAwMDAwMDAgMDA6MDAg
MCAKN2ZmZmY1ZmY4MDAwLTdmZmZmNjdmODAwMCBydy1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmZmZm
NjdmODAwMC03ZmZmZjY3ZjkwMDAgLS0tcCAwMDAwMDAwMCAwMDowMCAwIAo3ZmZmZjY3ZjkwMDAt
N2ZmZmY2ZmY5MDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAKN2ZmZmY2ZmY5MDAwLTdmZmZmNmZm
YTAwMCAtLS1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmZmZmNmZmYTAwMC03ZmZmZjc3ZmEwMDAgcnct
cCAwMDAwMDAwMCAwMDowMCAwIAo3ZmZmZjc3ZmEwMDAtN2ZmZmY3N2ZiMDAwIC0tLXAgMDAwMDAw
MDAgMDA6MDAgMCAKN2ZmZmY3N2ZiMDAwLTdmZmZmN2ZmYjAwMCBydy1wIDAwMDAwMDAwIDAwOjAw
IDAgCjdmZmZmN2ZmYjAwMC03ZmZmZjdmZmQwMDAgci0tcCAwMDAwMDAwMCAwMDowMCAwICAgICAg
ICAgICAgICAgICAgICAgICAgICBbdnZhcl0KN2ZmZmY3ZmZkMDAwLTdmZmZmN2ZmZjAwMCByLXhw
IDAwMDAwMDAwIDAwOjAwIDAgICAgICAgICAgICAgICAgICAgICAgICAgIFt2ZHNvXQo3ZmZmZmZm
ZGUwMDAtN2ZmZmZmZmZmMDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAgICAgICAgICAgICAgICAg
ICAgICAgICAgW3N0YWNrXQpmZmZmZmZmZmZmNjAwMDAwLWZmZmZmZmZmZmY2MDEwMDAgci14cCAw
MDAwMDAwMCAwMDowMCAwICAgICAgICAgICAgICAgICAgW3ZzeXNjYWxsXQoKVGhyZWFkIDEgImJ0
cmZzLWltYWdlLnN0YSIgcmVjZWl2ZWQgc2lnbmFsIFNJR0FCUlQsIEFib3J0ZWQuCjB4MDAwMDAw
MDAwMDQ1MjFkZSBpbiByYWlzZSAoKQooZ2RiKSBidAojMCAgMHgwMDAwMDAwMDAwNDUyMWRlIGlu
IHJhaXNlICgpCiMxICAweDAwMDAwMDAwMDA0NTIzYWEgaW4gYWJvcnQgKCkKIzIgIDB4MDAwMDAw
MDAwMDQ1ZmI5YyBpbiBfX2xpYmNfbWVzc2FnZSAoKQojMyAgMHgwMDAwMDAwMDAwNDY1NDQyIGlu
IG1hbGxvY19wcmludGVyciAoKQojNCAgMHgwMDAwMDAwMDAwNDY1YzFlIGluIF9pbnRfZnJlZSAo
KQojNSAgMHgwMDAwMDAwMDAwNDAyZGVhIGluIHNhbml0aXplX25hbWUgKHNsb3Q9PG9wdGltaXpl
ZCBvdXQ+LCBrZXk9PHN5bnRoZXRpYyBwb2ludGVyPiwgc3JjPTxvcHRpbWl6ZWQgb3V0PiwgZHN0
PTB4NzZjNjkwICI0XDI0NiIsIDxpbmNvbXBsZXRlIHNlcXVlbmNlIFwzNjdcMjYxPiwgCiAgICBt
ZD08b3B0aW1pemVkIG91dD4pIGF0IGltYWdlL21haW4uYzo1NzQKIzYgIHplcm9faXRlbXMgKHNy
Yz0weDc2MDQ1MCwgZHN0PTB4NzZjNjkwICI0XDI0NiIsIDxpbmNvbXBsZXRlIHNlcXVlbmNlIFwz
NjdcMjYxPiwgbWQ9PG9wdGltaXplZCBvdXQ+KSBhdCBpbWFnZS9tYWluLmM6NjAyCiM3ICBjb3B5
X2J1ZmZlciAoc3JjPTB4NzYwNDUwLCBkc3Q9MHg3NmM2OTAgIjRcMjQ2IiwgPGluY29tcGxldGUg
c2VxdWVuY2UgXDM2N1wyNjE+LCBtZD08b3B0aW1pemVkIG91dD4pIGF0IGltYWdlL21haW4uYzo2
NDUKIzggIGZsdXNoX3BlbmRpbmcgKG1kPW1kQGVudHJ5PTB4N2ZmZmZmZmZkZGMwLCBkb25lPWRv
bmVAZW50cnk9MCkgYXQgaW1hZ2UvbWFpbi5jOjk4MwojOSAgMHgwMDAwMDAwMDAwNDAzMWZlIGlu
IGFkZF9leHRlbnQgKHN0YXJ0PXN0YXJ0QGVudHJ5PTE5MjU5MzkyMCwgc2l6ZT1zaXplQGVudHJ5
PTQwOTYsIG1kPW1kQGVudHJ5PTB4N2ZmZmZmZmZkZGMwLCBkYXRhPWRhdGFAZW50cnk9MCkgYXQg
aW1hZ2UvbWFpbi5jOjEwMjUKIzEwIDB4MDAwMDAwMDAwMDQwNTBmZiBpbiBjb3B5X2Zyb21fZXh0
ZW50X3RyZWUgKHBhdGg9MHg3ZmZmZmZmZmUzOTAsIG1ldGFkdW1wPTB4N2ZmZmZmZmZkZGMwKSBh
dCBpbWFnZS9tYWluLmM6MTI4MAojMTEgY3JlYXRlX21ldGFkdW1wIChpbnB1dD1pbnB1dEBlbnRy
eT0weDdmZmZmZmZmZTg1MSAiL2Rldi9zZGEyIiwgb3V0PW91dEBlbnRyeT0weDczMWJlMCwgbnVt
X3RocmVhZHM9bnVtX3RocmVhZHNAZW50cnk9NCwgY29tcHJlc3NfbGV2ZWw9Y29tcHJlc3NfbGV2
ZWxAZW50cnk9MywgCiAgICBzYW5pdGl6ZT1zYW5pdGl6ZUBlbnRyeT0xLCB3YWxrX3RyZWVzPXdh
bGtfdHJlZXNAZW50cnk9MCkgYXQgaW1hZ2UvbWFpbi5jOjEzNzAKIzEyIDB4MDAwMDAwMDAwMDQw
NTc4MyBpbiBtYWluIChhcmdjPTxvcHRpbWl6ZWQgb3V0PiwgYXJndj0weDdmZmZmZmZmZTVkOCkg
YXQgaW1hZ2UvbWFpbi5jOjI4NTUK
--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUimQV/rXmWU8TwiKw/FH9ZgPNTUFAlh/FYEACgkQw/FH9ZgP
NTW/VxAAwTXiB/Gtmx5I4P+9s9hR6wB4GelvHjAPzYD9kP8dfMlju+1u+wUdbmXR
/puD36qxvfxwdExSMXsLCEkilCQi6uMK0GlAB0L8yRSqCFZDKSu2KjGYLaIUI8X4
0uNkgI8NvY1HWU3DpHaJOY/gOsp2D9ho+1Og+s/die0E11x08qDdcDp8LqYLhjD/
tlgcTJH8kzzWAY2PK54AoZB87NsGvHIVSd7Hs7ZOGucj4jLUvjhc6ApG2xjwPLR3
jbmkvi13zt0OGKKYD79nKwo/USiG/tlOiYmAsO+qtSnvm4PCiQUuFDA574MenkD8
ISztkMxaLPKg8NxQDzTVzLeYGCKcs/y9uTEZ1Nr4HOZJIekcHqHAVpNEGS7Ujl2R
6cdjIEKMSXfR9qHX+F8uz0rdIaJdWGzF3lR1rjehuEzsEZ/Q/DSBPXWnX7scsPiM
6uangrBjxBfcmYVX5hnu7hMGPuXci0fDAn/qF/uZFc5XhrATl3nWlTKlI6UlPnG9
liI8j4mNLUQlEcGq8r36+nlRjO202y/q9Vp6znJjDX9wUNOwzGuJB7T8GAD5iP8Q
92LfpdVOUv13VxpUW3Fo4n6pjCZsnaawplo+qryxDE7X6atV5Hkgu8QlBVwX+v1w
E6v/UJgXHFPmBYEYCsOntFemv03zxRABiwonTzVRFxxNrE6Pkzs=
=Q5sx
-----END PGP SIGNATURE-----
--==-=-=--
