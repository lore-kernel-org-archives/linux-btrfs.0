Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:58408 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932614AbcK1Jtg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 04:49:36 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 96F919B98A
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 09:49:33 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 3890D5FBB2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 09:49:33 +0000 (GMT)
Subject: Re: [Not TLS] Re: mount option nodatacow for VMs on SSD?
To: linux-btrfs@vger.kernel.org
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
 <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
 <20161128003829.GD15348@rus.uni-stuttgart.de>
 <pan$1eaab$d4d4facd$e2735d04$2fc4a8e@cox.net>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <2df2e8e6-5ac4-a9c0-70bc-406fd84e9784@cobb.uk.net>
Date: Mon, 28 Nov 2016 09:49:33 +0000
MIME-Version: 1.0
In-Reply-To: <pan$1eaab$d4d4facd$e2735d04$2fc4a8e@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/11/16 02:56, Duncan wrote:
> It should still be worth turning on autodefrag on an existing somewhat 
> fragmented filesystem.  It just might take some time to defrag files you 
> do modify, and won't touch those you don't, which in some cases might 
> make it worth defragging those manually.  Or simply create new 
> filesystems, mount them with autodefrag, and copy everything over so 
> you're starting fresh, as I do.

Could that "copy" be (a series of) send/receive, so that snapshots and
reflinks are preserved?  Does autodefrag work in that case or does the
send/receive somehow override that and end up preserving the original
(fragmented) extent structure?

Graham

