Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:34055 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaGJOwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 10:52:47 -0400
Message-ID: <53BEA8BC.2000309@martos.bme.hu>
Date: Thu, 10 Jul 2014 16:52:44 +0200
From: Tamas Papp <tompos@martos.bme.hu>
MIME-Version: 1.0
To: Andrew Flerchinger <lorax3@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: File server structure suggestion
References: <CAGTBuzTWV2jVqy4uScevHbMi-kp4_TRdeR21ZoA3-yOtCXPA=g@mail.gmail.com>
In-Reply-To: <CAGTBuzTWV2jVqy4uScevHbMi-kp4_TRdeR21ZoA3-yOtCXPA=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 07/10/2014 04:41 PM, Andrew Flerchinger wrote:
> what was going on. That sold me on the idea of data checksums, but I'd
> rather stay in linux than BSD, and I previously made use of online
> capacity expansion as needed, which ZFS doesn't support.

What do you mean by that?
What zfs doesn't support is reducing a pool.


tamas
