From: Heinz-Josef Claes <hjclaes@web.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 04 May 2009 21:11:09 +0200
Message-ID: <49FF3DCD.40306@web.de>
References: <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com> <20090504162650.GD13777@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090504162650.GD13777@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Glanzmann schrieb:
> Ric,
>
>   
>> I would not categorize it as offline, but just not as inband (i.e., you can 
>> run a low priority background process to handle dedup).
>>     
>
>   
>> Offline windows are extremely rare in production sites these days and
>> it could take a very long time to do dedup at the block level over a
>> large file system :-)
>>     
>
> let me rephrase, by offline I meant asynchronous during off hours.
>
>   
Hi, during the last half year I thought a little bit about doing dedup 
for my backup program: not only with fixed blocks (which is 
implemented), but with moving blocks (with all offsets in a file: 1 
byte, 2 byte, ...). That means, I have to have *lots* of comparisions 
(size of file - blocksize). Even it's not the same, it must be very fast 
and that's the same problem like the one discussed here.

My solution (not yet implemented) is as follows (hopefully I remember well):

I calculate a checksum of 24 bit. (there can be another size)

This means, I can have 2^24 different checksums.

Therefore, I hold a bit verctor of 0,5 GB in memory (I hope I remember 
well, I'm just in a hotel and have no calculator): one bit for each 
possibility. This verctor is initialized with zeros.

For each calculated checksum of a block, I set the according bit in the 
bit vector.

It's very fast, to check if a block with a special checksum exists in 
the filesystem (backup for me) by checking the appropriate bit in the 
bit vector.

If it doesn't exist, it's a new block

If it exists, there need to be a separate 'real' check if it's really 
the same block (which is slow, but's that's happening <<1% of the time).

I hope it is possible to understand my thoughts. I'm in a hotel and I 
possibly cannot track the emails in this list in the next hours or days.

Regards, HJC
>> 1/3 is not sufficient for dedup in my opinion - you can get that with 
>> normal compression at the block level.
>>     
>
> 1/3 is what gives me real time data of an production environment in a
> mixed VM setup without compression.
>
>         Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

