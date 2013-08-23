Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:56665 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3HWNn2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 09:43:28 -0400
Received: by mail-vb0-f49.google.com with SMTP id w16so421474vbb.22
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 06:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CE3CE57C.3C441%mark@backupsystems.co.uk>
References: <pan$e0fe5$102b89f1$6420a15b$7c2eaf18@cox.net>
	<CE3CE57C.3C441%mark@backupsystems.co.uk>
Date: Fri, 23 Aug 2013 15:43:27 +0200
Message-ID: <CAFvQSYT=4+KTV+fsQod2PNgXyFqkq4enEJOjEut7pN+YEU5EgA@mail.gmail.com>
Subject: Re: Samba strict allocate = yes stops btrfs compression working
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> The speed improvement for dumping large databases through samba with
> strict allocate = yes to BTRFS was amazing.  It reduced a 1 hour dump down
> to 20 minutes.

What you want btrfs to do is to allocate a file of fixed-size on disk
in advance, without knowing how large the file will be after
compression (which is the only thing of interest to btrfs). So the
whole idea doesn't make a lot of sence.

Sure, you could generate a 50gb file filled with zeros, but once you
put real data in it, it will fragment a lot - probably even more than
the file which was created without strict allocate.

Regards
