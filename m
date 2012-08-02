Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:32805 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750737Ab2HBLSJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 07:18:09 -0400
Message-ID: <501A61ED.3000908@gmx.net>
Date: Thu, 02 Aug 2012 13:18:05 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Liu Bo <liub.liubo@gmail.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove superblock writing after fatal error
References: <1343821552-28726-1-git-send-email-sbehrens@giantdisaster.de> <50191AD3.9080401@gmail.com> <50192A11.3060109@jan-o-sch.net> <50192FCE.30006@gmail.com> <50193DDA.20504@giantdisaster.de> <501A56E3.3080401@giantdisaster.de> <501A583D.8030600@gmail.com>
In-Reply-To: <501A583D.8030600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02.08.2012 12:36, Liu Bo wrote:
> On 08/02/2012 06:30 PM, Stefan Behrens wrote:
>> On Wed, 01 Aug 2012 16:31:54 +0200, Stefan Behrens wrote:
>>> On Wed, 01 Aug 2012 21:31:58 +0800, Liu Bo wrote:
>>>> On 08/01/2012 09:07 PM, Jan Schmidt wrote:
>>>>> On Wed, August 01, 2012 at 14:02 (+0200), Liu Bo wrote:
>>>>>> On 08/01/2012 07:45 PM, Stefan Behrens wrote:
>>>>>>> With commit acce952b0, btrfs was changed to flag the filesystem with
>>>>>>> BTRFS_SUPER_FLAG_ERROR and switch to read-only mode after a fatal
>>>>>>> error happened like a write I/O errors of all mirrors.
>>>>>>> In such situations, on unmount, the superblock is written in
>>>>>>> btrfs_error_commit_super(). This is done with the intention to be able
>>>>>>> to evaluate the error flag on the next mount. A warning is printed
>>>>>>> in this case during the next mount and the log tree is ignored.
>>>>>>>
>>>>>>> The issue is that it is possible that the superblock points to a root
>>>>>>> that was not written (due to write I/O errors).
>>>>>>> The result is that the filesystem cannot be mounted. btrfsck also does
>>>>>>> not start and all the other btrfs-progs tools fail to start as well.
>>>>>>> However, mount -o recovery is working well and does the right things
>>>>>>> to recover the filesystem (i.e., don't use the log root, clear the
>>>>>>> free space cache and use the next mountable root that is stored in the
>>>>>>> root backup array).
>>>>>>>
>>>>>>> This patch removes the writing of the superblock when
>>>>>>> BTRFS_SUPER_FLAG_ERROR is set, and removes the handling of the error
>>>>>>> flag in the mount function.
>>>>>>>
>>>>>>
>>>>>> Yes, I have to admit that this can be a serious problem.
>>>>>>
>>>>>> But we'll need to send the error flag stored in the super block into
>>>>>> disk in the future so that the next mount can find it unstable and do
>>>>>> fsck by itself maybe.
>>>>>
>>>>> Hum, that's possible. However, I neither see
>>>>>
>>>>> a) a safe way to get that flag to disk
>>>>>
>>>>> nor
>>>>>
>>>>> b) a situation where this flag would help. When we abort a transaction, we just
>>>>> roll everything back to the last commit, i.e. a consistent state. So if we stop
>>>>> writing a potentially corrupt super block, we should be fine anyway. Or am I
>>>>> missing something?
>>>>>
>>>>
>>>> I'm just wondering if we can roll everything back well, why do we need fsck?
>>>
>>> If the disks support barriers, we roll everything back very well. The
>>> most recent superblock on the disks always defines a consistent
>>> filesystem state. There are only two remaining filesystem consistency
>>> issues left that can cause inconsistent states, one is the one that the
>>> patch in this email addresses, and the second one is that the error
>>> result from barrier_all_devices() is ignored (which I want to change next).
>>
>> Hi Liu Bo,
>>
>> Do you have any remaining objections to that patch?
>>
> 
> Hi Stefan,
> 
> Still I have another question:
> 
> Our metadata can be flushed into disk if we reach the limit, 32k, so we
> can end up with updated metadata and the latest superblock if we do not
> write the current super block.

The old metadata stays valid until the new superblock is written,
so no problem here, or maybe I don't understand your question :)

> 
> Any ideas?
> 
> thanks,
> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

