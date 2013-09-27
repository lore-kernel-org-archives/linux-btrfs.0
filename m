Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50827 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3I0OWi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 10:22:38 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so977207bkh.26
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 07:22:37 -0700 (PDT)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 27 Sep 2013 16:22:16 +0200
Message-ID: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com>
Subject: csum questions
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I have some questions about btrfs' handling of invalid csums.

For the sake of argument I'm assuming no raid or anything like that
(so only one copy exists of every file).

When I try to access a file whose csum does not match, btrfs logs an
error and refuses access to the file. I have two questions about this:

1) What happens to the file. Will btrfs just leave it alone, or will
it be deleted from disk (I seem to remember reading this somewhere,
just want to confirm)?

2) How may I tell btrfs to ignore all csums and just assume they are
all correct? The reason for wanting this is in case the csum is
garbled and the file is intact, or the csum is correct and the file is
only partially garbled, but may still contain useful data.

Any help would be greatly appreciated.

Cheers,

Tom
