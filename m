Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:49240 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbcDPKZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Apr 2016 06:25:21 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Roman Mamedov <rm@romanrm.net>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors after rebooting with Magic Sysrq Keys
Date: Sat, 16 Apr 2016 12:25:12 +0200
MIME-Version: 1.0
Message-ID: <e359750f-9fbe-46d5-b16e-adc83539722b@linuxsystems.it>
In-Reply-To: <20160415215839.7754f866@natsu>
References: <b4f09d8b-baac-4182-81b1-1ba9f5e4195b@linuxsystems.it>
 <5710B4B8.9020002@cn.fujitsu.com>
 <30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
 <20160415215839.7754f866@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I finally run a btrfs check --readonly on my fs, sorry if it took so long 
but it complained about the fs being mounted even if it was readonly, so I 
had to download a Fedora 24 alpha livecd to be able to run it.
Here it is (8.5MB): 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1blJGMTNHaDdUQjg

In the meantime, since I suspected it may be a 4.6 regression, I switched 
back to 4.5.

P.S.
Scrub's uncorrectable errors went down from 10 to 4 by itself, without any 
apparent reason.

Niccolò
