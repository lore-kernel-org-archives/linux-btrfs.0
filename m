Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36219 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbdIVLiX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 07:38:23 -0400
Received: by mail-it0-f67.google.com with SMTP id e134so590415ite.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 04:38:23 -0700 (PDT)
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
Date: Fri, 22 Sep 2017 07:38:15 -0400
MIME-Version: 1.0
In-Reply-To: <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-22 06:39, Qu Wenruo wrote:
> As I already stated in an other thread, if you want to shrink, do it in another command line tool.
> Do one thing and do it simple. (Although Btrfs itself is already out of the UNIX way)
Unless I'm reading the code wrong, the shrinking isn't happening in a 
second pass, so this _is_ doing one thing, and it appears to be doing it 
as simply as possible (although arguably not correctly because of the 
1MB reserved area being used).
> 
> It may be offline shrink/balance. But not to further complexing the --rootdir option now. >
> And you also said that, the shrink feature is not a popular feature *NOW*, then I don't think it's worthy to implment it *NOW* either.
> Implement future feature in the future please.
I'm not sure about you, but I could have sworn that he meant seed 
devices weren't a popular feature right now, not that the shrinking is. 
As a general rule, the whole option of pre-loading a filesystem with 
data as you're creating it is not a popular feature, because most 
sysadmins are much more willing to trust adding data after the 
filesystem is created.

Personally, given the existence of seed devices, I would absolutely 
expect there to be a quick and easy way to generate a minimalistic image 
using a single command (because realistic usage of seed devices implies 
minimalistic images).  I agree that it shouldn't be the default 
behavior, but I don't think it needs to be removed completely.  The main 
issues here are that it wasn't documented well (like many other things 
in BTRFS), and it didn't generate a filesystem that was properly 
compliant with the on-disk format (because it used space in the 1MB 
reserved area at the beginning of the FS).  Fixing those issues in no 
way requires removing the feature.
> 
> And further more, even following the existing shrink behavior, you still need to truncate the file all by yourself.
> Which is no better than creating a good sized file and then mkfs on it.
Only if you pre-create the file.  If the file doesn't exist, it gets 
created at the appropriate size.  That's part of why the chunk 
allocations are screwed up and stuff gets put in the first 1MB, it 
generates the FS on-the-fly and writes it out as it's generating it.
> 
> Thanks,
> Qu
> 
> Sent: Friday, September 22, 2017 at 5:24 PM
> From: "Anand Jain" <anand.jain@oracle.com>
> To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
> Cc: dsterba@suse.cz
> Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for rootdir option
> 
>> +WARNING: Before v4.14 btrfs-progs, *--rootdir* will shrink the filesystem,
>> +prevent user to make use of the remaining space.
>> +In v4.14 btrfs-progs, this behavior is changed, and will not shrink the fs.
>> +The result should be the same as `mkfs`, `mount` and then `cp -r`. +
> 
> Hmm well. Shrink to fit exactly to the size of the given
> files-and-directory is indeed a nice feature. Which would help to create
> a golden-image btrfs seed device. Its not popular as of now, but at some
> point it may in the cloud environment.
> 
> Replacing this feature instead of creating a new option is not a good
> idea indeed. I missed something ?
> 
> Thanks, Anand
> 
>> +Also, if destination file/block device does not exist, *--rootdir* will not
>> +create the image file, to make it follow the normal mkfs behavior.

