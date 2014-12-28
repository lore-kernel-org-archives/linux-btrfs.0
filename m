Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39993 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaL1MHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 07:07:40 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Bardur Arantsson <spam@scientician.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sun, 28 Dec 2014 13:07:38 +0100
Message-ID: <11274819.qjhECasOKp@merkaba>
In-Reply-To: <549F80FD.4050804@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <m7nkoo$15b$1@ger.gmane.org> <549F80FD.4050804@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 20:03:09 schrieb Robert White:
> Now:
> 
> The complaining party has verified the minimum, repeatable case of 
> simple file allocation on a very fragmented system and the responding 
> party and several others have understood and supported the bug.

I didn´t yet provide such a test case.

At the moment I can only reproduce this kworker thread using a CPU for
minutes case with my /home filesystem.

A mininmal test case for me would be to be able to reproduce it with a 
fresh BTRFS filesystem. But yet with my testcase with the fresh BTRFS I
get 4800 instead of 270 IOPS.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
