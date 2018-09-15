Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr10060.outbound.protection.outlook.com ([40.107.1.60]:10341
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727039AbeIOR0I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Sep 2018 13:26:08 -0400
Subject: Re: state of btrfs snapshot limitations?
To: "James A. Robinson" <jim.robinson@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
 <pan$425cf$32d9f075$987b0e87$b2aa40b1@cox.net>
 <CAPd04b6Zd3=u7Fna3NJu=fNE4xRG--AY6EDR55Q0XNW9fe+z4A@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d5c49fb4-836e-b6e7-9ca1-124f5b292cd9@mendix.com>
Date: Sat, 15 Sep 2018 14:07:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAPd04b6Zd3=u7Fna3NJu=fNE4xRG--AY6EDR55Q0XNW9fe+z4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2018 05:56 AM, James A. Robinson wrote:
> [...]
> 
> I've got to read up a bit more on subvolumes, I am missing some
> context from the warnings given by Chris regarding per-subvolume
> options.

Btrfs lets you mount the filesystem multiple times, e.g. with a
different subvolume id, so you can mount part of the filesystem somewhere.

Some of the mount options (many btrfs specific ones, like space_cache*,
autodefrag etc) get a value when doing the first mount, and subsequent
ones cannot change them any more, because they're filesystem wide behavior.

Some others can be changed on each individual mount (like the atime
options), and when omitting them you get the non-optimal default again.

-- 
Hans van Kranenburg
