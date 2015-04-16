Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34950 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbDPXnO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 19:43:14 -0400
Received: by igbyr2 with SMTP id yr2so1985040igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 16:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553046DA.7090809@gmail.com>
References: <553046DA.7090809@gmail.com>
Date: Thu, 16 Apr 2015 19:43:14 -0400
Message-ID: <CAPL5yKftzW+1KPDDLb4_RcXZ9OFKs=_ANZL5rUJkxD31krmYmQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: have restore set atime/mtime
From: Dan Merillat <dan.merillat@gmail.com>
To: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think thunderbird ate that patch, sorry.

I didn't make it conditional - there's really no reason to not restore
the information.  I was actually surprised that it didn't restore
before this patch.

If it looks good I'll resend without the word-wrapping.
