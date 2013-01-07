Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:37481
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382Ab3AGT2g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 14:28:36 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /boot as a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50EB0A65.4090009@petaramesh.org>
Date: Mon, 7 Jan 2013 12:28:34 -0700
Message-Id: <4BB08D19-D2E3-4783-8B30-2BF35C8ED846@colorremedies.com>
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org> <50E9D909.1020207@czarc.net> <50EB0A65.4090009@petaramesh.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 7, 2013, at 10:48 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Le 06/01/2013 21:05, Gene Czarcinski a écrit :
>> I assume you have a "grub partition" (or its equivalent) with a
>> grub.cfg file having menuentry definitions [pointing to the different
>> grub.cfg file for each system ... that seems to work well (at least
>> for me).  Currently, os-prober does not support btrfs. 
> 
> I don't have any specific "grub" partition, every Linux install has its
> own grub install in its own /boot BTRFS subvolume.

Grub partition, as I'm taking it, means: MBR gap on MBR layouts; and BIOS Boot partition (GUID 21686148-6449-6E6F-744E-656564454649) on GPT layouts.

In any case, MBR gap, dedicated GPT partition, or grub.efi application, it's possible to bake a grub.cfg directly into the core.img.

Technically using configfile is not chain loading, you're just having the same instance of GRUB load an alternate config. Chain loading GRUB implies loading a new binary (boot loader) to replace the first instance of GRUB. Using configfile has the caveat that the GRUB using configfile may be of a different version than the GRUB package that produced the grub.cfg being configfile loaded. And as the syntax of grub.cfg has been changing quite a bit it's possible to have related failures.

Chris Murphy