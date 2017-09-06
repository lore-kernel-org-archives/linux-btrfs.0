Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46322 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754074AbdIFC4u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 22:56:50 -0400
Date: Wed, 6 Sep 2017 04:56:48 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: A L <crimsoncottage@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: \o/ compsize
Message-ID: <20170906025648.42rxtzfp6xr6z2ql@angband.pl>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
 <8eb521a6-03d9-a8d3-b7e7-bf86d5320235@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8eb521a6-03d9-a8d3-b7e7-bf86d5320235@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 10:33:40PM +0200, A L wrote:
> On 9/4/2017 5:11 PM, Adam Borowski wrote:
> > Hi!
> > Here's an utility to measure used compression type + ratio on a set of files
> > or directories: https://github.com/kilobyte/compsize
> 
> Great tool. Just tried it on some of my backup snapshots.
> 
>    # compsize portage.20170904T2200
>    142432 files.
>    all   78%  329M/ 422M
>    none 100%  227M/ 227M
>    zlib  52%  102M/ 195M
> 
>    # du -sh  portage.20170904T2200
>    787M    portage.20170904T2200
> 
>    # btrfs fi du -s  portage.20170904T2200
>         Total   Exclusive  Set shared  Filename
>     271.61MiB     6.34MiB   245.51MiB portage.20170904T2200
> 
> Interesting results. How do I interpret them?

I've added some documentation; especially in the man page.

(Sorry for not pushing this earlier, Timofey went wild on this tool and I
wanted to avoid conflicts.)

> Compsize also doesn't seem to like some non-standard files and throws an
> error (even though they should be ignored?):
> 
> # compsize usb-backup/volumes/root/root.20170727T2321/
> open("usb-backup/volumes/root/root.20170727T2321//tmp/screen/S-root/2757.pts-1.e350"):
> No such device or address
> 
> # dir
> usb-backup/volumes/root/root.20170727T2321//tmp/screen/S-root/2757.pts-1.e350
> srwx------ 1 root root 0 Dec 31  2015 usb-backup/volumes/root/root.20170727T2321//tmp/screen/S-root/2757.pts-1.e350=

Fixed.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
