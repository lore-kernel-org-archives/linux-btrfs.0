Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36302 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755786AbaIQS57 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 14:57:59 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with unmountable filesystem.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54196F42.4030101@gmail.com>
Date: Wed, 17 Sep 2014 12:57:59 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com>
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com> <54196F42.4030101@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 17, 2014, at 5:23 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> 
> Thanks for all the help.

Well, it's not much help. It seems possible to "corrupt" a primary superblock that points to a corrupt tree root, and use btrfs rescure super-recover to replace it, and then mount should work. One thing I didn't try was corrupting the primary superblock and just mounting normally or with recovery, to see if it'll automatically ignore the primary superblock and use the backup.

But I think you're onto something, that a good superblock can point to a corrupt tree root, and then not have a straight forward way to mount the good tree root. If I understand this correctly.


Chris Murphy

