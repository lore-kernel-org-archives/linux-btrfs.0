Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:43196 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaL1REc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 12:04:32 -0500
Received: by mail-yk0-f170.google.com with SMTP id q200so6032450ykb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Dec 2014 09:04:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2319142.UG75f3UqXt@merkaba>
References: <3738341.y7uRQFcLJH@merkaba>
	<m7nkoo$15b$1@ger.gmane.org>
	<549F80FD.4050804@pobox.com>
	<2319142.UG75f3UqXt@merkaba>
Date: Sun, 28 Dec 2014 18:04:31 +0100
Message-ID: <CAA7pwKM7Dz-c4G3WtbOKR0CB2Ys-G5dPx2+L2=Y=uOK=yY9hug@mail.gmail.com>
Subject: Re: BTRFS free space handling still needs more work: Hangs again
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 December 2014 at 13:03, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> BTW, I found that the Oracle blog didn´t work at all for me. I completed
> a cycle of defrag, sdelete -c and VBoxManage compact, [...] and it
> apparently did *nothing* to reduce the size of the file.

They've changed the argument to -z; sdelete -z.
