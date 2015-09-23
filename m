Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18.italiaonline.it ([212.48.25.146]:48623 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754655AbbIWQc2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 12:32:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID6 duplicate device in array after replacing a drive. what
 the?
References: <3593680.XCB9qMyItR@roar>
To: Rob <btrfswok@jabawok.net>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5602D419.4090105@inwind.it>
Date: Wed, 23 Sep 2015 18:32:25 +0200
MIME-Version: 1.0
In-Reply-To: <3593680.XCB9qMyItR@roar>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-09-21 12:20, Rob wrote:
> 2. btrfs scrub cancel /media/btrfs-rpi-raid6
> 
> - I waited 4h but this didnt return to a prompt (tried unmounting, killall -9 
> btrfs) so i switched power off to the disks, replaced the faulty disk and 
> switched the enclosure on again.

I don't understood if the disks are in an external enclosure which was switched OFF (leaving the system ON) or you have switched OFF all the system. Could you clarify ?

BR

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
