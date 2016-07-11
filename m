Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36339 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcGKLRi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 07:17:38 -0400
Received: by mail-io0-f195.google.com with SMTP id y34so44519ioi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 04:17:37 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <20160711072612.GA1417185@mother.pipebreaker.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
Date: Mon, 11 Jul 2016 07:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <20160711072612.GA1417185@mother.pipebreaker.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-11 03:26, Tomasz Torcz wrote:
> On Tue, Jun 21, 2016 at 11:16:59AM -0400, Austin S. Hemmelgarn wrote:
>> Currently, balance operations are run synchronously in the foreground.
>> This is nice for interactive management, but is kind of crappy when you
>> start looking at automation and similar things.
>
>   It can be done with simplest systemd unit file:
> btrfs-balance@.service:
> ---
> [Unit]
> Description=btrfs balance for %I
>
> [Service]
> ExecStart=/usr/bin/btrfs balance start %I
> ExecStop=/usr/bin/btrfs balance cancel %I
> ---
>
>   It automates quite nicely and needs no additional code.
>
It's also entirely dependent on a couple of things:
1. You're running systemd (not everyone is, I'm certainly not).
2. You're only dealing with the local system.

The type of situation I'm thinking of is dealing with non-local systems. 
  For example, running something like this:
ssh user@remotehost btrfs balance start --background /
Keeping the SSH connection open for the duration of the balance has 
issues for some people (may close without keep-alive set, uses network 
bandwidth with keep-alive set, many people who are hosted have bandwidth 
quotas still), and it's extremely useful to have the option to fire and 
forget.
