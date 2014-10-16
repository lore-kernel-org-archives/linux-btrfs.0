Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaJPNdn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 09:33:43 -0400
Message-ID: <543FC933.7050400@redhat.com>
Date: Thu, 16 Oct 2014 08:33:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Zach Brown <zab@zabbo.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] some btrfs-progs coverity fixes
References: <1413414861-28097-1-git-send-email-zab@zabbo.net> <20141016114612.GD22943@twin.jikos.cz>
In-Reply-To: <20141016114612.GD22943@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/16/14 6:46 AM, David Sterba wrote:
> On Wed, Oct 15, 2014 at 04:14:17PM -0700, Zach Brown wrote:
>> Here's another set of coverity fixes for btrfs-progs against David's 
>> integration-20141007 branch.
> 
> Thanks, I've fished 2 patches for 3.17, the rest is queued.
> 
>> I got tired of adding error checking after a few so I moved on to the
>> other warnings.  Maybe we should subscribe linux-btrfs to the reports
>> that coverity can send out?
> 
> I'm not sure if this is allowed by the coverity service and I was not
> able to any info about that.

We could, in theory, "invite" the list, and then I suppose we'd get
a confirmation email that 100 people would click on.  ;)

Could maybe just email the scan folks and ask.

I'm a little on the fence about immediately broadcasting all defects, though.
I doubt there should be security implications, but ...

I wish scan were better integrated with git, and then something like
"email the author of the commit that introduced a new defect" would
be pretty cool.

-Eric
