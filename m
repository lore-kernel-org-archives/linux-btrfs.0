From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: the idea for improving the performance of b-tree search
Date: Mon, 18 Oct 2010 17:36:30 +0800
Message-ID: <4CBC151E.3070705@cn.fujitsu.com>
References: <4CB57548.7000304@cn.fujitsu.com> <20101018024141.GA5416@sli10-conroe.sh.intel.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101018024141.GA5416@sli10-conroe.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 18 Oct 2010 10:41:41 +0800, Shaohua Li wrote:
> Hi Miao&  Chris,
> On Wed, Oct 13, 2010 at 05:00:56PM +0800, Miao Xie wrote:
>> When I investigated the performance problem of file creation/deletion, I found
>> btrfs spends lots of time in the b-tree search, so I consider whether we can use
>> the latest search result in the same transaction or not.
>>
>> My idea follows:
>> we can add mask or time stamp into b-tree's node and leaf, then we know whether
>> the node/leaf is COWed by the other task. If not, we check if the node/leaf of
>> the latest search result contains the key that we want to search. By this way,
>> we can reuse the latest search result in the same transaction and reduce the CPU
>> time spent in the b-tree search.
> Does this patch help a little for the tree search?
> http://marc.info/?l=linux-btrfs&m=127175532803943&w=2
> It doesn't solve all the issues, but in my test, it does help.

Thanks for your patch, but according to my test result, the time of b-tree search
has not been reduced. I think the reason is that extent-state is used when btrfs writes
data into the disk, so your patch is helpful when the disk I/O happens, but my test just
measures the cost of the b-tree searchs/insertions/removals, the disk I/O doesn't happen.

Regards
Miao
