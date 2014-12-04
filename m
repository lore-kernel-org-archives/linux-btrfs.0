Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:54104 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932455AbaLDSck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:32:40 -0500
Message-ID: <5480A8C6.8010201@inwind.it>
Date: Thu, 04 Dec 2014 19:32:38 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
References: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com>
In-Reply-To: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/04/2014 02:53 PM, Shriramana Sharma wrote:
> I observe that whenever I create a BtrFS instance using mkfs.btrfs,
> there is always the leftover cruft of two System/Metadata-Single
> allocation profiles:
> 
> btrfs fi df /run/media/samjnaa/BRIHATII/
> Data, single: total=460.01GiB, used=458.47GiB
> System, DUP: total=8.00MiB, used=80.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=1.50GiB, used=736.86MiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=256.00MiB, used=0.00B

Time, to time this question returns:
this was a explanation from Hugo Mills
	http://permalink.gmane.org/gmane.comp.file-systems.btrfs/38205


: I believe it comes from mkfs creating a trivial basic filesystem
: (with the single profiles), and then setting enough flags on it that the
: kernel can bootstrap it with the desired chunks in it -- but I may be
: wrong about that.


> 
> Doing btrfs balance eventually removes these (but since I forgot to do
> it *before* copying 400+ G of data to the drive it's still running)
> but I don't understand why these have to be created in the first
> place? (I just used SuSE Tumbleweed's default mkfs.btrfs without any
> -m or -d options.)
> 




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
