Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46578 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2F2GfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 02:35:03 -0400
Received: by vbbff1 with SMTP id ff1so2106633vbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2012 23:35:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FED3FA2.2060300@csamuel.org>
References: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
	<20120627134857.GC2819@localhost.localdomain>
	<CACCfv7oOU3-S5iNJqCd084-WK5WE=gBdwkOhd1tqF0udN7pw7Q@mail.gmail.com>
	<4FED3FA2.2060300@csamuel.org>
Date: Fri, 29 Jun 2012 16:05:01 +0930
Message-ID: <CACCfv7ovrSTJpD8+N-Vxb+hz6DqX7xpaxAxukC_0kLGAE6tGGQ@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:1887 after hard shutdown.
From: Jordan Windsor <jordanw2@gmail.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 3:09 PM, Chris Samuel <chris@csamuel.org> wrote:
> On 29/06/12 15:36, Jordan Windsor wrote:
>
>> I get the same problem with linux-mainline from AUR (latest)
>
> What does uname -a say ?
>
> cheers!
> Chris
> --
>  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
>
>

Hello,
It says:
Linux archpc 3.5.0-1-mainline #1 SMP PREEMPT Fri Jun 29 02:09:43 CST
2012 x86_64 GNU/Linux

Thanks.
