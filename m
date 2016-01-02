Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35637 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbcABT4k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 14:56:40 -0500
Received: by mail-io0-f171.google.com with SMTP id 77so96757462ioc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 11:56:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
	<CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
	<1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
Date: Sat, 2 Jan 2016 12:56:39 -0700
Message-ID: <CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
Subject: Re: Add big device, remove small device, read-only
From: Chris Murphy <lists@colorremedies.com>
To: Rasmus Abrahamsen <me@rasmusa.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Rasmus Abrahamsen <btrfs@rasmusa.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 1, 2016 at 1:20 PM, Rasmus Abrahamsen <me@rasmusa.net> wrote:
> [ralle@rasmusahome ~]$ sudo btrfs fi usage /mnt/fortune/
[snip]
> Unallocated:
>    /dev/sda1     137.48GiB
>    /dev/sdb1      16.00EiB
>    /dev/sdc1     135.76GiB
>    /dev/sdd1       3.14TiB

Another phantom 16.00EiB, this time it appears as unallocated space on
a devices, rather than free space as it is in a bug I recently filed.

https://bugzilla.kernel.org/show_bug.cgi?id=110111


-- 
Chris Murphy
