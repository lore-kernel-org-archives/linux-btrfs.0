Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35508 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbcAOJ5L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:57:11 -0500
Received: by mail-lb0-f171.google.com with SMTP id bc4so311093019lbc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 01:57:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5698B534.4040202@xoxy.net>
References: <5698B534.4040202@xoxy.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 15 Jan 2016 12:56:30 +0300
Message-ID: <CAGqmi76EQ1NYFhp7hdwdrP0VTNXdSYgePje036UGRWDnUV=EWw@mail.gmail.com>
Subject: Re: Copying between lzo compressed BtrFS's: de/re-compressing.
To: Diagon <kernel.boxy@xoxy.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-01-15 12:00 GMT+03:00 Diagon <kernel.boxy@xoxy.net>:
> I'm copying a large number of files between two lzo compressed BtrFS
> filesystems on different drives mounted on the same machine. It appears
> that the files are being de/re-compressed. Is there a way avoid this?

If you just copy files, files will be decompressed while reading and
recompressed while writing
For avoiding this, you must use send receive feature


-- 
Have a nice day,
Timofey.
