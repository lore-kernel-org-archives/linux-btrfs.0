Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43173 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaKYRGz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 12:06:55 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so2172255wiv.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 09:06:54 -0800 (PST)
Message-ID: <5474B728.8020800@gmail.com>
Date: Tue, 25 Nov 2014 18:06:48 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] New 'btrfs chunk list' command
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it> <20141125161343.GI26471@twin.jikos.cz>
In-Reply-To: <20141125161343.GI26471@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/2014 05:13 PM, David Sterba wrote:
> On Tue, Nov 25, 2014 at 04:57:21PM +0100, Goffredo Baroncelli wrote:
>> This is a revamp of a my previous patches set[1]. After more than
>> year of attempts these patches were never merged, so I tried to
>> simplify them and to change a bit the focus. The previous patches set
>> had the focus to the disk usage.
> 
> The patches have been pending for last releases but I did not manage to
> fix all accounting problems in time and did not want to delay the
> releaes due to other important fixes. The 'new df' patchset is being
> refreshed each time and is part of the integration branches which might
> signify that they haven't been lost.
> 
Thanks David for care of that. Unfortunately I didn't heard anything
so I feared that this patch was lost.

I hoped that simplifying the patches set, it would be more simple to
integrate.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
