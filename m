Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36331 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbdKUF6h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 00:58:37 -0500
Received: by mail-oi0-f65.google.com with SMTP id n16so7799244oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 21:58:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com> <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com> <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
 <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com> <CAJCQCtS6tXcKRuwZiAfB8eUkENz6secVcvxYS=syCFp_VH_+Vw@mail.gmail.com>
 <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com> <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>
 <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 22:58:35 -0700
Message-ID: <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="001a113cca14cc213b055e77e4e7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a113cca14cc213b055e77e4e7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2017 at 9:58 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 12:49, Chris Murphy wrote:
>> On Mon, Nov 20, 2017 at 9:43 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>>
>>>
>>>>
>>>> Apply in addition to previous patch? Or apply to clean v4.14?
>>>
>>> On previous patch.
>>
>> Refuses to apply with or without previous patch.
>>
>> $ git apply -v ~/qufstrim3.patch
>> Checking patch fs/btrfs/extent-tree.c...
>> error: while searching for:
>>        int dev_ret =3D 0;
>>        int ret =3D 0;
>>
>>        /*
>>         * try to trim all FS space, our block group may start from non-z=
ero.
>>         */
>>
>> error: patch failed: fs/btrfs/extent-tree.c:10972
>> error: fs/btrfs/extent-tree.c: patch does not apply
>>
>
> Please try this branch.
>
> It's just previous patch and diff merged together and applied on v4.14
> tag from torvalds.
>
> https://github.com/adam900710/linux/tree/tmp

# fstrim -v /
/: 38 GiB (40767586304 bytes) trimmed
# dmesg

..snip...
[   46.408792] BTRFS info (device nvme0n1p8): trimming btrfs, start=3D0
len=3D75161927680 minlen=3D512
[   46.408800] BTRFS info (device nvme0n1p8): bg start=3D140882477056
len=3D1073741824
[   46.433867] BTRFS info (device nvme0n1p8): trimming done

Attaching 'btrfs-debug -b /' to get an idea about the block groups present.



--=20
Chris Murphy

--001a113cca14cc213b055e77e4e7
Content-Type: text/plain; charset="US-ASCII"; name="btrfsdebugbg.txt"
Content-Disposition: attachment; filename="btrfsdebugbg.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ja97jj1d1

