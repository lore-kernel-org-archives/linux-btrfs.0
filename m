Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33396 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031373AbbEEUpo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 16:45:44 -0400
Received: by oica37 with SMTP id a37so156776726oic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 13:45:43 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 May 2015 13:45:43 -0700
Message-ID: <CAA=o1p=kKF3-fCbMsvHdtzTq5ya=-krfWH9K8_ayccV-puOVwg@mail.gmail.com>
Subject: Compression: effect of chattr: wiki is contradictory
From: Rory Jaffe <rsjaffe@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On the wiki, it first speaks about forcing compression by adding the c
attribute, but later states that the c attribute enables, not forces
compression. Which is it?

=========================================from wiki:

Can I force compression on a file without using the compress mount option?

Yes. The utility chattr supports setting file attribute c that marks
the inode to compress newly written data.

* * *

Can I set compression per-subvolume?

Currently no, this is planned. You can simulate this by enabling
compression on the subvolume directory and the files/directories will
inherit the compression flag.

What's the precedence of all the options affecting compression?

Compression to newly written data happens:
always -- if the filesystem is mounted with compress-force
never -- if the NOCOMPRESS flag is set per-file/-directory
if possible -- if the COMPRESS per-file flag (aka chattr +c) is set,
but it may get converted to NOCOMPRESS eventually
if possible -- if the compress mount option is specified

Note, that mounting with compress will not set the +c file attribute.
