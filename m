Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58831 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaFVHtd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 03:49:33 -0400
Received: by mail-ve0-f175.google.com with SMTP id jx11so4941009veb.20
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jun 2014 00:49:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
Date: Sun, 22 Jun 2014 09:49:31 +0200
Message-ID: <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The 64KB Btrfs bootloader pad is 8 sector aligned, so for 512e AF disks
> there's no problem formatting the whole drive. The alignment problem
> actually happens when partitioning it, using old partition tools that don't
> align on 8 sector boundaries. There are some such tools still floating
> around.

A 'somewhat' related question:

So called Advanced Format drives has 4K physical sector size,
however they report 512B logical sector size.

How does linux kernel access those drives?
512B or 4K at a time?

Imran
