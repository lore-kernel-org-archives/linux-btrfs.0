Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32770 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbcC1Uqz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 16:46:55 -0400
Received: by mail-ig0-f179.google.com with SMTP id ma7so18280207igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 13:46:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21f3d8f6-3447-109f-d21e-0e7a696c94e2@mokrynskyi.com>
References: <20160328143714.GZ10135@torres.zugschlus.de>
	<20160328184237.GA10135@torres.zugschlus.de>
	<21f3d8f6-3447-109f-d21e-0e7a696c94e2@mokrynskyi.com>
Date: Mon, 28 Mar 2016 14:46:54 -0600
Message-ID: <CAJCQCtQ-hD54h4g+pXFXXqfjk=aoC-7T3ejfeMC4AFPw8pDyjw@mail.gmail.com>
Subject: Re: "bad metadata" not fixed by btrfs repair
From: Chris Murphy <lists@colorremedies.com>
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 12:51 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:

>>> # btrfs check --repair /dev/mapper/fanbtr
>>> bad metadata [4425377054720, 4425377071104) crossing stripe boundary
>>> bad metadata [4425380134912, 4425380151296) crossing stripe boundary
>>> bad metadata [4427532795904, 4427532812288) crossing stripe boundary
>>> bad metadata [4568321753088, 4568321769472) crossing stripe boundary
>>> bad metadata [4568489656320, 4568489672704) crossing stripe boundary
>>> bad metadata [4571474493440, 4571474509824) crossing stripe boundary
>>> bad metadata [4571946811392, 4571946827776) crossing stripe boundary
>>> bad metadata [4572782919680, 4572782936064) crossing stripe boundary
>>> bad metadata [4573086351360, 4573086367744) crossing stripe boundary
>>> bad metadata [4574221041664, 4574221058048) crossing stripe boundary
>>> bad metadata [4574373412864, 4574373429248) crossing stripe boundary
>>> bad metadata [4574958649344, 4574958665728) crossing stripe boundary
>>> bad metadata [4575996018688, 4575996035072) crossing stripe boundary
>>> bad metadata [4580376772608, 4580376788992) crossing stripe boundary


http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/tree/cmds-check.c
line 7722 discusses this error message and it looks like there's no
repair function for it yet; uncertain what problems can result from
this.

line 4576 has a possible clue, but I don't know what "can't handle"
means, if real problems just silently are permitted or what.



-- 
Chris Murphy
