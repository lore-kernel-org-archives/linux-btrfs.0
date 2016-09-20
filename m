Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:49887 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753699AbcITU7w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 16:59:52 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 64E4C9B8D7
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 21:59:48 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 419885FB9F
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 21:59:48 +0100 (BST)
Subject: Re: multi-device btrfs with single data mode and disk failure
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
 <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com>
 <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com>
 <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
 <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
 <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
 <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <13e4ed6d-1ee7-4b3e-bbbc-6425cb908746@cobb.uk.net>
Date: Tue, 20 Sep 2016 21:59:48 +0100
MIME-Version: 1.0
In-Reply-To: <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/09/16 19:53, Alexandre Poux wrote:
> As for moving data to an another volume, since it's only data and
> nothing fancy (no subvolume or anything), a simple rsync would do the trick.
> My problem in this case is that I don't have enough available space
> elsewhere to move my data.
> That's why I'm trying this hard to recover the partition...

I am sure you have already thought about this, but... it might be
easier, and even maybe faster, to backup the data to a cloud server,
then recreate and download again.

Backblaze B2 is very cheap for upload and storage (don't know about
download charges, though).  And rclone works well to handle rsync-style
copies (although you might want to use tar or dar if you need to
preserve file attributes).

And if that works, rclone + B2 might make a reasonable offsite backup
solution for the future!

Graham
