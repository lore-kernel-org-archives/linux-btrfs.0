Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65489 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752128AbdIVMdB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 08:33:01 -0400
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
Date: Fri, 22 Sep 2017 20:32:37 +0800
MIME-Version: 1.0
In-Reply-To: <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月22日 19:38, Austin S. Hemmelgarn wrote:
> On 2017-09-22 06:39, Qu Wenruo wrote:
>> As I already stated in an other thread, if you want to shrink, do it 
>> in another command line tool.
>> Do one thing and do it simple. (Although Btrfs itself is already out 
>> of the UNIX way)
> Unless I'm reading the code wrong, the shrinking isn't happening in a 
> second pass, so this _is_ doing one thing, and it appears to be doing it 
> as simply as possible (although arguably not correctly because of the 
> 1MB reserved area being used).

If you're referring to my V1 implementation of shrink, that's doing 
*one* thing.

But the original shrinking code? Nope, or we won't have the custom chunk 
allocator at all.


What I really mean is, if one wants to shrink, at least don't couple the 
shrink code into "mkfs.btrfs".

Do shrink in its own tool/subcommand, not in a really unrelated tool.

>>
>> It may be offline shrink/balance. But not to further complexing the 
>> --rootdir option now. >
>> And you also said that, the shrink feature is not a popular feature 
>> *NOW*, then I don't think it's worthy to implment it *NOW* either.
>> Implement future feature in the future please.
> I'm not sure about you, but I could have sworn that he meant seed 
> devices weren't a popular feature right now,

Oh, sorry for my misunderstanding.

> not that the shrinking is. 
> As a general rule, the whole option of pre-loading a filesystem with 
> data as you're creating it is not a popular feature, because most 
> sysadmins are much more willing to trust adding data after the 
> filesystem is created.
> 
> Personally, given the existence of seed devices, I would absolutely 
> expect there to be a quick and easy way to generate a minimalistic image 
> using a single command (because realistic usage of seed devices implies 
> minimalistic images).  I agree that it shouldn't be the default 
> behavior, but I don't think it needs to be removed completely.

Just like I said in cover letter, even for ext*, it's provided by 
genext2fs, not mke2fs.

I totally understand end-user really want a do-it-all solution.
But from developers' view, the old UNIX way is better to maintain code 
clean and easy to read.


In fact, you can even create your script to do the old behavior if you 
don't care that the result may not fully take use of the space, just by:

1) Calculate the size of the whole directory
    "du" command can do it easily, and it does things better than us! For
    years!

2) Multiple the value according to the meta/data profile
    Take care of small files, which will be inlined.
    And don't forget size for data checksum.
    (BTW, there is no way to change the behavor of inlined data and data
     checksum for mkfs. unlike btrfs-convert)


3) Create a file with size calculated by step 2)

4) Execute "mkfs.btrfs -d <dir> <created file>"

>  The main 
> issues here are that it wasn't documented well (like many other things 
> in BTRFS), and it didn't generate a filesystem that was properly 
> compliant with the on-disk format (because it used space in the 1MB 
> reserved area at the beginning of the FS).  Fixing those issues in no 
> way requires removing the feature.

Yes, 1MB can be fixed easily (although not properly). But the whole 
customized chunk allocator is the real problem.
The almost dead code is always bug-prone. Replace it with updated 
generic chunk allocator is the way to avoid later whac-a-mole, and 
should be done asap.

>>
>> And further more, even following the existing shrink behavior, you 
>> still need to truncate the file all by yourself.
>> Which is no better than creating a good sized file and then mkfs on it.
> Only if you pre-create the file.  If the file doesn't exist, it gets 
> created at the appropriate size.  That's part of why the chunk 
> allocations are screwed up and stuff gets put in the first 1MB, it 
> generates the FS on-the-fly and writes it out as it's generating it.

Nope, even you created the file in advance, it will still occupy the 
first 1M.

BTW, you can get back the size calculation for shrink, but you will soon 
find that it's just the start of a new nightmare.
Because there is no easy way to calculate the real metadata usage.

The result (and the old calculator) will be no better than guessing it.
(Well, just multiply the dir size by 2 will never go wrong)


Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>> Sent: Friday, September 22, 2017 at 5:24 PM
>> From: "Anand Jain" <anand.jain@oracle.com>
>> To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
>> Cc: dsterba@suse.cz
>> Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra 
>> condition for rootdir option
>>
>>> +WARNING: Before v4.14 btrfs-progs, *--rootdir* will shrink the 
>>> filesystem,
>>> +prevent user to make use of the remaining space.
>>> +In v4.14 btrfs-progs, this behavior is changed, and will not shrink 
>>> the fs.
>>> +The result should be the same as `mkfs`, `mount` and then `cp -r`. +
>>
>> Hmm well. Shrink to fit exactly to the size of the given
>> files-and-directory is indeed a nice feature. Which would help to create
>> a golden-image btrfs seed device. Its not popular as of now, but at some
>> point it may in the cloud environment.
>>
>> Replacing this feature instead of creating a new option is not a good
>> idea indeed. I missed something ?
>>
>> Thanks, Anand
>>
>>> +Also, if destination file/block device does not exist, *--rootdir* 
>>> will not
>>> +create the image file, to make it follow the normal mkfs behavior.
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
