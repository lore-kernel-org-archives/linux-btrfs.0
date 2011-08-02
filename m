From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: skip looking for delalloc if we don't have ->fill_delalloc
Date: Tue, 02 Aug 2011 08:24:58 -0400
Message-ID: <4E37EC9A.20908@redhat.com>
References: <1312215076-10329-1-git-send-email-josef@redhat.com> <4E3753AD.4010606@cn.fujitsu.com> <4E37564F.1040902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E37564F.1040902@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2011 09:43 PM, liubo wrote:
> On 08/02/2011 09:32 AM, liubo wrote:
>> On 08/02/2011 12:11 AM, Josef Bacik wrote:
>>> We always look for delalloc bytes in our io_tree so we can fill in delalloc.
>>> This is fine in most cases, but if we're writing out the btree_inode this is
>>> just a superfluous tree search on the io_tree, and if we have a lot of metadata
>>> dirty this could be an expensive check.  So instead check to see if our io_tree
>>> has a ->fill_delalloc op, and if not don't even bother doing the lookup.
>>> Thanks,
>>>
>>> Signed-off-by: Josef Bacik <josef@redhat.com>
>>> ---
>>
> 
> sorry, I mixed the patch with others...
> 
> The patch is ok.
> 

Good because I was horribly confused for a moment :),

Josef
