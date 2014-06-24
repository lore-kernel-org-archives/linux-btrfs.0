Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53758 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751066AbaFXBR5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 21:17:57 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
Date: Mon, 23 Jun 2014 19:17:54 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
To: Mike Hartman <mike@hartmanipulation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 23, 2014, at 4:18 PM, Mike Hartman <mike@hartmanipulation.com> wrote:

> Can anyone offer any suggestions? Is this data really unrecoverable? I
> have no idea what could have gone so severely wrong.

"btrfs check --repair /media/mint/usb_data/sda6_check.img
"btrfs check --repair --init-csum-tree --init-extent-tree /media/mint/usb_data/sda6_check.img

I think these things are going too far on actual file system without guidance, so it's superb you imaged the original drive first. Too many people get aggressive writing to the actual drive without backup images. You have both a dd image as well as btrfs-image which is really great. Hopefully someone can help find out what happened, it seems abruptly catastrophic, but also mixes messages where some information is being found but this one:
	• read block failed check_tree_block
makes me think of partial media failure. It would be damn bad luck if your metadata is set to DUP, yet both copies are toast. Is this an HDD or SSD?

Can you post the result from smartctl -x /dev/sdX   #for the disk in question, maybe from a live system?


Chris Murphy

