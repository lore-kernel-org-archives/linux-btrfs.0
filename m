Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:61274 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751582AbdJXGBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 02:01:21 -0400
Received: from mail-yw0-f172.google.com ([209.85.161.172]) by
 mrelay.perfora.net (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0MMV5c-1e7PRO16ru-008GVw for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017
 08:01:20 +0200
Received: by mail-yw0-f172.google.com with SMTP id t71so14113257ywc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 23:01:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com> <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
From: Zak Kohler <y2k@y2kbugger.com>
Date: Tue, 24 Oct 2017 02:00:49 -0400
Message-ID: <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, it is finding much more than just one error.

>From dmesg
[89520.441354] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 2615801759 expected csum 874979996

$ sudo btrfs scrub start --offline --progress /dev/sdn
ERROR: data at bytenr 68431499264 mirror 1 csum mismatch, have
0x5aa0d40f expect 0xd4a15873
ERROR: extent 68431474688 len 14467072 CORRUPTED, all mirror(s)
corrupted, can't be repaired
ERROR: data at bytenr 83646357504 mirror 1 csum mismatch, have
0xfc0baabe expect 0x7f9cb681
ERROR: extent 83519741952 len 134217728 CORRUPTED, all mirror(s)
corrupted, can't be repaired
ERROR: data at bytenr 121936633856 mirror 1 csum mismatch, have
0x507016a5 expect 0x50609afe
ERROR: extent 121858334720 len 134217728 CORRUPTED, all mirror(s)
corrupted, can't be repaired
ERROR: data at bytenr 144872591360 mirror 1 csum mismatch, have
0x33964d73 expect 0xf9937032
ERROR: extent 144822386688 len 61231104 CORRUPTED, all mirror(s)
corrupted, can't be repaired
ERROR: data at bytenr 167961075712 mirror 1 csum mismatch, have
0xf43bd0e3 expect 0x5be589bb
ERROR: extent 167950999552 len 27537408 CORRUPTED, all mirror(s)
corrupted, can't be repaired
ERROR: data at bytenr 175643619328 mirror 1 csum mismatch, have
0x1e168ca1 expect 0xd413b1e0
ERROR: data at bytenr 175643754496 mirror 1 csum mismatch, have
0x6cfdc8ae expect 0xa6f8f5ef
ERROR: extent 175640539136 len 6381568 CORRUPTED, all mirror(s)
corrupted, can't be repaired
ERROR: data at bytenr 183316750336 mirror 1 csum mismatch, have
0x145bdf76 expect 0x7390565e
.....
and the list goes on.


Questions:
1. Using "find /mnt -inum 4708" I can link the dmesg to a specific
file. Is there a
way link the the --offline ERRORs above to the inode?

2. How could do "btrfs device stats /mnt" and normal full scrub fail
to detect the csum errors?

3. Do these errors appear to be hardware failure (despite pristine
SMART), user error on
volume creation/mounting, or an actual btrfs issue? I feel that the
need for question #1
indicates a problem with btrfs regardless of whether there is a real
hardware failure or not.


Next I will try an online scrub of only the sdn device, as before I
was running the full filesystem scrub.

On Tue, Oct 24, 2017 at 12:52 AM, Lakshmipathi.G
<lakshmipathi.g@gmail.com> wrote:
>> Does anyone know why scrub did not catch these errors that show up in dmesg?
>
> Can you try offline scrub from this repo
> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub and see
> whether it
> detects the issue?  "btrfs scrub start --offline <dev>"
>
>
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
