Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12028 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755095AbbLGDDI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 22:03:08 -0500
Subject: Re: [PATCH 0/3] btrfs-progs: fix file restore to lost+found bug
To: Naohiro Aota <naota@elisp.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
 <56623F4B.80502@gmx.com>
 <CAEe67=-3o9Roe7ewHRQqWnSe+HjVc22-_6FObHy2PeTwZXAcSQ@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5664F6D9.2060602@cn.fujitsu.com>
Date: Mon, 7 Dec 2015 11:02:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAEe67=-3o9Roe7ewHRQqWnSe+HjVc22-_6FObHy2PeTwZXAcSQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Naohiro Aota wrote on 2015/12/07 11:59 +0900:
> On Sat, Dec 5, 2015 at 10:35 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 12/04/2015 01:37 PM, Naohiro Aota wrote:
>>>
>>> This series address an issue of btrfsck to restore infinite number of
>>> same file into `lost+found' directory. The issue occur on a file which
>>> is linked from two different directory A and B. If links from dir A is
>>> corrupted and links from dir B is kept valid, btrfsck won't stop
>>> creating a file in lost+found like this:
>>>
>>> -----
>>> Moving file 'file.del.51' to 'lost+found' dir since it has no valid
>>> backref
>>> Fixed the nlink of inode 1876
>>> Trying to rebuild inode:1877
>>> Moving file 'del' to 'lost+found' dir since it has no valid backref
>>> Fixed the nlink of inode 1877
>>> Can't get file name for inode 1876, using '1876' as fallback
>>> Moving file '1876' to 'lost+found' dir since it has no valid backref
>>> Fixed the nlink of inode 1876
>>> Can't get file name for inode 1876, using '1876' as fallback
>>> Moving file '1876.1876' to 'lost+found' dir since it has no valid backref
>>> Fixed the nlink of inode 1876
>>> (snip)
>>> Moving file
>>> '1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876'
>>> to 'lost+found' dir since it has no valid backref
>>> Fixed the nlink of inode 1876
>>> Can't get file name for inode 1876, using '1876' as fallback
>>> Can't get file name for inode 1876, using '1876' as fallback
>>> Can't get file name for inode 1876, using '1876' as fallback
>>> -----
>>>
>>> The problem is early release of inode backrefs. The release prevents
>>> `reset_nlink()' to add back valid backrefs to an inode. In the result,
>>> the following results occur:
>>>
>>> 0. btrfsck scan a FS tree
>>> 1. It finds valid links and invalid links (some links are lost)
>>> 2. All valid links are released
>>> 3. btrfsck detects found_links != nlink
>>> 4. reset_nlink() reset nlink to 0
>>> 5. No valid links are restored (thus still nlink = 0)
>>> 6. The file is restored to lost+found since nlink == 0 (now, nlink = 1)
>>> 7. btrfsck rescan the FS tree
>>> 8. It finds `found_links' = #valid_links+1 (in lost+found) and nlink = 1
>>> 9. again all valid links are lost, and restore to lost+found
>>
>>
>> Right, that's one case I missed in the repair code.
>>
>> Thanks for the fix.
>
> Thanks for the review.
>
>>
>>>
>>> The first patch add clean up code to the test. It umount test
>>> directory on failure path. The second patch fix the above problem. And
>>> the last patch extend the test to check a case of multiple-linked file
>>> corruption.
>>
>>
>> But I only see the first 2 patches in maillist...
>> The last test case seems missing?
>
> Maybe, the last patch is too large to post to the list? Even it get
> smaller, 130260 bytes seems to be a bit large.
>
> How should I handle this? Put my repo somewhere and wait a maintainer
> to pull it?

One idea is to use btrfs-image to dump the image (if it is still able to 
trigger the bug).
Btrfs-image dump is much more efficient than raw dump.

Or as you mentioned, put the repo somewhere like github, and send pull 
request to David, mentioning the patch is already sent to maillist.

Thanks,
Qu

>
>>
>> Thanks,
>> Qu
>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


