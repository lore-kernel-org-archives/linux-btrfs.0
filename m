From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: Kernel error during btrfs balance
Date: Mon, 17 Jan 2011 15:37:51 +0100
Message-ID: <4D34543F.3050100@logtenberg.eu>
References: <4D344EBB.6030903@logtenberg.eu> <4D3452C9.901@logtenberg.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3452C9.901@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Additionally, I cannot mount the filesystem anymore. mount gives no
error messages but hangs in state D.
dmesg shows:
[  422.323116] btrfs: use compression
Which is a good thing, but it doesn't do anything otherwise.

Thanks,

Erik.


On 01/17/2011 03:31 PM, Erik Logtenberg wrote:
> Hi,
> 
> Please find attached the error log, for future reference.
> 
> Forgot to mention:
> I could still use the system after this error, so it was not a complete
> fatal error in that regard. All active processes (mostly rsync) were
> hanging in state D though, so I couldn't kill them anymore. Also the FS
> was not umountable. So I still had to reboot.
> 
> Thanks,
> 
> Erik.
> 
> 
> On 01/17/2011 03:14 PM, Erik Logtenberg wrote:
>> Hi,
>>
>> btrfs balance results in:
>>
>> http://pastebin.com/v5j0809M
>>
>> My system: fully up-to-date Fedora 14 with rawhide kernel to make btrfs
>> balance do useful stuff to my free space:
>>
>> kernel-2.6.37-2.fc15.x86_64
>> btrfs-progs-0.19-12.fc14.x86_64
>>
>> Filesystem had 0 bytes free, should be 45G, so on darklings advice I ran
>> btrfs balance on the fs, while doing heavy I/O (re-running 5 backup jobs
>> that had failed due to ENOSP).
>> Up until the crash, btrfs balance did retrieve a couple of Gigs free
>> space though, so that part of the plan worked just fine.
>>
>> Thanks,
>>
>> Erik.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

