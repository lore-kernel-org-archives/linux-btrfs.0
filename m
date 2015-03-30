Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36251 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbbC3Wrb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 18:47:31 -0400
Received: by igbud6 with SMTP id ud6so3021390igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 15:47:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B7F2379062E32745A8651FBDB20F64594CD80D3D@Server.waterlogic.com.au>
References: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
	<20150323211334.GA11155@ret.masoncoding.com>
	<CAJCQCtRRtOoTUNAwyN56615y_uOyCLwXG13KWy=g1CCiDrH=BA@mail.gmail.com>
	<B7F2379062E32745A8651FBDB20F64594CD80D3D@Server.waterlogic.com.au>
Date: Mon, 30 Mar 2015 16:47:31 -0600
Message-ID: <CAJCQCtSH=dFFPVUacBb+9Mb7+wk1ErLu86BpV88C5cVgsKmb-A@mail.gmail.com>
Subject: Re: kvm bug, guest I/O blk device errors when qcow2 backing file is
 on Btrfs
From: Chris Murphy <chris@colorremedies.com>
To: Paul Jones <paul@pauljones.id.au>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Small update. I've done a strace of the qemu process, filtering for
pwrite,pwritev while the guest experiences these I/O errors and posted
it to the bug. Kevin Wolf looked at it and says
 https://bugzilla.redhat.com/show_bug.cgi?id=1204569#c20

> There is one single failing pwritev() call in it:
> 3091  <... pwritev resumed> )           = -1 EEXIST (File exists)
> Now EEXIST is not an error code that makes any sense for a pwritev() call, but a
> quick search on the internet suggests that btrfs does indeed use this error code
> if something goes wrong internally. You should probably mention this error code
> in your linux-btrfs thread, perhaps it gives the btrfs developers a hint.



Chris Murphy
