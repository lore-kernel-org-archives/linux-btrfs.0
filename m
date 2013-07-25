Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab3GYVZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 17:25:33 -0400
Date: Thu, 25 Jul 2013 14:25:31 -0700
From: Zach Brown <zab@redhat.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: fix segfault when listing column OTIME
 on big endian host
Message-ID: <20130725212531.GJ26554@lenny.home.zabbo.net>
References: <51F10A50.9010308@cn.fujitsu.com>
 <1374761521-17603-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374761521-17603-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> btrfs-list.c:
>         case BTRFS_LIST_OTIME:
>                 if (subv->otime)
>                         strftime(tstr, 256, "%Y-%m-%d %X",
>                                  localtime(&subv->otime));
>                 else
>                         strcpy(tstr, "-");
>                 printf("%s", tstr);
>                 break;
> 
> localtime() returned NULL then strftime() got SIGSEGV.
> 
> The reason is that ri->otime.sec is stored as little endian but
> assigned to 't' without conversion.

That's why localtime() returned null, sure, but it doesn't excuse
strftime() being called with a null *tm!  Add some error checking around
localtime().  It should warn that otime is nonsense, not crash.

- z
