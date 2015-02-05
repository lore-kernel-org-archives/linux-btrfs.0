Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41946 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbbBEMsD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 07:48:03 -0500
Received: by mail-ig0-f174.google.com with SMTP id b16so41972635igk.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 04:48:01 -0800 (PST)
Message-ID: <54D3667C.8070803@gmail.com>
Date: Thu, 05 Feb 2015 07:47:56 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Juergen Fitschen <me@jue.yt>, linux-btrfs@vger.kernel.org
Subject: Re: Deadlock on 3.18.5
References: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt> <C90D8017-3361-4B95-99E8-859958AF5D28@jue.yt>
In-Reply-To: <C90D8017-3361-4B95-99E8-859958AF5D28@jue.yt>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-02-05 06:04, Juergen Fitschen wrote:
> Hey,
>
> It’s me again.
> First of all: Thanks for the reply, Duncan :)
>
> After detecting the deadlock und posting the stack trace yesterday evening, I left the machine alone and didn’t rebooted it. The monitoring told me that the whole server (including the hypervisor) became unreachable a few minutes after I fetched the stack trace from syslog.
>
> But now - as I just realised - the server is back alive, the process finished successfully and the volume is accessible. So the deadlock was not a real deadlock or resolved itself magically without me doing anything. The syslog reports several stack traces from kworker for about 2 hours (the time the server was not reachable). Within the first hour syslog was completely silent. Within the second hour the kernel complains about that rcu_sched dected stalls on the CPU in an interval of 3 minutes.
>
> What do you think?

I've actually seen similar behavior without the virtualization when 
doing large filesystem intensive operations with compression enabled.
I don't know if this is significant, but it seems to be worse with lzo 
compression than zlib, and also seems to be worse when compression is 
enabled at the filesystem level instead of through 'chattr +c'.

I'm not certain, but I think it might have something to do with the 
somewhat brain-dead default parameters in the default I/O scheduler (the 
so-called 'completely fair queue', which as I've said before was 
obviously named by a mathematician and not based on it's actual 
behavior), although it seems to be much worse when using the Deadline 
and no-op I/O schedulers.
