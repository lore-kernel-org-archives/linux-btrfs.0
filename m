Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:42035 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933159AbcIGQ1y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 12:27:54 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 0EC7C9B98A
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 17:27:51 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id AE7825FB5B
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 17:27:50 +0100 (BST)
Subject: Re: Security implications of btrfs receive?
To: linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net>
 <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <31a3fc6c-dd8a-e5f6-6248-ec28644d8189@cobb.uk.net>
Date: Wed, 7 Sep 2016 17:27:50 +0100
MIME-Version: 1.0
In-Reply-To: <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/09/16 16:06, Austin S. Hemmelgarn wrote:
> It hasn't, because there's not any way it can be completely fixed.  This
> particular case is an excellent example of why it's so hard to fix.  To
> close this particular hole, BTRFS itself would have to become aware of
> whether whoever is running an ioctl is running in a chroot or not, which
> is non-trivial to determine to begin with, and even harder when you
> factor in the fact that chroot() is a VFS level thing, not a underlying
> filesystem thing, while ioctls are much lower level.

Actually, I think the btrfs-receive case might be a little easier to fix
and, in my quick reading of the code before doing a test, I thought it
even did work this way...

I think the fix would be to require that the action of cloning disk
blocks required user-mode to provide an FD which has read access to the
source blocks.  There is little problem with allowing the ioctl to
identify the matching subvolume for a UUID but it should require user
mode to open the source file for read access using a path before
allowing any blocks to be cloned.  That way, any VFS-level checks would
be done.  And, what is more, btrfs-receive could do a file path check to
make sure the file being cloned from is within the path that was
provided on the command line.

