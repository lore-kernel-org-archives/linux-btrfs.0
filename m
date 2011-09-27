From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: break out of orphan cleanup if we can't make progress
Date: Tue, 27 Sep 2011 11:11:08 -0400
Message-ID: <4E81E78C.80804@redhat.com>
References: <1317066989-22566-1-git-send-email-josef@redhat.com> <20110927144413.GE22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110927144413.GE22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/27/2011 10:44 AM, David Sterba wrote:
> On Mon, Sep 26, 2011 at 03:56:29PM -0400, Josef Bacik wrote:
>> I noticed while running xfstests 83 that if we didn't have enough space to
>> delete our inode the orphan cleanup would just loop.  This is because it keeps
>> finding the same orphan item and keeps trying to kill it but can't because we
>> don't get an error back from iput for deleting the inode.
> 
> It would make more sense to catch this error rather than bailing out.
> One undeletable orphan forbids any following orphans to be deleted until
> next mount(?), dunno.
> 

Yeah but since iput doesn't return an error there's only so much I can
do.  I suppose I could just bypass all of this and call delete by hand,
but that seems ugly and prone to other failures.  Really this shouldn't
happen at all, but at least this will keep the thing from mounting and
then we can debug the issue further without bringing the users box to a
halt.  Thanks,

Josef
