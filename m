From: Atila <atila.alr@dpf.gov.br>
Subject: Re: Can btrfs silently repair read-error in raid1
Date: Wed, 09 May 2012 08:08:20 -0300
Message-ID: <4FAA5024.5000103@dpf.gov.br>
References: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com> <CAG1y0seZD1n5sckdFx=BAJa+KQguKd-Dj9_Ti1EhJRY0bE2B9Q@mail.gmail.com> <CAE5mzvg8HgZPgFmNB3ZeuJTfLtrfeXH417bEVuHFST5z=zOMFw@mail.gmail.com> <2557067.fSI13aCqDU@bursa22>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2557067.fSI13aCqDU@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>

On 08-05-2012 18:47, Hubert Kario wrote:
> On Tuesday 08 of May 2012 04:45:51 cwillu wrote:
>> On Tue, May 8, 2012 at 1:36 AM, Fajar A. Nugraha<list@fajar.net>  wrote:
>>> On Tue, May 8, 2012 at 2:13 PM, Clemens Eisserer<linuxhippy@gmail.com>
> wrote:
>>>> Hi,
>>>>
>>>> I have a quite unreliable SSD here which develops some bad blocks from
>>>> time to time which result in read-errors.
>>>> Once the block is written to again, its remapped internally and
>>>> everything is fine again for that block.
>>>>
>>>> Would it be possible to create 2 btrfs partitions on that drive and
>>>> use it in RAID1 - with btrfs silently repairing read-errors when they
>>>> occur?
>>>> Would it require special settings, to not fallback to read-only mode
>>>> when a read-error occurs?
>>> The problem would be how the SSD (and linux) behaves when it
>>> encounters bad blocks (not bad disks, which is easier).
>>>
>>> If it does "oh, I can't read this block. I just return an error
>>> immediately", then it's good.
>>>
>>> However, in most situation, it would be like "hmmm, I can't read this
>>> block, let me retry that again. What? still error? then lets retry it
>>> again, and again.", which could take several minutes for a single bad
>>> block. And during that time linux (the kernel) would do something like
>>> "hey, the disk is not responding. Why don't we try some stuff? Let's
>>> try resetting the link. If it doesn't work, try downgrading the link
>>> speed".
>>>
>>> In short, if you KNOW the SSD is already showing signs of bad blocks,
>>> better just throw it away.
>> The excessive number of retries (basically, the kernel repeating the
>> work the drive already attempted) is being addressed in the block
>> layer.
>>
>> "[PATCH] libata-eh don't waste time retrying media errors (v3)", I
>> believe this is queued for 3.5
> I just hope they don't remove retries completely, I've seen the second or
> third try return correct data on multiple disks from different vendors.
> (Which allowed me to use dd to write the data back to force relocation)
>
> But yes, Linux is a bit too overzelous with regards to retries...
>
> Regards,
I hope they do. If you wish, you can force the retry, just trying your 
command again. This decision should happen in a higher level.
