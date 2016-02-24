Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34678 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbcBXSDS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 13:03:18 -0500
Received: by mail-io0-f174.google.com with SMTP id 9so51969992iom.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 10:03:18 -0800 (PST)
Received: from gmail.com (DRMONS0544W-142134058156.dhcp-dynamic.FibreOp.ns.bellaliant.net. [142.134.58.156])
        by smtp.gmail.com with ESMTPSA id n1sm13507372ige.19.2016.02.24.10.02.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 24 Feb 2016 10:02:55 -0800 (PST)
Date: Wed, 24 Feb 2016 14:02:52 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Input/Output errors
Message-ID: <20160224180251.GA5697@gmail.com>
References: <20160224004045.GA20632@gmail.com>
 <20160224015658.GY22487@merlins.org>
 <20160224030236.GA30797@gmail.com>
 <CAJCQCtQLY-zcz1e8zqNrekEfo1yo9DcDfwR_m4Y8AGaKxV32qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQLY-zcz1e8zqNrekEfo1yo9DcDfwR_m4Y8AGaKxV32qg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 09:37:03PM -0700, Chris Murphy wrote:
> On Tue, Feb 23, 2016 at 8:02 PM, Kenny MacDermid
> <kenny.macdermid@gmail.com> wrote:
> 
> >
> > rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache
> 
> It sounds like an ssd trim bug. I'd check the firmware for updates. If
> it's up to date, I'd drop discard mount option first and try to
> reproduce. Or just use the default mount options and try to reproduce,
> then add them back one at a time until you discover the culprit.

Thanks Chris,

The disk is a SAMSUNG MZMTE512HMHP-000L1 running f/w: EXT42L0Q. I didn't
find any updates in my searches.

I did drop the discard option, and the inode_cache and space_cache ones
as well. I'm not sure I originally got them from.

Even if it's a disk firmware bug, doesn't it seem like some layer should
report something about it? Is there any extra logging I should enable in
case it happens again?

As I don't have a way to reliable reproduce the error, I'll have to wait
and see if this helps.
