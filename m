Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45634 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaFVBgw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jun 2014 21:36:52 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPLrYET=97qfHWiDh0oKoYBU1r_RSkyma_mWKE=GSoTBFhm7GQ@mail.gmail.com>
Date: Sat, 21 Jun 2014 19:36:47 -0600
Cc: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <1E0ACE08-C8A9-4E5C-8084-D3EB0E937B7B@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com> <2316027.LZEnVG8laK@xev> <CAK5rZE4GVJ7qh4w=ecTZhZMANT0A6cU-6+jAbifNtoWFeYtf4Q@mail.gmail.com> <CAK5rZE4yA0PDR3S2RgTgXyQ=8ViRwSPg__DacPKXSpCmjzpW4w@mail.gmail.com> <CAPLrYET=97qfHWiDh0oKoYBU1r_RSkyma_mWKE=GSoTBFhm7GQ@mail.gmail.com>
To: =?utf-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 21, 2014, at 1:19 PM, Daniel Cegiełka <daniel.cegielka@gmail.com> wrote:

> 2014-06-19 11:11 GMT+02:00 Imran Geriskovan <imran.geriskovan@gmail.com>:
>> On 6/19/14, Russell Coker <russell@coker.com.au> wrote:
> 
>> 
>> Grub installs itself and boots from Partitionless Btrfs disk.
>> It is handy for straight forward installations.
>> 
>> However, IF you need boot partition (ie. initramfs and kernel to boot
>> from encrypted root) its another story.
> 
> zfs "solved" this problem in grub (libzfs). I think we can find a
> solution to work around this problem.

I don't know that this is a file system problem. There's some recent work being done in GRUB so that it's possible to use a dmcrypt+LUKS encrypted boot volume. Once that's working it shouldn't matter what the file system is.

Chris Murphy