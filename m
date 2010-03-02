From: jim owens <owens6336@gmail.com>
Subject: Re: BackupPC, per-dir hard link limit, Debian packaging
Date: Tue, 02 Mar 2010 18:22:31 -0500
Message-ID: <4B8D9DB7.7090207@gmail.com>
References: <1267496945.9222.155.camel@lifeless-64> <201003021409.22441.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org,
	Robert Collins <robertc@robertcollins.net>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003021409.22441.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Hubert Kario wrote:
> On Tuesday 02 March 2010 03:29:05 Robert Collins wrote:
>> As I say, I realise this is queued to get addressed anyway, but it seems
>> like a realistic thing for people to do (use BackupPC on btrfs) - even
>> if something better still can be written to replace the BackupPC store
>> in the future. I will note though, that simple snapshots won't achieve
>> the deduplication level that BackupPC does, because the fils don't start
>> out as the same: they are identified as being identical post-backup.
> 
> Isn't the main idea behind deduplication to merge identical parts of files 
> together using cow? This way you could have many very similar images of 
> virtual machines, run the deduplication process and reduce massively the space 
> used while maintaining the differences between images.
> 
> If memory serves me right, the plan is to do it in userland on a post-fact 
> filesystem, not when the data is being saved. If such a daemon or program was 
> available you would run it on the system after rsyncing the workstations.
> 
> Though the question remains which system would reduce space usage more in your 
> use case. From my experience, hardlinks take less space on disk, I don't know 
> whatever it could be possible to optimise btrfs cow system for files that are 
> exactly the same.

Space use is not the key difference between these methods.
The btrfs COW makes data sharing safe.  The hard link method
means changing a file invalidates the content of all linked files.

So a BackupPC output should be read-only.

jim
