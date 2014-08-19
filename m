Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:45002 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHSViS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 17:38:18 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so7023740wes.35
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 14:38:17 -0700 (PDT)
Message-ID: <53F3C3C7.8020303@gmail.com>
Date: Tue, 19 Aug 2014 23:38:15 +0200
From: Andrej Manduch <amanduch@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: M G Berberich <btrfs@oss.m-berberich.de>
Subject: Re: Questions on using BtrFS for fileserver
References: <20140819162151.GA15166@forwiss.uni-passau.de>
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 08/19/2014 06:21 PM, M G Berberich wrote:> · Are there any
reports/papers/web-pages about BtrFS-systems this size
>   in use? Praises, complains, performance-reviews, whatever…

I don't know about papers or benchmarks but few weeks ago there was a
guy who has problem with really long mounting with btrfs with similiar size.
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36226.html

And I would not recommend 3TB disks. *I'm not btrfs dev* but as far as I
know there is a quite different between rebuilding disk on real RAID and
btrfs RAID. The problem is btrfs has RAID on filesystem level not on hw
level so there is bigger mechanical overheat on drives and thus it take
significantli longer than regular RAID.

--
b.
