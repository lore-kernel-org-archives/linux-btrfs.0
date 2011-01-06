From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Synching a Backup Server
Date: Thu, 06 Jan 2011 21:53:12 +0000
Message-ID: <4D2639C8.3080706@bobich.net>
References: <201101060935.14059.CACook@quantum-sci.com>	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>	<AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com> <201101061344.55407.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061344.55407.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2011 09:44 PM, Carl Cook wrote:
> On Thu 06 January 2011 12:07:17 C Anthony Risinger wrote:
>> as for the DB stuff, you definitely need to snapshot _before_ rsync.  roughly:
>>
>> ) read lock and flush tables
>> ) snapshot
>> ) unlock tables
>> ) mount snapshot
>> ) rsync from snapshot
>>
>> ie. the same as whats needed for LVM:
>>
>> http://blog.dbadojo.com/2007/09/mysql-backups-using-lvm-snapshots.html
>>
>> to get the DB file on disk consistent prior to archiving.
>
> I'm a little alarmed by this.  Running a mysql server for MythTV database.   Do these operations need to somehow be done before rsync?  Or Else?
>
> I don't understand what you're saying.

If you take a snapshot and back that up, the consistency of the data 
will be the same as you would expect it to be if you just yanked the 
power plug on the machine. Some databases tolerate this better than 
others, depending on how you have them configured. The date will be 
recoverable, but you will likely use no more than the transactions that 
were in-flight when it happend.

If you just rsync the data without taking a snapshot first, the data in 
your backup will likely be completely hosed and unusable unless you're 
lucky and the machine was idle at the time.

Gordan
