Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:36244 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2FYUUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 16:20:35 -0400
Message-ID: <4FE8C80F.2040009@profihost.ag>
Date: Mon, 25 Jun 2012 22:20:31 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE58366.8000302@profihost.ag> <4FE862D7.3060005@fusionio.com> <4FE870DF.90308@profihost.ag> <20120625142048.GB7404@localhost.localdomain> <4FE8796E.9030300@profihost.ag> <20120625144807.GC7404@localhost.localdomain> <4FE8A21E.7050104@profihost.ag> <20120625180252.GD7404@localhost.localdomain> <4FE8ADBA.20505@profihost.ag> <4FE8BCF5.4080605@profihost.ag> <20120625201151.GG7404@localhost.localdomain>
In-Reply-To: <20120625201151.GG7404@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 25.06.2012 22:11, schrieb Josef Bacik:
> On Mon, Jun 25, 2012 at 01:33:09PM -0600, Stefan Priebe wrote:
>> With v3.4 the same. Can't go back more as this really results in very
>> fast corruption. Any ideas how to debug?
>>
>
> What workload are you running?  I have a ssd here with discard support I can try
> and reproduce on.  Thanks,

i'm using fio with 50 jobs and randwrite of 4k blocks in ceph but i 
don't know which load ceph then exactly generates. ;-(

Stefan
