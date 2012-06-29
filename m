Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54512 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2F2QPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 12:15:11 -0400
Received: by vcbf11 with SMTP id f11so2419682vcb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 09:15:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120629130437.GB1834@localhost.localdomain>
References: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
	<20120627134857.GC2819@localhost.localdomain>
	<CACCfv7oOU3-S5iNJqCd084-WK5WE=gBdwkOhd1tqF0udN7pw7Q@mail.gmail.com>
	<4FED3FA2.2060300@csamuel.org>
	<CACCfv7ovrSTJpD8+N-Vxb+hz6DqX7xpaxAxukC_0kLGAE6tGGQ@mail.gmail.com>
	<20120629130437.GB1834@localhost.localdomain>
Date: Sat, 30 Jun 2012 01:45:09 +0930
Message-ID: <CACCfv7ogX5Ha-5i2AoydRA8MYTTLrbdJOca70K1exCrr6NjNaw@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:1887 after hard shutdown.
From: Jordan Windsor <jordanw2@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Chris Samuel <chris@csamuel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 10:34 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Jun 29, 2012 at 12:35:01AM -0600, Jordan Windsor wrote:
>> On Fri, Jun 29, 2012 at 3:09 PM, Chris Samuel <chris@csamuel.org> wrote:
>> > On 29/06/12 15:36, Jordan Windsor wrote:
>> >
>> >> I get the same problem with linux-mainline from AUR (latest)
>> >
>> > What does uname -a say ?
>> >
>> > cheers!
>> > Chris
>> > --
>> >  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
>> >
>> >
>>
>> Hello,
>> It says:
>> Linux archpc 3.5.0-1-mainline #1 SMP PREEMPT Fri Jun 29 02:09:43 CST
>> 2012 x86_64 GNU/Linux
>>
>
> Oh crap I'm sorry I thought this was in mainline already but it's not, it's in
> btrfs-next, pull down this git tree and you should be good to go
>
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
>
> Thanks,
>
> Josef

Hello,
I got it working now thanks!
