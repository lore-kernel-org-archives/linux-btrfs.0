Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:46566 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753847AbdHWMLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 08:11:54 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:39896)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dkUVk-00086b-EE
        for linux-btrfs@vger.kernel.org; Wed, 23 Aug 2017 13:11:52 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dkU3B-0005gw-8o
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 12:42:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22941.27164.739577.517915@tree.ty.sabi.co.uk>
Date: Wed, 23 Aug 2017 12:42:20 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: user snapshots
In-Reply-To: <20170823072048.GB28319@rus.uni-stuttgart.de>
References: <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
        <22940.31139.194399.982315@tree.ty.sabi.co.uk>
        <20170822215343.GP14804@rus.uni-stuttgart.de>
        <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
        <20170823101635.114d02d2@job>
        <20170823072048.GB28319@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So, still: What is the problem with user_subvol_rm_allowed?

As usual, it is complicated: mostly that while subvol creation
is very cheap, subvol deletion can be very expensive. But then
so can be creating many snapshots, as in this:

  https://www.spinics.net/lists/linux-btrfs/msg62760.html

Also that deleting a subvol can delete a lot of stuff
"inadvertently", including things that the user could not delete
using UNIX style permissions. But it many of the Btrfs semantics
feel a bit "arbitrary" in part because they break new ground, in
part because happenstance.

  http://linux-btrfs.vger.kernel.narkive.com/eTtmsQdL/patch-1-2-btrfs-don-t-check-the-permission-of-the-subvolume-which-we-want-to-delete
  http://linux-btrfs.vger.kernel.narkive.com/nR17xtw7/patch-btrfs-allow-subvol-deletion-by-unprivileged-user-with-o-user-subvol-rm-allowed
