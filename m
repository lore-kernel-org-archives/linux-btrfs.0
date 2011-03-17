From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: How to implement raid1 repair
Date: Thu, 17 Mar 2011 18:52:38 +0100
Message-ID: <4D824A66.5020205@jan-o-sch.net>
References: <4D821ED3.5050605@jan-o-sch.net> <20110317171911.GA11704@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110317171911.GA11704@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

(snipped the parts already commented on in the other mails just sent)

On 03/17/2011 06:19 PM, Josef Bacik wrote:
> On Thu, Mar 17, 2011 at 03:46:43PM +0100, Jan Schmidt wrote:
>> If either of the answers is "no", tracking where the initial read came
>> from seems inevitable. Tracking would be very easy if bios came back
>> with unmodified values in bd_bdev and bd_sector, which is not the case.
> 
> Huh?  The bios come back with the bi_bdev/bi_sector they were submitted on, how
> are you getting something different?  Thanks,

That's only if you write to the block device directly. If I'm not
mistaken, you'll have bi_bdev and bi_sector modified when using bios
with partitions to block-device-absolute values.

Jan
