Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41735 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3AEOgA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 09:36:00 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so879201wgb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jan 2013 06:35:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <COGozn2PCXB@helmut.hullen.de>
References: <COGozn2PCXB@helmut.hullen.de>
Date: Sat, 5 Jan 2013 15:35:58 +0100
Message-ID: <CAMQ-g0c32nrFGDm5qP3u8iGC9FrdTyZ0Apm2N+F0BJyS+RYpgg@mail.gmail.com>
Subject: Re: cleaning old entries
From: Jan Steffens <jan.steffens@gmail.com>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 5, 2013 at 3:12 PM, Helmut Hullen <Hullen@t-online.de> wrote:
> Has "mkfs.btrfs" to delete the "/dev/sdb" data when it overwrites the
> configuration with data for partitions? Or has the user to run something
> like "dd if=/dev/zero ..."?

Take a look at:
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_old_superblock_.3F
