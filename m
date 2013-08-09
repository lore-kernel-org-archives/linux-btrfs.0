Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:50743 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030482Ab3HIHfP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 03:35:15 -0400
Received: by mail-vb0-f47.google.com with SMTP id h10so3892954vbh.34
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 00:35:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375874984-31139-1-git-send-email-fdmanana@gmail.com>
References: <1375874984-31139-1-git-send-email-fdmanana@gmail.com>
Date: Fri, 9 Aug 2013 09:35:14 +0200
Message-ID: <CAFvQSYQpJu0Di163SgBqPS+LVKwC2X2wfz=1eKr6XtTnQeCJig@mail.gmail.com>
Subject: Re: [PATCH RFC] Btrfs: track compression algorithm on inodes
From: Clemens Eisserer <linuxhippy@gmail.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been waiting for such functionality quite a long time, great to
seem some progress here :)
It would allow me to compress files which are not frequently accessed
(~75%?) with zlib, while staying at LZO for everything else.

> I think we should take the top-down approach and start with UI how to set these attributes,
Yes, some command-line tool to set the compression algorithm would be
a better idea then using mountn..

Regards
