Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m59-178.qiye.163.com ([123.58.178.59]:34826 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2K1LND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 06:13:03 -0500
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	by m59-178.qiye.163.com (HMail) with ESMTPA id 6B5EC810195
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 19:12:59 +0800 (CST)
Received: by mail-lb0-f174.google.com with SMTP id gi11so7467082lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 03:12:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121128105422.GB2791@liubo>
References: <50AFB620.6040707@prnet.org> <2925363.jTFvA7mLni@vfr>
 <50AFE5FC.7040304@prnet.org> <20121124033910.GA5680@gmail.com>
 <50B27C4A.7040702@prnet.org> <20121126025439.GA5923@liubo>
 <50B3003E.2010104@prnet.org> <20121127074625.GA31592@liubo.cn.oracle.com>
 <50B51296.3010103@prnet.org> <20121128105422.GB2791@liubo>
From: Rock Lee <zimilo@code-trick.com>
Date: Wed, 28 Nov 2012 19:12:16 +0800
Message-ID: <CAMRmmpJ_NCHMUyfS0Y0fRo_8TnEMc41s5ig3bji6u34PgL54Fg@mail.gmail.com>
Subject: Re: extended attributes wiredness
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Arendt <admin@prnet.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also reproduced on my computer.

The strace result:

sudo strace -s4096 -e trace=setxattr,getxattr cp -a test1 test2
getxattr("test1", "system.posix_acl_access", 0x7ffffab440d0, 132) = -1
ENODATA (No data available)
setxattr("test2", "system.posix_acl_access",
"\x02\x00\x00\x00\x01\x00\x07\x00\xff\xff\xff\xff\x04\x00\x05\x00\xff\xff\xff\xff
\x00\x05\x00\xff\xff\xff\xff", 28, 0) = 0
getxattr("test1", "system.posix_acl_default", 0x7ffffab440d0, 132) =
-1 ENODATA (No data available)
setxattr("test2", "system.posix_acl_default", "\x02\x00\x00\x00", 4, 0) = 0
+++ exited with 0 +++
