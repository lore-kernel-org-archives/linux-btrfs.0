Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32889 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755492Ab3JHW3n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 18:29:43 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54109 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VTfmg-002T19-ID
	for linux-btrfs@vger.kernel.org; Tue, 08 Oct 2013 16:29:42 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't move subvols into subvols
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
Date: Tue, 8 Oct 2013 16:29:40 -0600
Message-Id: <21B1A985-7936-41DF-ADDC-6583EC4EEB98@colorremedies.com>
References: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 8, 2013, at 3:58 PM, Chris Murphy <lists@colorremedies.com> wrote:

> I don't think this is expected, is it? I can no longer move a subvolume into another subvolume. I can move a subvolume into a directory. 

So far this isn't working with 3.10.14 or 3.9.11.

The file system and subvolumes were created while btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64 was installed. So I think I need to go back to an older btrfs-progs. Or I need a new brain.


Chris Murphy