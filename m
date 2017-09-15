Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50452 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbdIONYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 09:24:38 -0400
Subject: Re: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: dsterba@suse.cz, kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
 <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
 <20170912170304.GD29043@twin.jikos.cz>
 <0a949fd9-f0cf-22c5-4e91-ebb1bfad1355@libero.it>
 <20170912180753.GI29043@suse.cz>
 <0c906ea3-bfdb-a088-f940-4b63a3da8d2f@gmx.com>
 <20170915125605.GY29043@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9d514995-7706-0157-6b98-93632fe3dce7@gmx.com>
Date: Fri, 15 Sep 2017 21:24:19 +0800
MIME-Version: 1.0
In-Reply-To: <20170915125605.GY29043@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月15日 20:56, David Sterba wrote:
> On Wed, Sep 13, 2017 at 08:32:50AM +0800, Qu Wenruo wrote:
>> On 2017年09月13日 02:07, David Sterba wrote:
>>> On Tue, Sep 12, 2017 at 07:50:19PM +0200, Goffredo Baroncelli wrote:
>>>> On 09/12/2017 07:03 PM, David Sterba wrote:
>>>>> Say I want to prepare a minimal image but will provide a large file
>>>>                                                   ^^^^^^^^^^^^^^^^^^^^^^
>>>>
>>>> I think that if the target is a file AND --minimize is passed, it is a
>>>> reasonable expectation that the file is created "on the fly" and grown
>>>> up to what needed.
>>>>
>>>> What I mean is that "--minimize" is passed (and a file is passed), mkfs.btrfs should
>>>> a) create the file if it doesn't exist, and avoid any check about its length
>>>> b) truncate the file at the end
>>>
>>> I think the farthest-offset write will extend the file size, so we
>>> should not truncate it, in the sense 'make it smaller than it is', but
>>> rather 'align it to the size where the filesystem expects live data".
>>
>> Unfortunately, that's not the case.
>>
>> Current implementation must determine its size at the very beginning.
>>
>> That's to say, if mkfs determines that it's going to use 1G size, then
>> current btrfs-progs will be guaranteed that no write over 1G boundary.
>> (Unless there is some hidden bug)
>>
>> So if we are realling going to implement "--minimize" option, we are
>> doing asymmetric behavior:
>>
>> 1) For fs smaller than file
>>      Good, we truncate it
>>
>> 2) For fs larger than file
>>      Bad, we will get ENOSPC error.
>>
>> One workaround I mentioned in V1 is to make a large enough sparse file
>> first and then truncate it.
>>
>> But such workaround has some problem, especially related to the chunk
>> allocator.
>>
>> For a 1G sparse file as example, we will have about 100M data chunk.
>> While for 128M space file, we will have about 10M data chunk.
>> That will cause a lot of space wasted if using large spare file and then
>> truncating it than using a small existing file.
>>
>> Considering the all the variables involved, I choose the KISS method.
>> Let user to handle it, and mkfs.btrfs --rootdir will just do the copy work.
>>
>> If user really wants to do a minimal image, the best (AFAIK the only
>> correct) method is to implement btrfs-progs balance (offline balanace)
>> to compact all these meta and data, then truncate it (offline resize).
>>
>> The initial --rootdir is doing too many things at the same time in mkfs.
>> And that's why I want to make it simple.
>>
>> BTW, just as I stated in cover letter, "mkfs.ext4" -d is doing it easy
>> as what I did here, and the complex work is handled by out of e2fsprogs
>> utility, genext2fs.
>>
>>
>>
>> And there may be some use case relying on this truncation, but hey, if
>> the need is really high, there should already be a lot of complains
>> about --rootdir shrinking fs, and more tested/documented --rootdir
>> implementation.
>>
>> So it's not really worth it to implement a complex code base to handle
>> something while there is not much user base.
> 
> I think all points have been covered, thanks.
> 
> The backward compatibility does not seem to be broken, the difference
> between old and new --rootdir is only the size of the resulting
> filesystem, otherwise the file size is left untouched and sufficient
> size is required.
> 
> Minimizing can come as a separate step, either using off-line balance,
> or possibly also as an option to mkfs.

Glad to hear that.

> 
> I'm going to review & merge this series to devel. Tests and
> documentation should be updated to make the usecase clear.

I'm happy to address any comment, both code and doc/test.

Thanks,
Qu
