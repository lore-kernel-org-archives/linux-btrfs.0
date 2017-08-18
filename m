Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55331 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750739AbdHRHMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 03:12:42 -0400
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: kreijack@inwind.it
Cc: Chris Murphy <lists@colorremedies.com>,
        Piotr Szymaniak <szarpaj@grubelek.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170814225740.GK19638@pontus.sran>
 <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
 <CAJCQCtTU9EGhjeug-AzS0TDfySwTQi=dPrFLRDE1Go71E7+W+g@mail.gmail.com>
 <9d24b092-6b03-8d97-b4bd-feb36e00b9e0@inwind.it>
 <e965d461-7185-59ef-d025-d51a886aacb7@suse.com>
 <6b16fa81-a1a5-3243-0f7d-59a7ec9ae168@inwind.it>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <496d27de-43c8-4508-a664-71083d90ae1b@suse.com>
Date: Fri, 18 Aug 2017 10:12:39 +0300
MIME-Version: 1.0
In-Reply-To: <6b16fa81-a1a5-3243-0f7d-59a7ec9ae168@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.08.2017 10:09, Goffredo Baroncelli wrote:
> On 08/18/2017 08:34 AM, Nikolay Borisov wrote:
>>
>>
>> On 17.08.2017 23:59, Goffredo Baroncelli wrote:
>>> Hi,
>>>
>>> On 08/17/2017 08:43 PM, Chris Murphy wrote:
>>>> # btrfs sub create test1
>>>> Create subvolume './test1'
>>>> # btrfs sub create test1/test2
>>>> Create subvolume 'test1/test2'
>>>> # btrfs sub snap test1 test1.snap
>>>> Create a snapshot of 'test1' in './test1.snap'
>>>> # btrfs fi du -s test1
>>>>      Total   Exclusive  Set shared  Filename
>>>>      0.00B       0.00B       0.00B  test1
>>>> # btrfs fi du -s test1.snap
>>>>      Total   Exclusive  Set shared  Filename
>>>> ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device
>>>> #
>>>>
>>>
>>> tanks for the test case. Now I was able to reproduce the problem. The bug(s) are two:
>>>
>>> 1) to get the treeid of the files/directory, the function lookup_path_rootid() is used, which behaves strangely when it is called on a directory that is BTRFS_EMPTY_SUBVOL_DIR_OBJECTID. In fact this function is commented as following:
>>> [....]
>>> /*
>>>  * For a given:
>>>  * - file or directory return the containing tree root id
>>>  * - subvolume return its own tree id
>>>  * - BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (directory with ino == 2) the result is
>>>  *   undefined and function returns -1
>>>  */
>>> int lookup_path_rootid(int fd, u64 *rootid)
>>> {
>>> [....]
>>>
>>> The caller (du_add_file()) doesn't consider this case.
>>>
>>> 2) in the function du_walk_dir(), an error returned by du_add_file() is ignored, but the return value is not reset. So if the last entry has ino BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (directory with ino == 2) an error is returned. But if there is another directory item no error is returned !
>>>
>>> See the following tests cases:
>>>
>>> # btrfs sub create test1
>>> # btrfs sub create test1/test2
>>> # btrfs sub snap test1 test1.snap
>>> # btrfs fi du -s test1
>>>      Total   Exclusive  Set shared  Filename
>>>      0.00B       0.00B       0.00B  test1
>>> # btrfs fi du -s test1.snap
>>>      Total   Exclusive  Set shared  Filename
>>> ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device
>>>
>>> But if you add *another* file/dir in test1.snap you got:
>>>
>>> # mkdir test1.snap/dir
>>> # btrfs fi du -s test1.snap
>>>      Total   Exclusive  Set shared  Filename
>>>      0.00B       0.00B       0.00B  test1.snap
>>>
>>> The error disappea> Patches will follow shortly
>>
>> It would be awesome if you manage to introduce xfstests for this case
> 
> I am not sure if this is the right thing to do: the bugs are related to 
> a) an incorrect error handling of the function lookup_path_rootid()
> b) the strange behavior of the BTRFS_EMPTY_SUBVOL_DIR_OBJECTID directory
> 
> For a) it is impossible to check for each lookup_path_rootid() call from a xfstest; for b) I am quite sure that there are a lot of corner case not properly handled in btrfs progs (and still btrfs fi-du handle it wrongly)

So the bug is actually in the btrfsprogs not in the fs, am I correct?

> 
> BR
> G.Baroncelli
> 
>>
>>>
>>>>
>>>> # uname -r
>>>> 4.13.0-0.rc4.git1.1.fc27.x86_64
>>>> # rpm -q btrfs-progs
>>>> btrfs-progs-4.12-1.fc27.x86_64
>>>>
>>>>
>>>> ----
>>>> Chris Murphy
>>>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
