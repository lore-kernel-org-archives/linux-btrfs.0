Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:42782 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbbFWRar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 13:30:47 -0400
Received: by vnbg129 with SMTP id g129so2615590vnb.9
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2015 10:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5588BA12.4010104@cn.fujitsu.com>
References: <55835A55.7000308@stroebel.fr>
	<5588BA12.4010104@cn.fujitsu.com>
Date: Tue, 23 Jun 2015 11:30:44 -0600
Message-ID: <CAJCQCtQF3H37tKKYWzUW9R3S9h+18Dzpg22hWViAahm2_ttZtQ@mail.gmail.com>
Subject: Re: Corrupted btrfs partition (converted from ext4) after balance
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Vianney Stroebel <capsule@likwid.fr>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 7:44 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Without the full output of btrfsck, it's quite hard to call it a clear bug
> report if you want to save your data in the corrupted partition.

What I read was that he included everything btrfs check reported,
which wasn't a lot. It


> The command Konsole output "btrfs check /dev/sdb1" outputs :
> "Checking filesystem on /dev/sdb1
> UUID: 21873ba7-438a-4fbf-a051-ace28bffd264
> checking extents"
> and stops after a few minutes with no other output.

Since he's using btrfs-progs 3.19, I think he should upgrade to
btrfs-progs 4.1, try check again, and report the complete results.






-- 
Chris Murphy
