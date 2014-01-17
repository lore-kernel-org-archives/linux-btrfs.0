Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58855 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaAQUkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 15:40:55 -0500
Received: by mail-ie0-f175.google.com with SMTP id ar20so1280364iec.20
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 12:40:54 -0800 (PST)
Message-ID: <52D99554.2060006@gmail.com>
Date: Fri, 17 Jan 2014 15:40:52 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "valleysmail-lol5@yahoo.de" <valleysmail-lol5@yahoo.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: drawbacks of non-ECC RAM
References: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com>
In-Reply-To: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/17/2014 01:33 PM, valleysmail-lol5@yahoo.de wrote:
> 
> 
> I'd like to know if there are drawbacks in using btrfs with non-ECC
> RAM instead of using ext4 with non-ECC RAM. I know that some
> features of btrfs may rely on ECC RAM but is the chance of data
> corruption or even a damaged filesystem higher than when i use ext4
> instead of btrfs? I want to know this because i would like to use
> the snapshot feature of btrfs and ext4 does not support that. I
> will not use btrfs for fixing silent data corruption nor for using
> RAID like features or encryption. ZFS however checks files in the
> background (even if i don't want) and if it thinks there is an
> error it will fix it and i cannot disable this feature. So errors
> in RAM may corrupt my files or even more.
> 
> 
> If you have some information regarding this topic or some good
> links i would be very happy! =)

Theoretically, there should be little difference, and it should in
fact be slightly safer to use BTRFS than EXT4 in general because the
data structures for BTRFS are slightly more resilient, and it is smart
enough to check the on-disk data if stuff in memory looks damaged.

AFAIK, none of the features in BTRFS depend on using ECC RAM, and
BTRFS's error recovery is entirely independent of whether the system
RAM is ECC or not.  The aren't really any BTRFS specific drawbacks to
using non-ECC ram.

If you're really that paranoid about data corruption, you really
should be using both ECC RAM and a RAID setup.  Unless your hardware
is damaged (or you plan on sending your computer to space or running
it near a poorly shielded nuclear reactor), the chance of data in ram
not matching that on-disk is very low.

As an entirely secondary thought, BTRFS is almost always faster on
commodity hardware than ZFS.  ZFS was designed to be used on high-end
server systems with dozens of disks on multiple RAID controllers, so
it's a lot less efficient in most other use cases than BTRFS.
