From: Josef Bacik <josef@redhat.com>
Subject: Re: [GIT PULL] ENOSPC rework and random fixes for next merge window
Date: Tue, 27 Sep 2011 11:11:56 -0400
Message-ID: <4E81E7BC.40006@redhat.com>
References: <1317072992-28375-1-git-send-email-josef@redhat.com> <20110927150117.GF22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110927150117.GF22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/27/2011 11:01 AM, David Sterba wrote:
> On Mon, Sep 26, 2011 at 05:36:32PM -0400, Josef Bacik wrote:
>>       Btrfs: fix how we mount subvol=<whatever>
> 
> this patch was not sent to the mailiglist, although this is an
> intersting change from the user's POV:
> 
> subvolumes are now mountable via
> 
> -o subvol=any/path/always/relative/to/toplevel
> 
> which makes subvolrootid obsolete and fixes the mess with set-default
> and subvol= mounts.
> 

Oops crap sorry I thought I had sent it to the list already, my bad.
Thanks,

Josef
