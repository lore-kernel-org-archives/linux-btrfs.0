From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0
 [btrfs]()
Date: Mon, 19 Sep 2011 11:49:40 -0400
Message-ID: <4E776494.6050706@redhat.com>
References: <4E6BDAEB.7020206@tuxadero.com> <4E6EABAF.9010903@cn.fujitsu.com> <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net> <20110915195556.GI22205@twin.jikos.cz> <4E73788F.3060906@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, Sage Weil <sage@newdream.net>,
	Liu Bo <liubo2009@cn.fujitsu.com>, martin@tuxadero.com,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4E73788F.3060906@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2011 12:25 PM, Jim Schutt wrote:
> David Sterba wrote:
>> On Thu, Sep 15, 2011 at 11:44:09AM -0700, Sage Weil wrote:
>>> On Tue, 13 Sep 2011, Liu Bo wrote:
>>>> On 09/11/2011 05:47 AM, Martin Mailand wrote:
>>>>> Hi
>>>>> I am hitting this Warning reproducible, the workload is a ceph osd,
>>>>> kernel ist 3.1.0-rc5.
>>>>>
>>>> Have posted a patch for this:
>>>>
>>>> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2
>>> We're still seeing this with -rc6, which includes 98c9942 and 65450aa.
>>
>> Me too, for the
>> WARNING: at fs/btrfs/extent-tree.c:5711
>> btrfs_alloc_free_block+0x180/0x350 [btrfs]()
>>
> 
> FWIW, I'm seeing a slightly different case, while testing branch
> integration/btrfs-next (commit 2828cbd9620e03) from
> git://repo.or.cz/linux-2.6/btrfs-unstable.git merged into branch
> master (commit c455ea4f122d21) from git://github.com/torvalds/linux.git
> 

Ah yeah sorry I see what's going on here, I just missed a few places we
call run_delayed_refs() where we can still have trans->block_rsv set.  I
will fix this and send a patch soon.  Thanks,

Josef
