Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36347 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcIMUjQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 16:39:16 -0400
Received: by mail-qk0-f170.google.com with SMTP id z190so178441077qkc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 13:39:15 -0700 (PDT)
Subject: Re: Filesystem forced to readonly after use
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
 <53969836-4a5a-f842-6156-3f88a78bfc4e@gmail.com>
From: Cesar Strauss <cestrauss@gmail.com>
Message-ID: <3756c0ee-4f64-7974-932c-0a1615c658c8@gmail.com>
Date: Tue, 13 Sep 2016 17:39:12 -0300
MIME-Version: 1.0
In-Reply-To: <53969836-4a5a-f842-6156-3f88a78bfc4e@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------C76DF60A3174CC6F2521A1DA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------C76DF60A3174CC6F2521A1DA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13-09-2016 16:49, Austin S. Hemmelgarn wrote:
> I'd be kind of curious to see the results from btrfs check run without
> repair, but I doubt that will help narrow things down any further.

Attached.

>
> As of right now, the absolute first thing I'd do is check your logs to
> see if you can find any indication of errors from the disk itself.  I
> don't think it's likely, but it's worth checking.

Will do.

> The couple of lines just before the crash in the attached kernel log
> would indicate to me that some of the metadata is corrupted.  There are
> two likely possibilities for how that happened:
> 1. Running with no extra space for new chunks to be allocated is not a
> common use case, so it's not well tested, and it wouldn't surprise me if
> some accounting falls apart in that situation.

Indeed. I periodically remove old snapshots and check for disk space, 
bit I guess I ran a bit too near the limit this time.

> 2. You might have bad RAM or a bad PSU.  This is the second thing you
> should check after checking to see if the disk is OK, as either will
> likely cause any repair attempts to make things worse.  RAM is pretty
> easy to check, but for a PSU you need a proper testing device.  You can
> get such a device on Amazon or similar sites for about 25USD, and it's
> generally worth having around for troubleshooting.

Understood.

This notebook has occasional failures when resuming from hibernation. I 
suppose, from the point of view of the filesystem, this corresponds to 
an unclean reboot.

>
> Assuming your disk and RAM are good, the next thing to do would be try
> and get the filesystem into a more usable state.  The best option for
> this is to expand the filesystem if possible.  Given that you're running
> right near capacity, I'd suggest at least 16G of extra space if
> possible.  If that isn't a viable solution for you, the other option is
> to delete some of the oldest snapshots (Ideally enough that you have at
> least a few GB of extra space in the data chunks and a few hundred MB in
> the metadata chunks), then add a 4-8GB device to the FS temporarily (a
> ramdisk or flash drive works well for this), and run a full balance.  If
> you're lucky, this will fix any metadata that's messed up, and the
> system should be usable.  If not, it shouldn't make things any worse,
> and you probably want to look at btrfs restore to copy out the data to a
> new filesystem (ideally a bigger one).

I will try this next.

Thanks for the help!

Cesar


--------------C76DF60A3174CC6F2521A1DA
Content-Type: text/plain; charset=UTF-8;
 name="btrfs.check"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs.check"

