Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59710 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3CUWXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 18:23:50 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so3747213oag.18
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 15:23:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F4BFA0F1-C466-48E6-941E-5B4879C99D74@oracle.com>
References: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
	<F4BFA0F1-C466-48E6-941E-5B4879C99D74@oracle.com>
Date: Thu, 21 Mar 2013 17:23:49 -0500
Message-ID: <CAKcLGm_1yoeY+T-bXoxZRGqVvt_Tbdx-VTeC0=Gx8u-JHJMN9w@mail.gmail.com>
Subject: Re: Problems with compiling btrfs
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Avi Miller <avi.miller@oracle.com>
Cc: Joseph Moore <japlha@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 21, 2013 at 4:46 PM, Avi Miller <avi.miller@oracle.com> wrote:
> Hi,
>
> On 22/03/2013, at 8:11 AM, Joseph Moore <japlha@gmail.com> wrote:
>
>> [root@ol6 btrfs-progs]# uname -a
>> Linux ol6.localdomain 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13
>> 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux
>
>
> This is the currently shipping Oracle Linux 6 UEK and as such, doesn't support a newer btrfs-progs. If you want to run a newer btrfs, you should install the 3.8 kernel from our playground channel on public-yum.oracle.com and then you can compile a newer btrfs-progs to match.
>
> I've also asked the playground build team to build a newer btrfs-progs RPM for the playground channel, but I'm not sure what the timeframes on that would be.
>
> --
> Oracle <http://www.oracle.com>
> Avi Miller | Principal Program Manager | +61 (412) 229 687
> Oracle Linux and Virtualization
> 417 St Kilda Road, Melbourne, Victoria 3004 Australia
>

I have also run into the same problem on Enterprise Linux 6.3
(Scientific Linux in my case).

It is relatively trivial to get a current kernel from sources like
ELREPO, so I was hoping to use my Scientific Linux partition at least
for rescue and evaluation.

Is the position of the Btrfs Developer community that Enterprise Linux
6.x is not to be supported?
