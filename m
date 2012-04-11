From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH 0/3] btrfs: extended inode refs
Date: Wed, 11 Apr 2012 15:29:12 +0200
Message-ID: <4F858728.1000207@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <4F7E0AF9.7070305@suse.de> <4F858312.6090905@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.de>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F858312.6090905@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 11.04.2012 15:11, Jan Schmidt wrote:
> Hi Jeff,
> 
> On 05.04.2012 23:13, Jeff Mahoney wrote:
>>> As a result, we must use a different addressing scheme. Extended
>>> ref keys look like:
>>
>>> (inode objectid, BTRFS_INODE_EXTREF_KEY, hash)
>>
>>> Where hash is defined as a function of the parent objectid and link
>>> name.
>>
>> I think this is effective. It will essentially have the same
>> properties as a dirent but seeds the hash at objectid instead of ~1.
> 
> The objectid is already part of the key. What's the point in seeding it
> to crc32 instead of ~1?

While reading the patch set, I'm just seeing that the first objectid is
the inode's obectid while the latter is the parent's objectid. I'm fine
with that.

Thanks,
-Jan