Y2hlY2tpbmcgZXh0ZW50cwpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQy
MDc3Mzg4OCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MwpwYXJlbnQgdHJhbnNpZCB2ZXJp
ZnkgZmFpbGVkIG9uIDE2MDQyMDc3Mzg4OCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3Mwpw
YXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQyMDc3Mzg4OCB3YW50ZWQgMTgx
ODI2IGZvdW5kIDE4MTU3MwpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQy
MDc3Mzg4OCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MwpJZ25vcmluZyB0cmFuc2lkIGZh
aWx1cmUKbGVhZiBwYXJlbnQga2V5IGluY29ycmVjdCAxNjA0MjA3NzM4ODgKcGFyZW50IHRy
YW5zaWQgdmVyaWZ5IGZhaWxlZCBvbiAxNjA0MjA3NzM4ODggd2FudGVkIDE4MTgyNiBmb3Vu
ZCAxODE1NzMKSWdub3JpbmcgdHJhbnNpZCBmYWlsdXJlCmxlYWYgcGFyZW50IGtleSBpbmNv
cnJlY3QgMTYwNDIwNzczODg4CnBhcmVudCB0cmFuc2lkIHZlcmlmeSBmYWlsZWQgb24gMTYw
NDIwNzczODg4IHdhbnRlZCAxODE4MjYgZm91bmQgMTgxNTczCklnbm9yaW5nIHRyYW5zaWQg
ZmFpbHVyZQpsZWFmIHBhcmVudCBrZXkgaW5jb3JyZWN0IDE2MDQyMDc3Mzg4OApwYXJlbnQg
dHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQyMDc3Mzg4OCB3YW50ZWQgMTgxODI2IGZv
dW5kIDE4MTU3MwpJZ25vcmluZyB0cmFuc2lkIGZhaWx1cmUKbGVhZiBwYXJlbnQga2V5IGlu
Y29ycmVjdCAxNjA0MjA3NzM4ODgKcGFyZW50IHRyYW5zaWQgdmVyaWZ5IGZhaWxlZCBvbiAx
NjA0MjA3NzM4ODggd2FudGVkIDE4MTgyNiBmb3VuZCAxODE1NzMKSWdub3JpbmcgdHJhbnNp
ZCBmYWlsdXJlCmxlYWYgcGFyZW50IGtleSBpbmNvcnJlY3QgMTYwNDIwNzczODg4CnBhcmVu
dCB0cmFuc2lkIHZlcmlmeSBmYWlsZWQgb24gMTYwNDIwNzczODg4IHdhbnRlZCAxODE4MjYg
Zm91bmQgMTgxNTczCklnbm9yaW5nIHRyYW5zaWQgZmFpbHVyZQpsZWFmIHBhcmVudCBrZXkg
aW5jb3JyZWN0IDE2MDQyMDc3Mzg4OApwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9u
IDE2MDQyMDc3Mzg4OCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MwpJZ25vcmluZyB0cmFu
c2lkIGZhaWx1cmUKbGVhZiBwYXJlbnQga2V5IGluY29ycmVjdCAxNjA0MjA3NzM4ODgKcGFy
ZW50IHRyYW5zaWQgdmVyaWZ5IGZhaWxlZCBvbiAxNjA0MjA3NzM4ODggd2FudGVkIDE4MTgy
NiBmb3VuZCAxODE1NzMKSWdub3JpbmcgdHJhbnNpZCBmYWlsdXJlCmxlYWYgcGFyZW50IGtl
eSBpbmNvcnJlY3QgMTYwNDIwNzczODg4CnBhcmVudCB0cmFuc2lkIHZlcmlmeSBmYWlsZWQg
b24gMTYwNDIwNzczODg4IHdhbnRlZCAxODE4MjYgZm91bmQgMTgxNTczCklnbm9yaW5nIHRy
YW5zaWQgZmFpbHVyZQpsZWFmIHBhcmVudCBrZXkgaW5jb3JyZWN0IDE2MDQyMDc3Mzg4OApw
YXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQxODg4OTcyOCB3YW50ZWQgMTgx
ODI2IGZvdW5kIDE4MTU3MgpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQx
ODg4OTcyOCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MgpwYXJlbnQgdHJhbnNpZCB2ZXJp
ZnkgZmFpbGVkIG9uIDE2MDQxODg4OTcyOCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3Mgpw
YXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQxODg4OTcyOCB3YW50ZWQgMTgx
ODI2IGZvdW5kIDE4MTU3MgpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQy
MDc0MTEyMCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MwpwYXJlbnQgdHJhbnNpZCB2ZXJp
ZnkgZmFpbGVkIG9uIDE2MDQyMDc0MTEyMCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3Mwpw
YXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQyMDc0MTEyMCB3YW50ZWQgMTgx
ODI2IGZvdW5kIDE4MTU3MwpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQy
MDc0MTEyMCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MwpJZ25vcmluZyB0cmFuc2lkIGZh
aWx1cmUKbGVhZiBwYXJlbnQga2V5IGluY29ycmVjdCAxNjA0MjA3NDExMjAKYmFkIGJsb2Nr
IDE2MDQyMDc0MTEyMApFcnJvcnMgZm91bmQgaW4gZXh0ZW50IGFsbG9jYXRpb24gdHJlZSBv
ciBjaHVuayBhbGxvY2F0aW9uCnBhcmVudCB0cmFuc2lkIHZlcmlmeSBmYWlsZWQgb24gMTYw
NDIwNzczODg4IHdhbnRlZCAxODE4MjYgZm91bmQgMTgxNTczCklnbm9yaW5nIHRyYW5zaWQg
ZmFpbHVyZQpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQxODg4OTcyOCB3
YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MgpwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVk
IG9uIDE2MDQxODg4OTcyOCB3YW50ZWQgMTgxODI2IGZvdW5kIDE4MTU3MgpwYXJlbnQgdHJh
bnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDE2MDQyMDc0MTEyMCB3YW50ZWQgMTgxODI2IGZvdW5k
IDE4MTU3MwpJZ25vcmluZyB0cmFuc2lkIGZhaWx1cmUKRXJyb3I6IGNvdWxkIG5vdCBmaW5k
IGJ0cmVlIHJvb3QgZXh0ZW50IGZvciByb290IDExODMKQ2hlY2tpbmcgZmlsZXN5c3RlbSBv
biAvZGV2L3NkYjUKVVVJRDogNzk4NjJjMjAtZDBiMC00ZmZhLWE5YWYtZTNhNDA4NjhhMjQz
Cg==
--------------C76DF60A3174CC6F2521A1DA--
