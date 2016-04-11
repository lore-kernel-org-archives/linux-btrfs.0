Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36322 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbcDKBuy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 21:50:54 -0400
Received: by mail-oi0-f51.google.com with SMTP id y204so191523838oie.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 18:50:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbYGBuDah_PvhzPVSdotqkGnO43Y3yi2ZYj94r+f9mt5w@mail.gmail.com>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
	<CAPmG0jaxZY1d365KGy=HL+e7WNyZ7w6jtT2VJod00KD=JBC=ng@mail.gmail.com>
	<CALJXSJpSsxES=SvtscJYCy7J1V37=rhXfWg1DjqU3XpkzJ-M6A@mail.gmail.com>
	<CAPmG0jbYGBuDah_PvhzPVSdotqkGnO43Y3yi2ZYj94r+f9mt5w@mail.gmail.com>
Date: Sun, 10 Apr 2016 21:50:53 -0400
Message-ID: <CALJXSJrzZK5EQ8VLf77JQTL2aAnFTm_BezLv9dhSz=Gz3X5+yA@mail.gmail.com>
Subject: Re: csum failed on innexistent inode
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 10, 2016 at 1:25 PM, Henk Slager <eye1tm@gmail.com> wrote:
> Kernel/tools
> versions and btrfs fi us output might also give some hints.


I completely forgot to paste those:
BTRFS: btrfs-progs v4.4
Kernel: 4.6.0-rc2.
