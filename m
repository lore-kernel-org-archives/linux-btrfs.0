Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57531 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752213AbdK0OYm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 09:24:42 -0500
Date: Mon, 27 Nov 2017 15:22:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: splat on 4.15-rc1: invalid ram_bytes for uncompressed inline
 extent
Message-ID: <20171127142244.GZ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 27, 2017 at 02:23:49PM +0100, Adam Borowski wrote:
> Hi!
> On 4.15-rc1, I get the following failure:
> 
> BTRFS critical (device sda1): corrupt leaf: root=1 block=3820662898688
> slot=43 ino=35691 file_offset=0, invalid ram_bytes for uncompressed inline
> extent, have 134 expect 281474976710677

By a quick look at suspiciously large number

hex(281474976710677) = 0x1000000000015

may be a bitflip, but 0x15 does not match 134, so there could be
something else involved in the corruption.
