Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:49689 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992793AbbEPI1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 May 2015 04:27:14 -0400
Received: from [192.168.10.21] ([83.64.176.131]) by mrelayeu.kundenserver.de
 (mreue104) with ESMTPSA (Nemesis) id 0LsywU-1ZLKrd3gUM-012YLU for
 <linux-btrfs@vger.kernel.org>; Sat, 16 May 2015 10:27:11 +0200
Message-ID: <5556FF5F.1050907@floga.de>
Date: Sat, 16 May 2015 10:27:11 +0200
From: =?windows-1252?Q?Florian_Gamb=F6ck?= <ml@floga.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
References: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com> <20150515204340.GA20386@mew.dhcp4.washington.edu>
In-Reply-To: <20150515204340.GA20386@mew.dhcp4.washington.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 15.05.2015 um 22:43 schrieb Omar Sandoval:
> I'm going to completely bikeshed here, but Yoda conditions are already
> ugly in C, and completely pointless in Bash, where you can't ever
> accidentally reassign a variable in a condition. Either way, I think:
>
> if [ ! $AUTO ]; then
>
> would be clearer anyways.

Ah, I'm sorry to disagree with you, but your code snippet would only 
work if $AUTO is *empty*, and I think, to be totally correct you'd have 
to use the -n or -z test.

To sum it up now, you'd have to replace "false" with an empty string in 
the beginning of the file and the zero-test in the end. So something 
like the following:

AUTO=
# ...
if [ -z "$AUTO" ]; then

Regards
--Flo
