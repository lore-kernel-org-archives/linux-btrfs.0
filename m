Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbcANOUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 09:20:46 -0500
Date: Thu, 14 Jan 2016 15:20:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs: fix output of compression message in
 btrfs_parse_options()
Message-ID: <20160114142043.GX4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201601060803.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160113123343.GP4227@twin.jikos.cz>
 <5696E72A.9080904@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5696E72A.9080904@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 09:09:14AM +0900, Tsutomu Itoh wrote:
> On 2016/01/13 21:33, David Sterba wrote:
> > On Wed, Jan 06, 2016 at 05:03:40PM +0900, Tsutomu Itoh wrote:
> >>   			} else if (strncmp(args[0].from, "no", 2) == 0) {
> >>   				compress_type = "no";
> >>   				btrfs_clear_opt(info->mount_opt, COMPRESS);
> >>   				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
> >>   				compress_force = false;
> >> +				no_compress++;
> >>   			} else {
> > ...
> >> +			if ((btrfs_test_opt(root, COMPRESS) &&
> >> +			     (info->compress_type != saved_compress_type ||
> >> +			      compress_force != saved_compress_force)) ||
> >> +			    (!btrfs_test_opt(root, COMPRESS) &&
> >> +			     no_compress == 1)) {
> >
> > If there are more than one 'compress=no' then the message won't be
> > printed. I don't see a reason for doing no_compress++ above.
> 
> I want to output message as follows. Therefore, no_compress++ is necessary.
> 
> # mount -o compress,compress,compress=no,compress=no,compress,compress=no <dev> <path>
> 
> [  162.048033] BTRFS: device fsid a7f6e96e-653e-42d0-8469-13025396caa2 devid 1 transid 3 <dev>
> [  185.349034] BTRFS info (device <dev>): use zlib compression
> [  185.349041] BTRFS info (device <dev>): use no compression
> [  185.349045] BTRFS info (device <dev>): use zlib compression
> [  185.349048] BTRFS info (device <dev>): use no compression
> [  185.349050] BTRFS info (device <dev>): disk space caching is enabled

I don't think it's necessary ty print all the options. Only the last one
is applied so I'd expect to see only "... use no compression".
