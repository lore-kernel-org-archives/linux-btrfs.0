Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36645C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 05:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29572184B
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 05:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaAqe/kt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfDEFY3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 01:24:29 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:39025 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbfDEFY3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 01:24:29 -0400
Received: by mail-ed1-f54.google.com with SMTP id p20so4331313eds.6
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 22:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ThMU9xMlk4cr+PDsNtYofDpBZiDfnqIjvhSTYrClGw=;
        b=jaAqe/kt8X5RFEuhN2LDumYYMc53EOXVn5JCNlIziH6YpIdegyzszJQq4Tck6uhsq7
         S5knxxe8AVUv5TzHSndM9FHoMlZseC5Rwn5LyW1XeQesfuD66Yzg4h2Q7381tMmpgQsC
         T+CvR/7HPvYhFzFiGZLfHzxluAlds1I+OKQzUfzyo5lOHfmNuUmF8g44FMp4TNHlrmIG
         NNZ3e7pMLS7CuSmy0CUso8bw338AKrgNMFyJNDLPtDCAfTV0cWk0PpbJ2lkBXSwekaga
         6t9mZUqfYH4SHB6rTKH9xrUJCZJGh/tLgR3p5RfhM+3sa6avDLhUJETPqIT/CzUmv0KX
         X+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ThMU9xMlk4cr+PDsNtYofDpBZiDfnqIjvhSTYrClGw=;
        b=iTK4c0g9QDldslSb3AuAw5osV4wBONwCGdd5tffjG4/zvu75qPtBPw1D5VF6dOft4B
         gbdcrwGeGDuitKgf9W6R8+MyjbMZktB2iT6zGSxbtZ0KJBc9YyO6MxcRx1WeOEXQKHX2
         nTpLlvCs3njfKXRR6QMcUbbZGC8vDGatr5MQzE1Vp5G2I70K3CTmiKt44f4aFO5LsnCe
         qCc++s/h0GWH0ChUqp42Y0lqUhKo43701LYThQ3LCipTzI9gQcX27E+ZNURAe9rdVqEO
         oA6086p3vU6zhmvT+l2Zpa+J9EkQ8Hqor+htkjdKe51bTinnaWI+o/xVO9J8pNXTjlOl
         LFcQ==
X-Gm-Message-State: APjAAAVx49gfi2VacGXU9FJt1iGUuOnIHapKGtSKC2lIRfQoeWr7WzBm
        ZxtGFNyPcr7HPWAS621teeCONR6h5NISSJBJ6/sr/ZlmDtY=
X-Google-Smtp-Source: APXvYqwSyb3MfOzrGyPokqm1/NBz0q8gMN2QSEwFe99Hyh1eLA+bSM4vXGWIJZbIdqy45vIcv9caCSHt4K1L0lJVjyo=
X-Received: by 2002:a17:906:2594:: with SMTP id m20mr5933205ejb.91.1554441867641;
 Thu, 04 Apr 2019 22:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
 <CAJCQCtRbRc-KDwrprBY1O3gczydCBujd9qsM5b4+5zTLmnr82A@mail.gmail.com>
 <CALsQ4_x-VViOA5Cu4vJTqmx3xSospmiEdsEcDDBcj=uvZUmrVQ@mail.gmail.com> <CAJCQCtSA=f+XWy8KzpzGdpjyaBsDOT5G+aC5FU9G2Fyi-sMvrQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSA=f+XWy8KzpzGdpjyaBsDOT5G+aC5FU9G2Fyi-sMvrQ@mail.gmail.com>
From:   Zirconium Hacker <jared.e.vb@gmail.com>
Date:   Fri, 5 Apr 2019 01:24:16 -0400
Message-ID: <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>
Subject: Re: btrfs balance hangs
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000586f990585c1b32b"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--000000000000586f990585c1b32b
Content-Type: text/plain; charset="UTF-8"

I've actually had a check running for the past 10 hours or so.
It got far enough, so I stopped it.  The output is attached.

--000000000000586f990585c1b32b
Content-Type: text/plain; charset="US-ASCII"; name="btrfs_check.txt"
Content-Disposition: attachment; filename="btrfs_check.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_ju3m6xj90>
X-Attachment-Id: f_ju3m6xj90

