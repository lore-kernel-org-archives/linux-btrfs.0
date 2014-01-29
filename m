Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49059 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaA2Oud (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 09:50:33 -0500
Received: by mail-wg0-f49.google.com with SMTP id a1so3653949wgh.4
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 06:50:32 -0800 (PST)
Received: from [192.168.3.115] ([194.9.67.191])
        by mx.google.com with ESMTPSA id el1sm5860396wib.4.2014.01.29.06.50.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 06:50:31 -0800 (PST)
Message-ID: <52E91535.8090306@statystyka.net>
Date: Wed, 29 Jan 2014 15:50:29 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS corrupted by combination of mistreatment of hiberantion and
 accidental power loss.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have two independent Linux installations my notebook, both sharing the 
same btrfs partition as root file system, but installed on different 
subvolumes.

I hibernated one Linux (Mint 15 64 bit). Hibernation data is stored on 
the swap file, which is used exclusively by this system.

Then 2 events happened.

1) I accidentally ran the other system, which wasn't hibernated - Ubuntu 
12.10. Realizing the problem, I waited until the system booted up, and 
then shutdowned it.

Then I opened the hibernated Mint 15. Restoration went successful, and I 
never thought I am in trouble.

2) Immediately after that, by coincidence, the battery fell down, 
brutally powering down the computer.

After that, I am unable to repair/mount the root btrfs partition, 
however I try (I built the current btrfs-tools from git). Dmesg displays 
only one error entry: btrfs: open_ctree failed.

I know, that if one those two events happened separately, there would be 
no problem. The problem arose only when those two events happened 
simultaneously.

So I guess I am experiencing one of the corner cases.

What are my prospects to restoring my data? I have several subvolumes on 
the hard drive, some of them were not touched by the accident at all.

Adam Ryczkowski

