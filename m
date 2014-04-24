Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49612 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752911AbaDXVGE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 17:06:04 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info>
Date: Thu, 24 Apr 2014 15:06:01 -0600
Cc: "'Marc MERLIN'" <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Message-Id: <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org>  <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 24, 2014, at 12:51 PM, Пламен Петров <plamen@petrovi.no-ip.info> wrote:
> 
> I booted 3.14.1 using sda3 as root, and then tried mounting sda2. It went OK, here is what dmesg said:
> [   12.412465] Btrfs loaded

For me, with Btrfs not compiled in the kernel, and with an initramfs, on SSD I get Btrfs loaded at 2.4 seconds. On HDD, it still happens by 6-7 seconds.

So without an initrd and with btrfs compiled into the kernel I'd expect to see Btrfs loaded before 12.4 seconds. Is this an SSD? Or HDD, or hardware raid?

I'd like to see the dmesg from the beginning, until "Btrfs Loaded", for both 3.13.11 and 3.14.1 (via serial console output). I think the clue is in the part before Btrfs loaded.

Also can you post a diff of the config file for the working 3.13.11 and not working 3.14.1 kernels?

Chris Murphy