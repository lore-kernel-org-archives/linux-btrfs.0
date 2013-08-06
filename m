Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:35724 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3HFFY3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 01:24:29 -0400
Message-ID: <5200888A.4030109@gmx.net>
Date: Tue, 06 Aug 2013 07:24:26 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Heavy memory leak when using quota groups
References: <20130806003505.7d7feff6@wpkg.org>
In-Reply-To: <20130806003505.7d7feff6@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05.08.2013 18:35, Tomasz Chmielewski wrote:
>> I am trying to use qgroups
>> functionality & with a basic random-write workload, it constantly
>> keeps leaking memory & within few minutes of IO, there is either
>> out-of-memory killer trying to kill some tasks or there are
>> page-allocation failures that btrfs or other kernel module
>> experiences.
> 
> FYI, I just saw something similar with 3.10 on a server with 32 GB RAM:
> 
> The result was a frozen server and a need to hard reset.
> 

What do I have to do to reproduce it here? How do you generate the load?
What is the disk setup, what the qgroups setup?

Thanks,
Arne
