Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:37583 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaIVI6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 04:58:35 -0400
Received: by mail-yk0-f182.google.com with SMTP id 20so1202235yks.27
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 01:58:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKFHe2RwgjBDCEd6D4jva8QFou=gj8Pzd2auFUNyHFNephrYTw@mail.gmail.com>
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
	<1411261282-26831-4-git-send-email-xnox@debian.org>
	<CAKFHe2RwgjBDCEd6D4jva8QFou=gj8Pzd2auFUNyHFNephrYTw@mail.gmail.com>
Date: Mon, 22 Sep 2014 09:58:34 +0100
Message-ID: <CANBHLUghtYatMgdGHDunp4osE16Ve2urTcmK9u963scOgiFwHg@mail.gmail.com>
Subject: Re: [PATCH 4/4] Default to acting like fsck.
From: Dimitri John Ledkov <xnox@debian.org>
To: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21 September 2014 13:59, Tobias Geerinckx-Rice
<tobias.geerinckx.rice@gmail.com> wrote:
> On 21 September 2014 03:01, Dimitri John Ledkov <xnox@debian.org> wrote:
>>
>> Inspect arguments, if we are not called as btrfs, then assume we are
>> called to act like fsck.
> [...]
>> -       if (!strcmp(bname, "btrfsck")) {
>> +       if (strcmp(bname, "btrfs") != 0) {
>
> That's assuming a lot.
>
> Silently (!) breaking people's btrfs-3.15_patched-DontRandomlyPanicV2
> is a recipe for needless hair-pulling. Is there a reason for not using
> something less like strstr(bname, "fsck") that I am missing?
>

Quite. This is verbatim patch as I have currently applied in Debian
packaging, and it was a fast fix to prevent breakage we had at one
point.

Indeed using "strstr(bname, "fsck")" would be better and sufficient to
resolve the problem we encountered (specifically fsck.btrfs -> btrfs
not acting like btrfs). Also using strstr, would fix btrfsck.my-build
to act like fsck tool.

I'll update this one patch.

-- 
Regards,

Dimitri.
