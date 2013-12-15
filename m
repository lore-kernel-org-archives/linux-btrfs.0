Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:51508 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3LORlI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 12:41:08 -0500
Received: by mail-qc0-f169.google.com with SMTP id r5so3055880qcx.14
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 09:41:08 -0800 (PST)
Message-ID: <52ADE972.4000303@gmail.com>
Date: Sun, 15 Dec 2013 12:40:02 -0500
From: Gene Czarcinski <gczarcinski@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: moving a subvol
References: <52AB30D4.7050408@czarc.net> <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com> <52AB5F2E.8020209@czarc.net> <1663965.RJ0nqNbRyM@quad> <52AC2B90.909@czarc.net> <772D6056-AD90-4B98-AAC8-E0C866E6F714@colorremedies.com>
In-Reply-To: <772D6056-AD90-4B98-AAC8-E0C866E6F714@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2013 01:43 PM, Chris Murphy wrote:
> On Dec 14, 2013, at 2:57 AM, Gene Czarcinski <gczarcinski@gmail.com> wrote:
>>   Since I run Fedora with anaconda I use kickstart installs and can easily repeat an install since it included almost everything I want installed.  And then I have a post-install script I run to pickup additional stuff.
> This is a bit of a hijack question, but does kickstart offer a way to mount Btrfs with compression option?
>
>
> Chris Murphy
Interesting; it does not "currently" but that sounds like it should be 
(RFE time) an added option so that it would be in fstab from the start.  
It may not be that simple since if you specify compression for a 
subvolume, that means that everything anaconda installs on the subvolume 
should be subjected to compression and not just stuff written post-install.

I do not currently use compression but I should give it a try.

Chris, since I know kickstart and you do not, I will BZ the RFE. BTW, is 
this an option on the regular GUI install?

Gene
