Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49512 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGaPLh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 11:11:37 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so4325993wib.10
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 08:11:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkquYG02RQKDDvY03OHDsEUsas54D7mz6jRna+5MyuUc7oQ@mail.gmail.com>
References: <CAFChkqszfFU51qkr1CSNgv0VKNhr8U_jEDv0_BPaZZghLzKojA@mail.gmail.com>
 <CAFChkquCzoJP6fussqdKB0rU8eDOz7=D=V8Pcugewdo1TgnmxQ@mail.gmail.com>
 <CAFChkquw9YA8DeX43zBy9_V3UwNmAZiAHziFavGst5YwL9vMuQ@mail.gmail.com> <CAFChkquYG02RQKDDvY03OHDsEUsas54D7mz6jRna+5MyuUc7oQ@mail.gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Thu, 31 Jul 2014 16:10:52 +0100
Message-ID: <CAFChkqtVPBembgw859O3wNTv3VMGdHjoorSrtSWL30SVj3AaAw@mail.gmail.com>
Subject: Re: Machine lockup due to btrfs-transaction on AWS EC2 Ubuntu 14.04
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I should add that I have reproduced this even after doing `mount -o
clear_cache /dev/... /mnt/...`, unmount, remount with `-o
space_cache`. After the machine lockup and rebooting there are the
warnings of the form:

> [ 117.288248] BTRFS warning (device dm-0): block group 694165700608 has wrong amount of free space
> [ 117.288253] BTRFS warning (device dm-0): failed to load free space cache for block group 694165700608, rebuild it now
