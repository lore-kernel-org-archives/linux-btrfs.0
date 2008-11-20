From: Lee Trager <lt73@cs.drexel.edu>
Subject: Re: btrfs thinks its full
Date: Thu, 20 Nov 2008 00:54:59 -0500
Message-ID: <4924FBB3.6030101@cs.drexel.edu>
References: <20081119222434.GA29942@tux64-01> <20081119222343.GF16041@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081119222343.GF16041@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Is that just finishing btrfs_check_free_space? What would that involve?
I haven't done much kernel work but I could give it a try.

Lee

Josef Bacik wrote:
> On Wed, Nov 19, 2008 at 05:24:34PM -0500, Lee Trager wrote:
>   
>> Because the last bug I dealt with had so much to do with the disk being
>> full I decided to test and see what happens when I fill up the disk.
>> Unfortunatly the disk thinks its full before it actually is. I have a
>> 7539M btrfs partition and tried to fill it by doing
>>
>> dd if=/dev/zero of=/mnt/btrfs/fill
>>
>> btrfs reports its full after 6408M have been used. dd, ls, and df all
>> confirm this. This uses only 85% of the disk but I can not put one more
>> bit onto the partition. The only thing that shows up in my system logs
>> is "space info full 1." I am using the latest git sources.
>>
>>     
>
> Yup thats by design :).  Theres a 85% full short-circuit in there to keep the
> panic unpleasentness from happening since there isn't proper ENOSPC handling.
> This will be tossed when the ENOSPC handling is done.  Thanks,
>
> Josef
>   

