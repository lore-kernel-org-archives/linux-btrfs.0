Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55622 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2FYSnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 14:43:37 -0400
Received: by eaak11 with SMTP id k11so1350239eaa.19
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 11:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ8bbvtJG_=grkgdJ_Bk68QHt0eE5DghHwZNTeEGhd_PBof=sw@mail.gmail.com>
References: <CAJ8bbvtJG_=grkgdJ_Bk68QHt0eE5DghHwZNTeEGhd_PBof=sw@mail.gmail.com>
Date: Mon, 25 Jun 2012 19:43:36 +0100
Message-ID: <CAJ8bbvtN_8vY3x0LzNFC7kBChSvRruaaes+Oi2oUE6BmSob+LQ@mail.gmail.com>
Subject: Re: seeking advice
From: Maciej Sujkowski <maciej@sujkowski.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

Maybe someone will be able to help.

I have 2 unusable instances of btrfs.

1. when I did a re-size (stretch) I had a power lost and now btrfs system
is not detected on the drive (tried find-root, restore, btrfsck, btrfs show
and maybe something else - can't remember as it was some time ago
2. I did btrfsck -repair on another device and now it show incorrect
amount of space (the difference is really huge) and when i try to mount it
there is kernel bug. btrfsck detects some errors but can't fix it.

Any suggestion appreciated.

MS
