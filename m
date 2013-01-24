Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:37692 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3AXK0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 05:26:21 -0500
Message-ID: <51010ACD.2060302@gmx.net>
Date: Thu, 24 Jan 2013 11:19:57 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: praneeth u <praneethu.u@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Open for contribution towards Btrfs testing
References: <CAMO4zuj7gSSo2D4x7gxMivggZ1rxXEHpT+aEcHk-TMm4W-dmCA@mail.gmail.com>
In-Reply-To: <CAMO4zuj7gSSo2D4x7gxMivggZ1rxXEHpT+aEcHk-TMm4W-dmCA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 24.01.2013 06:10, praneeth u wrote:
> Hello,
> We are team of 5 students, interns at Green turtles technologies,
> interested in contributing to btrfs.
> Any space for contribution in btrfs testing ? we will be updating
> pogress twice in a week.
> Need suggestions on how to proceed.

The quota subsystem (qgroups) is new and there are no tests for
it yet. Tests for space tracking and limiting are needed. Also
hierarchical quota need testing.
Stress testing would be useful, too.
Would you be interested in that?

-Arne

> 
> 
> --
> Praneeth U
> 9448804728
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

