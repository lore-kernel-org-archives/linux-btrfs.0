Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40924 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbbEQJAH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 05:00:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YtuQW-0004uf-Jm
	for linux-btrfs@vger.kernel.org; Sun, 17 May 2015 11:00:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 11:00:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 11:00:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
Date: Sun, 17 May 2015 08:57:14 +0000 (UTC)
Message-ID: <pan$d8c97$deca2272$e50e1da0$5aecdcf8@cox.net>
References: <554F6D43.2060806@googlemail.com>
	<554F7232.9080804@googlemail.com> <5557F490.5000606@googlemail.com>
	<pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net> <20150517083654.GA5425@mew>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Omar Sandoval posted on Sun, 17 May 2015 01:36:54 -0700 as excerpted:

> I should have been clearer in that other thread: conversion from ext4 to
> Btrfs works, its just that the commit that caused the regression did not
> actually accomplish what it set out to do: allow converting the
> data/metadata profile of a freshly btrfs-converted ext4 filesystem.

Thank you.  Clearer now. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

