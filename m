Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3CUWiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 18:38:15 -0400
Message-ID: <514B8BD1.40808@redhat.com>
Date: Thu, 21 Mar 2013 17:38:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Avi Miller <avi.miller@oracle.com>, Joseph Moore <japlha@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Problems with compiling btrfs
References: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com> <F4BFA0F1-C466-48E6-941E-5B4879C99D74@oracle.com> <CAKcLGm_1yoeY+T-bXoxZRGqVvt_Tbdx-VTeC0=Gx8u-JHJMN9w@mail.gmail.com>
In-Reply-To: <CAKcLGm_1yoeY+T-bXoxZRGqVvt_Tbdx-VTeC0=Gx8u-JHJMN9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/21/13 5:23 PM, Mitch Harder wrote:
> On Thu, Mar 21, 2013 at 4:46 PM, Avi Miller <avi.miller@oracle.com> wrote:
>> Hi,
>>
>> On 22/03/2013, at 8:11 AM, Joseph Moore <japlha@gmail.com> wrote:
>>
>>> [root@ol6 btrfs-progs]# uname -a
>>> Linux ol6.localdomain 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13
>>> 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>> This is the currently shipping Oracle Linux 6 UEK and as such, doesn't support a newer btrfs-progs. If you want to run a newer btrfs, you should install the 3.8 kernel from our playground channel on public-yum.oracle.com and then you can compile a newer btrfs-progs to match.
>>
>> I've also asked the playground build team to build a newer btrfs-progs RPM for the playground channel, but I'm not sure what the timeframes on that would be.
>>
>> --
>> Oracle <http://www.oracle.com>
>> Avi Miller | Principal Program Manager | +61 (412) 229 687
>> Oracle Linux and Virtualization
>> 417 St Kilda Road, Melbourne, Victoria 3004 Australia
>>
> 
> I have also run into the same problem on Enterprise Linux 6.3
> (Scientific Linux in my case).
> 
> It is relatively trivial to get a current kernel from sources like
> ELREPO, so I was hoping to use my Scientific Linux partition at least
> for rescue and evaluation.
> 
> Is the position of the Btrfs Developer community that Enterprise Linux
> 6.x is not to be supported?

The Btrfs Developer Community really cannot support btrfs in a distro,
aside from answering some basic questions, perhaps.  If you have a distro
problem, report it to your distro; if you have an upstream problem, report
it upstream.  If your distro is close to upstream, you'll probably get
some help & attention from upstream.

As for RHEL6, btrfs is tech preview [1], and bug reports are appreciated
from RHEL users.  

Neither Red Hat nor upstream developers (or the people in the middle of
that Venn diagram) are really in a place to support a rebuilt version
of a commercial enterprise distro.  Often as not, that's "keep both pieces
when it breaks" land.

note: I believe that if you get upstream btrfs-progs building on a rhel6-alike,
you'll quickly run into another issue when you try to mount it.

If you want bleeding-edge btrfs, you should probably stick with bleeding-edge
kernels one way or another.

-Eric

[1] https://access.redhat.com/support/offerings/techpreview/
