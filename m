From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: only inherit btrfs specific flags when creating
 files
Date: Wed, 28 Sep 2011 08:26:09 -0400
Message-ID: <4E831261.9010100@redhat.com>
References: <1317135747-8198-1-git-send-email-josef@redhat.com> <4E82717D.6080008@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E82717D.6080008@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/27/2011 08:59 PM, Liu Bo wrote:
> On 09/27/2011 11:02 PM, Josef Bacik wrote:
>> Xfstests 79 was failing because we were inheriting the S_APPEND flag when we
>> weren't supposed to.  There isn't any specific documentation on this so I'm
>> taking the test as the standard of how things work, and having S_APPEND set on a
>> directory doesn't mean that S_APPEND gets inherited by its children according to
>> this test.  So only inherit btrfs specific things.  This will let us set
>> compress/nocompress on specific directories and everything in the directories
>> will inherit this flag, same with nodatacow.  With this patch test 79 passes.
>> Thanks,
>>
> 
> I've checked ext3&4, they have such comments:
> 
> /* Flags that should be inherited by new inodes from their parent. */
> #define EXT3_FL_INHERITED (EXT3_SECRM_FL | EXT3_UNRM_FL | EXT3_COMPR_FL |\
>                            EXT3_SYNC_FL | EXT3_IMMUTABLE_FL | EXT3_APPEND_FL |\
>                            EXT3_NODUMP_FL | EXT3_NOATIME_FL | EXT3_COMPRBLK_FL|\
>                            EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
>                            EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
> 
> It shows EXT[3,4]_APPEND_FL should be inherited from their parent, is this the standard?
> 

I have no idea actually, it was just failing on xfstest 79 and when I
took out the inheritance thing it passed so I took the test to be the
standard, maybe we should open this up to a wider audience.  Thanks,

Josef
