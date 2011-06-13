From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: use the normal checksumming infrastructure for
 free space cache
Date: Mon, 13 Jun 2011 10:26:25 -0400
Message-ID: <4DF61E11.7070702@redhat.com>
References: <1307734827-10697-1-git-send-email-josef@redhat.com> <4DF56D60.4070208@cn.fujitsu.com> <1307929964-sup-6781@shiny> <4DF573FB.1080709@cn.fujitsu.com> <1307974249-sup-2733@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307974249-sup-2733@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/13/2011 10:11 AM, Chris Mason wrote:
> Excerpts from Li Zefan's message of 2011-06-12 22:20:43 -0400:
>> Chris Mason wrote:
>>> Excerpts from Li Zefan's message of 2011-06-12 21:52:32 -0400:
>>>> Josef Bacik wrote:
>>>>> We used to store the checksums of the space cache directly in the space cache,
>>>>> however that doesn't work out too well if we have more space than we can fit the
>>>>> checksums into the first page.  So instead use the normal checksumming
>>>>> infrastructure.  There were problems with doing this originally but those
>>>>> problems don't exist now so this works out fine.  Thanks,
>>>>>
>>>>
>>>> This looks great, so I'll drop my patch that extends the original code to
>>>> allow more than 1 crc page.
>>>
>>> I do like them a lot, but what happens when a special case crc kernel
>>> mounts a free space cache created by this patch?
>>>
>>
>> The generation number will be checked, and then we'll get this warning:
>>
>> "btrfs: space cache generation xx does not match inode yy"
>>
>> If xx happens to be equal to yy, crcs will be checked and this warning
>> will pop up:
>>
>> "btrfs: crc mismatch for page zz"
>>
>> but it won't crash (not tested).
> 
> Right, but that's a lot of trust to put into our small crcs.

Yeah we're trusting that the crc's or the generation won't match, which
really should be the case always.  Unfortunately there is no real way to
force the old kernels to flush the space cache with the new format, we
just have to assume that it will get the wrong checksum, which really it
should.  Course now that I've said this some user will hit that one in a
hundred trillion chance that the entries will end up having valid crc's
for the pages.  Thanks,

Josef
