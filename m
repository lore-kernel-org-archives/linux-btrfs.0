Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57234 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751145AbaKRGKP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 01:10:15 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Btrfs on a failing drive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>
Date: Mon, 17 Nov 2014 23:10:11 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <D4DFA3D3-8BEB-4659-BC19-F3F09ADFA5B1@colorremedies.com>
References: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>
To: Fennec Fox <fennectech@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 17, 2014, at 3:55 PM, Fennec Fox <fennectech@gmail.com> wrote:

> well i am an arch linux user and machine owner using a failing drive
>  its still relyable enough for me but btrfs seems not to mark bad
> blocks as unusable and continues to try to write to them.

It’s supposed to do try to write to them. If there is actual persistent write failure it’s the job of the firmware to reassign the affected LBA to a reserve physical sector. If it can’t do this, the drive is no longer normally operating, it should return a write error and ideally Btrfs would refuse to use the drive at all. I don’t know if that device rejection code exists yet. It hasn’t been the job of the filesystem to keep track of bad physical sectors since ancient times.


Chris Murphy