T3BlbmluZyBmaWxlc3lzdGVtIHRvIGNoZWNrLi4uCkNoZWNraW5nIGZpbGVzeXN0ZW0gb24gL2Rl
di9zZGgxClVVSUQ6IGM3M2ExNjk5LTQxZTYtNDQ1Zi04MmYxLTExNmU2ZTQ2ZWI2NApbMS83XSBj
aGVja2luZyByb290IGl0ZW1zClsyLzddIGNoZWNraW5nIGV4dGVudHMKcGFyZW50IHRyYW5zaWQg
dmVyaWZ5IGZhaWxlZCBvbiAyNjI5MDMzNTc0NDAwIHdhbnRlZCA2MTA0MDggZm91bmQgNjExMDIw
CnBhcmVudCB0cmFuc2lkIHZlcmlmeSBmYWlsZWQgb24gMjYyOTAzMzU3NDQwMCB3YW50ZWQgNjEw
NDA4IGZvdW5kIDYxMTAyMApwYXJlbnQgdHJhbnNpZCB2ZXJpZnkgZmFpbGVkIG9uIDI2MjkwMzM1
NzQ0MDAgd2FudGVkIDYxMDQwOCBmb3VuZCA2MTEwMjAKcGFyZW50IHRyYW5zaWQgdmVyaWZ5IGZh
aWxlZCBvbiAyNjI5MDMzNTc0NDAwIHdhbnRlZCA2MTA0MDggZm91bmQgNjExMDIwCklnbm9yaW5n
IHRyYW5zaWQgZmFpbHVyZQpsZWFmIHBhcmVudCBrZXkgaW5jb3JyZWN0IDI2MjkwMzM1NzQ0MDAK
YmFkIGJsb2NrIDI2MjkwMzM1NzQ0MDAKRVJST1I6IGVycm9ycyBmb3VuZCBpbiBleHRlbnQgYWxs
b2NhdGlvbiB0cmVlIG9yIGNodW5rIGFsbG9jYXRpb24KWzMvN10gY2hlY2tpbmcgZnJlZSBzcGFj
ZSBjYWNoZQpibG9jayBncm91cCAxMTM4NDU5OTM0NzIgaGFzIHdyb25nIGFtb3VudCBvZiBmcmVl
IHNwYWNlLCBmcmVlIHNwYWNlIGNhY2hlIGhhcyAyMDI4NzQ4OCBibG9jayBncm91cCBoYXMgMjA1
NDk2MzIKZmFpbGVkIHRvIGxvYWQgZnJlZSBzcGFjZSBjYWNoZSBmb3IgYmxvY2sgZ3JvdXAgMTEz
ODQ1OTkzNDcyCmJsb2NrIGdyb3VwIDEwODg4MDM1Njk2NjQgaGFzIHdyb25nIGFtb3VudCBvZiBm
cmVlIHNwYWNlLCBmcmVlIHNwYWNlIGNhY2hlIGhhcyAxMDQ4NTc2IGJsb2NrIGdyb3VwIGhhcyAx
MzEwNzIwCmZhaWxlZCB0byBsb2FkIGZyZWUgc3BhY2UgY2FjaGUgZm9yIGJsb2NrIGdyb3VwIDEw
ODg4MDM1Njk2NjQKYmxvY2sgZ3JvdXAgMTQyNDMyMjcyMzg0MCBoYXMgd3JvbmcgYW1vdW50IG9m
IGZyZWUgc3BhY2UsIGZyZWUgc3BhY2UgY2FjaGUgaGFzIDI1NDkzNTA0IGJsb2NrIGdyb3VwIGhh
cyAyNTc1NTY0OApmYWlsZWQgdG8gbG9hZCBmcmVlIHNwYWNlIGNhY2hlIGZvciBibG9jayBncm91
cCAxNDI0MzIyNzIzODQwCls0LzddIGNoZWNraW5nIGZzIHJvb3RzCls1LzddIGNoZWNraW5nIG9u
bHkgY3N1bXMgaXRlbXMgKHdpdGhvdXQgdmVyaWZ5aW5nIGRhdGEpCls2LzddIGNoZWNraW5nIHJv
b3QgcmVmcwpbNy83XSBjaGVja2luZyBxdW90YSBncm91cHMK
--000000000000586f990585c1b32b--
