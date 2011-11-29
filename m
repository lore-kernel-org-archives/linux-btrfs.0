From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] fix bugs of sub transid
Date: Tue, 29 Nov 2011 09:18:35 +0800
Message-ID: <4ED432EB.2070706@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com> <20111128151030.GK12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	sensille@gmx.net
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111128151030.GK12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/28/2011 11:10 PM, David Sterba wrote:
> On Mon, Nov 21, 2011 at 06:10:19PM +0800, Liu Bo wrote:
>> We've been sufferring two big bugs with sub transid:
>> one is a bug related to root's last_snapshot, the other is a bug related to
>> disk extent refs' generation.
> 
> Do you have a testcase to trigger and check these bugs?
> 

Hi, David, 

a) For the first one (last_snapshot bug),

The test involves three processes (derived from Chris):

mkfs.btrfs /dev/xxx
mount /dev/xxx /mnt

1) run compilebench -i 30 --makej -D /mnt

Let compilebench run until it starts the create phase.

2) run synctest -f -u -n 200 -t 3 /mnt
3) for x in `seq 1 200` ; do btrfs subvol snap /mnt /mnt/snap$x ; sleep 0.5 ; done


b) For the second one, 

1) build a btrfs partition, and

2) fill something, and then

3) run balance on it.


>> 1) The first patch fixes a warning,
>> 2) the second one fixes the last_snapshot bug,
>> 3) the third one has already been in for-linus branch, but not in "danger"
>>    branch, so I add it here for the integrity,
>> 4) the fourth one fixes a transid mismatch bug,
>> 5) the fifth one fixes the disk extent refs' generation bug.
>>
>> Any advices and tests are welcome!
> 
> I have rebased this series on top of current cmason/for-linus (24a70313969),
> should anybody want to test.
> 
> (repo address: http://repo.or.cz/w/linux-2.6/btrfs-unstable.git )
> 


Great!  Thanks for what you've done!

thanks,
liubo


> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

