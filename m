Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35570 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3JWLUL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 07:20:11 -0400
Message-ID: <5267B0E0.5050402@oracle.com>
Date: Wed, 23 Oct 2013 19:20:00 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com> <20131015171333.GM5787@twin.jikos.cz> <20131021144428.GG6924@localhost.localdomain> <526612EB.1050802@oracle.com> <20131022132147.GA27304@localhost.localdomain> <20131022165233.GA1032@twin.jikos.cz>
In-Reply-To: <20131022165233.GA1032@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/23/13 12:52 AM, David Sterba wrote:
> On Tue, Oct 22, 2013 at 09:21:47AM -0400, Josef Bacik wrote:
>> Did you test these?  Because they aren't working for me, so I think a revert is
>> the only solution.  Thanks,
>
> The impact of the failing test is imho not that big to justify a full
> revert from integration branch (were it in master, then yes). I see the
> bug and I hope Anand will fix it soon.

  Sure. but what is the bug in btrfs-progs with this patch-set ?

  if its about xfstests btrfs/006 apparently it isn't working
  without this patch-set as well.

Thanks, Anand
