Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33564 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbEEQQC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 12:16:02 -0400
Received: by oica37 with SMTP id a37so150401040oic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 09:16:01 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 May 2015 09:16:01 -0700
Message-ID: <CAA=o1pmgVecy+TDq-3ecdoSKUTVs8Qb5Sh8GnGZ6aVR=16h=VQ@mail.gmail.com>
Subject: Compression: effect of setting the c attribute: wiki unclear
From: Rory Jaffe <rsjaffe@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On the wiki, it first speaks about forcing compression by adding the c
attribute, but later states that the c attribute enables, not forces
compression. Which is it? It seems like the typical use case
currently, given the inability to selectively compress subvolumes, is
the "if possible" choice.

============from https://btrfs.wiki.kernel.org/index.php/Compression

Can I force compression on a file without using the compress mount option?

Yes. The utility chattr supports setting file attribute c that marks
the inode to compress newly written data.

* * *

What's the precedence of all the options affecting compression?

Compression to newly written data happens:

always -- if the filesystem is mounted with compress-force
never -- if the NOCOMPRESS flag is set per-file/-directory
if possible -- if the COMPRESS per-file flag (aka chattr +c) is set,
but it may get converted to NOCOMPRESS eventually
if possible -- if the compress mount option is specified

Note, that mounting with compress will not set the +c file attribute.
