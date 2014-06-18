Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:36202 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaFRWSS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 18:18:18 -0400
Received: from g5t1627.atlanta.hp.com (g5t1627.atlanta.hp.com [15.192.137.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 9D7D55D52
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 21:58:27 +0000 (UTC)
Message-ID: <53A20FFF.3010807@hp.com>
Date: Wed, 18 Jun 2014 18:17:35 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>
CC: linux-btrfs@vger.kernel.org, clm@fb.com, t-itoh@jp.fujitsu.com
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>
In-Reply-To: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2014 04:57 PM, Marc Dionne wrote:
> Hi,
>
> I've been seeing very reproducible soft lockups with 3.16-rc1 similar
> to what is reported here:
> http://marc.info/?l=linux-btrfs&m=140290088532203&w=2 , along with the
> occasional hard lockup, making it impossible to complete a parallel
> build on a btrfs filesystem for the package I work on.  This was
> working fine just a few days before rc1.
>
> Bisecting brought me to the following commit:
>
>    commit bd01ec1a13f9a327950c8e3080096446c7804753
>    Author: Waiman Long<Waiman.Long@hp.com>
>    Date:   Mon Feb 3 13:18:57 2014 +0100
>
>        x86, locking/rwlocks: Enable qrwlocks on x86
>
> And sure enough if I revert that commit on top of current mainline,
> I'm unable to reproduce the soft lockups and hangs.
>
> Marc

The queue rwlock is fair. As a result, recursive read_lock is not 
allowed unless the task is in an interrupt context. Doing recursive 
read_lock will hang the process when a write_lock happens somewhere in 
between. Are recursive read_lock being done in the btrfs code?

-Longman
