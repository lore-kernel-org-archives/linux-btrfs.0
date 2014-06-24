Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:41055 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaFXC6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 22:58:43 -0400
Received: by mail-qg0-f44.google.com with SMTP id j107so6812947qga.31
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 19:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
 <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Mon, 23 Jun 2014 22:58:22 -0400
Message-ID: <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a dd image, but not a btrfs-image. I ran the btrfs-image
command, but it threw the same errors as everything else and generated
a 0 byte file.

I agree that it SOUNDS like some kind of media failure, but if so it
seems odd to me that I was able to dd the entire partition with no
read errors. Even if there was something wrong with the drive that
prevented writing you'd think the ability to read it all would result
in a recoverable image.

smartctl -x /dev/sda (shortly after running smartctl -t long
/dev/sda): http://pastebin.com/kqSMZXsj

(The older failed tests are from several months ago. Completely
zeroing out the drive cleared them up and I haven't seen any issues
since.)

On Mon, Jun 23, 2014 at 9:17 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Jun 23, 2014, at 4:18 PM, Mike Hartman <mike@hartmanipulation.com> wrote:
>
>> Can anyone offer any suggestions? Is this data really unrecoverable? I
>> have no idea what could have gone so severely wrong.
>
> "btrfs check --repair /media/mint/usb_data/sda6_check.img
> "btrfs check --repair --init-csum-tree --init-extent-tree /media/mint/usb_data/sda6_check.img
>
> I think these things are going too far on actual file system without guidance, so it's superb you imaged the original drive first. Too many people get aggressive writing to the actual drive without backup images. You have both a dd image as well as btrfs-image which is really great. Hopefully someone can help find out what happened, it seems abruptly catastrophic, but also mixes messages where some information is being found but this one:
>         * read block failed check_tree_block
> makes me think of partial media failure. It would be damn bad luck if your metadata is set to DUP, yet both copies are toast. Is this an HDD or SSD?
>
> Can you post the result from smartctl -x /dev/sdX   #for the disk in question, maybe from a live system?
>
>
> Chris Murphy
>
