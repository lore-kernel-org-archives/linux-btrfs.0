Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:49625 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaIUNAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 09:00:39 -0400
Received: by mail-yk0-f178.google.com with SMTP id 200so851784ykr.9
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Sep 2014 06:00:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411261282-26831-4-git-send-email-xnox@debian.org>
References: <1411261282-26831-1-git-send-email-xnox@debian.org> <1411261282-26831-4-git-send-email-xnox@debian.org>
From: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
Date: Sun, 21 Sep 2014 14:59:59 +0200
Message-ID: <CAKFHe2RwgjBDCEd6D4jva8QFou=gj8Pzd2auFUNyHFNephrYTw@mail.gmail.com>
Subject: Re: [PATCH 4/4] Default to acting like fsck.
To: Dimitri John Ledkov <xnox@debian.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21 September 2014 03:01, Dimitri John Ledkov <xnox@debian.org> wrote:
>
> Inspect arguments, if we are not called as btrfs, then assume we are
> called to act like fsck.
[...]
> -       if (!strcmp(bname, "btrfsck")) {
> +       if (strcmp(bname, "btrfs") != 0) {

That's assuming a lot.

Silently (!) breaking people's btrfs-3.15_patched-DontRandomlyPanicV2
is a recipe for needless hair-pulling. Is there a reason for not using
something less like strstr(bname, "fsck") that I am missing?

Regards,

T G-R
