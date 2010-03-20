From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Content based storage
Date: Sat, 20 Mar 2010 18:44:24 -0400
Message-ID: <4BA54FC8.60806@redhat.com>
References: <hnnijd$jol$1@dough.gmane.org> <201003171625.50257.hka@qbs.com.pl>		 <23a15591003170833t3ec4dc3fq9630558aa190afc@mail.gmail.com>	 	<201003172043.17314.hka@qbs.com.pl> <2b0225fb1003191946k1cf92c63q18e40d41274ce3e8@mail.gmail.com> 	<4BA4C811.4060702@redhat.com> <-1949627963487010042@unknownmsgid> <4BA5492C.5030709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Boyd Waters <waters.boyd@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA5492C.5030709@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/20/2010 06:16 PM, Ric Wheeler wrote:
> On 03/20/2010 05:24 PM, Boyd Waters wrote:
>> On Mar 20, 2010, at 9:05 AM, Ric Wheeler<rwheeler@redhat.com>  wrote:
>>>>
>>>> My dataset reported a dedup factor of 1.28 for about 4TB, meaning
>>>> that
>>>> almost a third of the dataset was duplicated.
>>
>>> It is always interesting to compare this to the rate you would get
>>> with old fashioned compression to see how effective this is. Seems
>>> to be not that aggressive if I understand your results correctly.
>>>
>>> Any idea of how compressible your data set was?
>>
>> Well, of course if I used zip on the whole 4 TB that would deal with
>> my duplication issues, and give me a useless, static blob with no
>> checksumming. I haven't tried.
>
> gzip/bzip2 of the block device was not meant to give a best case 
> estimate of what traditional compression can do. Many block devices 
> (including some single spindle disks) can do encryption internally.

I meant to say was not meant to provide a useful compression just meant 
to measure how well block level encryption could do.

ric

>
>>
>> One thing that I did do, seven (!) years ago, was to detect duplicate
>> files (not blocks) and use hard links. I was able to squeeze out all
>> of the air in a series of backups, and was able to see all of them. I
>> used a Perl script for all this. It was nuts, but now I understand why
>> Apple implemented hard links to directories in HFS in order to get
>> thier Time Machine product.  I didn't have copy-on-write, so btrfs
>> snapshots completely spank a manual system like this, but I did get 7-
>> to-1 compression. These days you can use rsync with "--link-target" to
>> make hard-linked duplicates of large directory trees. Tar, cpio, and
>> friends tend to break when transferring hundreds of gigabytes with
>> thousands of hard links. Or they ignore the hard links.
>>
>> Good times. I'm not sure how this is germane to btrfs, except to point
>> out pathological file-system usage that I've actually attempted in
>> real life. I actually use a lot of the ZFS feature set, and I look
>> forward to btrfs stability. I think btrfs can get there.
>
> File level dedup is something we did in a group I worked with before 
> and can certainly be quite effective. Even better, it is much easier 
> to map into normal user expectations :-)
>
> ric
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

