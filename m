Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:46734 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933040AbdHVPpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 11:45:39 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id EE5C48484
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 17:45:37 +0200 (MEST)
Date: Tue, 22 Aug 2017 17:45:37 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822154537.GJ14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <22940.17147.756378.347580@tree.ty.sabi.co.uk>
 <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (11:03), Austin S. Hemmelgarn wrote:


> Or alternatively, repeatedly call `btrfs filesystem show` on the path, 
> removing one component from the end each time until you get a zero 
> return code.  The path you called it on that got a zero return code is 
> where the mount is (and thus what filesystem that subvolume is part of), 
> and the output just gave you a list of devices it's on.

"btrfs filesystem show" is relative slow (2.6 s), 
"btrfs subvolume show" is MUCH faster (0.02 s).


In perl I have now:

$root = $volume;
while (`btrfs subvolume show "$root" 2>/dev/null` !~ /toplevel subvolume/) {
  $root = dirname($root);
  last if $root eq '/';
}


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
