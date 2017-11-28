Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:49007 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbdK1BQT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 20:16:19 -0500
Date: Tue, 28 Nov 2017 02:16:15 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: splat on 4.15-rc1: invalid ram_bytes for uncompressed inline
 extent
Message-ID: <20171128011615.sdxutxckz67sftqm@angband.pl>
References: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
 <20171127142244.GZ3553@twin.jikos.cz>
 <bba97ff7-b08f-19d2-b980-f92443691c18@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <bba97ff7-b08f-19d2-b980-f92443691c18@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 08:51:07AM +0800, Qu Wenruo wrote:
> On 2017年11月27日 22:22, David Sterba wrote:
> > On Mon, Nov 27, 2017 at 02:23:49PM +0100, Adam Borowski wrote:
> >> On 4.15-rc1, I get the following failure:
> >>
> >> BTRFS critical (device sda1): corrupt leaf: root=1 block=3820662898688
> >> slot=43 ino=35691 file_offset=0, invalid ram_bytes for uncompressed inline
> >> extent, have 134 expect 281474976710677
> > 
> > By a quick look at suspiciously large number
> > 
> > hex(281474976710677) = 0x1000000000015
> > 
> > may be a bitflip, but 0x15 does not match 134, so there could be
> > something else involved in the corruption.
> 
> That's a known bug, fixed by that patch which is not merged yet.
> 
> https://patchwork.kernel.org/patch/10047489/

This helped, thanks!


喵!
-- 
⢀⣴⠾⠻⢶⣦⠀ Mozilla's Hippocritical Oath: "Keep trackers off your trail"
⣾⠁⢰⠒⠀⣿⡁ blah blah evading "tracking technology" blah blah
⢿⡄⠘⠷⠚⠋⠀ "https://click.e.mozilla.org/?qs=e7bb0dcf14b1013fca3820..."
⠈⠳⣄⠀⠀⠀⠀ (same for all links)
