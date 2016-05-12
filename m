Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:49761 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbcELN4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 09:56:32 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Cc: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Amount of scrubbed data goes from 15.90GiB to 26.66GiB after =?iso-8859-1?Q?defragment_-r_-v_-clzo_on_a_fs_always_mounted_with_compres?=
 =?iso-8859-1?Q?s=3Dlzo?=
Date: Thu, 12 May 2016 15:56:20 +0200
MIME-Version: 1.0
Message-ID: <60018ed4-023e-4ca6-8f74-e19b8849de65@linuxsystems.it>
In-Reply-To: <pan$331b6$43ad41cc$c9aa5858$e14154bc@cox.net>
References: <264486fb-94ce-4040-a436-e9db5de9a203@linuxsystems.it>
 <pan$331b6$43ad41cc$c9aa5858$e14154bc@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the detailed explanation, hopefully in the future someone will 
be able to make defrag snapshot/reflink aware in a scalable manner.
I will not use use defrag anymore, but what do you suggest me to do to 
reclaim the lost space? Get rid of my current snapshots or maybe simply 
running bedup?

Niccolò