JCBzdWRvIH4vQXBwbGljYXRpb25zL2J0cmZzLWRlYnVnZnMgLWIgLwpibG9jayBncm91cCBvZmZz
ZXQgICAxNDA4ODI0NzcwNTYgbGVuIDEwNzM3NDE4MjQgdXNlZCAgNjYzNTY0Mjg4IGNodW5rX29i
amVjdGlkIDI1NiBmbGFncyAxIHVzYWdlIDAuNjIKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAgMTQxOTU2
MjE4ODgwIGxlbiAxMDczNzQxODI0IHVzZWQgIDc3NDc4Mjk3NiBjaHVua19vYmplY3RpZCAyNTYg
ZmxhZ3MgMSB1c2FnZSAwLjcyCmJsb2NrIGdyb3VwIG9mZnNldCAgIDE0MzAyOTk2MDcwNCBsZW4g
MTA3Mzc0MTgyNCB1c2VkICA1NTk3NTkzNjAgY2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNh
Z2UgMC41MgpibG9jayBncm91cCBvZmZzZXQgICAxNDQxMDM3MDI1MjggbGVuIDEwNzM3NDE4MjQg
dXNlZCAgNzE5ODcyMDAwIGNodW5rX29iamVjdGlkIDI1NiBmbGFncyAxIHVzYWdlIDAuNjcKYmxv
Y2sgZ3JvdXAgb2Zmc2V0ICAgMTQ1MTc3NDQ0MzUyIGxlbiAxMDczNzQxODI0IHVzZWQgIDQwNzY5
OTQ1NiBjaHVua19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1c2FnZSAwLjM4CmJsb2NrIGdyb3VwIG9m
ZnNldCAgIDE0NjI1MTE4NjE3NiBsZW4gMTA3Mzc0MTgyNCB1c2VkICA0NDY0MTQ4NDggY2h1bmtf
b2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2UgMC40MgpibG9jayBncm91cCBvZmZzZXQgICAxNDcz
MjQ5MjgwMDAgbGVuIDEwNzM3NDE4MjQgdXNlZCAgNjQ3MjU0MDE2IGNodW5rX29iamVjdGlkIDI1
NiBmbGFncyAxIHVzYWdlIDAuNjAKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAgMTQ4Mzk4NjY5ODI0IGxl
biAxMDczNzQxODI0IHVzZWQgIDY5NTkwNjMwNCBjaHVua19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1
c2FnZSAwLjY1CmJsb2NrIGdyb3VwIG9mZnNldCAgIDE0OTQ3MjQxMTY0OCBsZW4gMTA3Mzc0MTgy
NCB1c2VkICA2NTUxNzU2ODAgY2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2UgMC42MQpi
bG9jayBncm91cCBvZmZzZXQgICAxNTA1NDYxNTM0NzIgbGVuIDEwNzM3NDE4MjQgdXNlZCAgNzAw
OTMyMDk2IGNodW5rX29iamVjdGlkIDI1NiBmbGFncyAxIHVzYWdlIDAuNjUKYmxvY2sgZ3JvdXAg
b2Zmc2V0ICAgMTUxNjE5ODk1Mjk2IGxlbiAxMDczNzQxODI0IHVzZWQgIDgyMjYyMDE2MCBjaHVu
a19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1c2FnZSAwLjc3CmJsb2NrIGdyb3VwIG9mZnNldCAgIDE1
MjY5MzYzNzEyMCBsZW4gMTA3Mzc0MTgyNCB1c2VkICA3ODcyMjY2MjQgY2h1bmtfb2JqZWN0aWQg
MjU2IGZsYWdzIDEgdXNhZ2UgMC43MwpibG9jayBncm91cCBvZmZzZXQgICAxNTM3NjczNzg5NDQg
bGVuIDEwNzM3NDE4MjQgdXNlZCAgNzUxOTI3Mjk2IGNodW5rX29iamVjdGlkIDI1NiBmbGFncyAx
IHVzYWdlIDAuNzAKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAgMTU1OTQ4NDE3MDI0IGxlbiAxMDczNzQx
ODI0IHVzZWQgIDYxMTc5NDk0NCBjaHVua19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1c2FnZSAwLjU3
CmJsb2NrIGdyb3VwIG9mZnNldCAgIDE1NzAyMjE1ODg0OCBsZW4gMTA3Mzc0MTgyNCB1c2VkICAy
ODQ4MzE3NDQgY2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2UgMC4yNwpibG9jayBncm91
cCBvZmZzZXQgICAxNTgwOTU5MDA2NzIgbGVuIDEwNzM3NDE4MjQgdXNlZCAgMTc2MTg5NDQwIGNo
dW5rX29iamVjdGlkIDI1NiBmbGFncyAxIHVzYWdlIDAuMTYKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAg
MTU5MTY5NjQyNDk2IGxlbiAxMDczNzQxODI0IHVzZWQgIDUzMDA5MjAzMiBjaHVua19vYmplY3Rp
ZCAyNTYgZmxhZ3MgMSB1c2FnZSAwLjQ5CmJsb2NrIGdyb3VwIG9mZnNldCAgIDE2MTMxNzEyNjE0
NCBsZW4gMTA3Mzc0MTgyNCB1c2VkICA5NTc3NzU4NzIgY2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdz
IDEgdXNhZ2UgMC44OQpibG9jayBncm91cCBvZmZzZXQgICAxNjIzOTA4Njc5NjggbGVuIDEwNzM3
NDE4MjQgdXNlZCAgNzAzOTEzOTg0IGNodW5rX29iamVjdGlkIDI1NiBmbGFncyAxIHVzYWdlIDAu
NjYKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAgMTYzNDY0NjA5NzkyIGxlbiAxMDczNzQxODI0IHVzZWQg
IDE1OTkxMTkzNiBjaHVua19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1c2FnZSAwLjE1CmJsb2NrIGdy
b3VwIG9mZnNldCAgIDE2NjY4NTgzNTI2NCBsZW4gMTA3Mzc0MTgyNCB1c2VkICAxNTYyMTczNDQg
Y2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2UgMC4xNQpibG9jayBncm91cCBvZmZzZXQg
ICAxNjc3NTk1NzcwODggbGVuIDEwNzM3NDE4MjQgdXNlZCAgMTIwODgxMTUyIGNodW5rX29iamVj
dGlkIDI1NiBmbGFncyAxIHVzYWdlIDAuMTEKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAgMTY4ODMzMzE4
OTEyIGxlbiAxMDczNzQxODI0IHVzZWQgIDY5MjA2MDE2MCBjaHVua19vYmplY3RpZCAyNTYgZmxh
Z3MgMSB1c2FnZSAwLjY0CmJsb2NrIGdyb3VwIG9mZnNldCAgIDE2OTkwNzA2MDczNiBsZW4gMTA3
Mzc0MTgyNCB1c2VkICA0Mjg0MDQ3MzYgY2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2Ug
MC40MApibG9jayBncm91cCBvZmZzZXQgICAxNzA5ODA4MDI1NjAgbGVuIDEwNzM3NDE4MjQgdXNl
ZCAgNzgyMzcyODY0IGNodW5rX29iamVjdGlkIDI1NiBmbGFncyAxIHVzYWdlIDAuNzMKYmxvY2sg
Z3JvdXAgb2Zmc2V0ICAgMTcyMDU0NTQ0Mzg0IGxlbiAxMDczNzQxODI0IHVzZWQgIDUzMzE4MDQx
NiBjaHVua19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1c2FnZSAwLjUwCmJsb2NrIGdyb3VwIG9mZnNl
dCAgIDE3MzEyODI4NjIwOCBsZW4gMTA3Mzc0MTgyNCB1c2VkICA4OTE1NzIyMjQgY2h1bmtfb2Jq
ZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2UgMC44MwpibG9jayBncm91cCBvZmZzZXQgICAxNzc0MjMy
NTM1MDQgbGVuIDEwNzM3NDE4MjQgdXNlZCAxMDI1MzMxMjAwIGNodW5rX29iamVjdGlkIDI1NiBm
bGFncyAxIHVzYWdlIDAuOTUKYmxvY2sgZ3JvdXAgb2Zmc2V0ICAgMTc5NTcwNzM3MTUyIGxlbiAx
MDczNzQxODI0IHVzZWQgMTA1ODkyNjU5MiBjaHVua19vYmplY3RpZCAyNTYgZmxhZ3MgMSB1c2Fn
ZSAwLjk5CmJsb2NrIGdyb3VwIG9mZnNldCAgIDE4MDY0NDQ3ODk3NiBsZW4gMTA3Mzc0MTgyNCB1
c2VkICAyOTExODQ2NDAgY2h1bmtfb2JqZWN0aWQgMjU2IGZsYWdzIDEgdXNhZ2UgMC4yNwp0b3Rh
bF9mcmVlIDE0MTc0NDc4MzM2IG1pbl91c2VkIDEyMDg4MTE1MiBmcmVlX29mX21pbl91c2VkIDk1
Mjg2MDY3MiBibG9ja19ncm91cF9vZl9taW5fdXNlZCAxNjc3NTk1NzcwODgKYmFsYW5jZSBibG9j
ayBncm91cCAoMTY3NzU5NTc3MDg4KSBjYW4gcmVkdWNlIHRoZSBudW1iZXIgb2YgZGF0YSBibG9j
ayBncm91cApbY2hyaXNAZjI3aCB+XSQgCgo=
--001a113cca14cc213b055e77e4e7--
