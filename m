Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43806 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030617AbaDJNTI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 09:19:08 -0400
Received: by mail-pd0-f170.google.com with SMTP id v10so3898042pde.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 06:19:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3839313.LSaoXm11Qk@zafu>
References: <1541415.olHfkWYf4R@zafu>
	<pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net>
	<3839313.LSaoXm11Qk@zafu>
Date: Thu, 10 Apr 2014 15:19:08 +0200
Message-ID: <CAPpBBdM52uWwMydmCxXTx+c20KH7aNrgNersRm=hQqP7gEhK0A@mail.gmail.com>
Subject: Re: Using noCow with snapshots ?
From: George Eleftheriou <eleftg@gmail.com>
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Besides this, I'm still wondering about the changes in data security that
> turning a database to "NoCow" would bring, i.e. would the data still be well
> protected in case of a system crash or power failure ?
>
> I have precious data in there and wouldn't like to jeopardize its security for
> a performance gain...

Quoting from the mount options of the wiki:

nodatacow
Do not copy-on-write data for newly created files, existing files are
unaffected. This also turns off checksumming! IOW, nodatacow implies
nodatasum. datacow is used to ensure the user either has access to the
old version of a file, or to the newer version of the file. datacow
makes sure we never have partially updated files written to disk.
nodatacow gives slight performance boost by directly overwriting data
(like ext[234]), at the expense of potentially getting partially
updated files on system failures. Performance gain is usually < 5%
unless the workload is random writes to large database files, where
the difference can become very large. NOTE: switches off compression !

I don't know if the above applies for "chattr +C" as well... Perhaps
someone more experienced can help.

In any case, if you have precious data in there then, COW or NOCOW,
you should regularly do backups to a separate, discrete filesystem.
