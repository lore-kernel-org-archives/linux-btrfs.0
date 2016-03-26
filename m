Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38638 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbcCZU2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 16:28:23 -0400
Received: by mail-ig0-f179.google.com with SMTP id ig19so32815779igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 13:28:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160326203035.4b876a04@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
Date: Sat, 26 Mar 2016 14:28:22 -0600
Message-ID: <CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 1:30 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

> Well, this time it hit me on the USB backup drive which uses no bcache
> and no other fancy options except compress-force=zlib. Apparently, I've
> only got a (real) screenshot which I'm going to link here:
>
> https://www.dropbox.com/s/9qbc7np23y8lrii/IMG_20160326_200033.jpg?dl=0

This is a curious screen shot. It's a dracut pre-mount shell, so
nothing should be mounted yet. And btrfs check only works on an
unmounted file system. And yet the bottom part of the trace shows a
Btrfs volume being made read only, as if it was mounted read write and
is still mounted. Huh?


Chris Murphy
