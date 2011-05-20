From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: No space left, with 80 GB space free
Date: Sat, 21 May 2011 01:49:10 +0200
Message-ID: <4DD6FDF6.1020209@wpkg.org>
References: <4DD16817.9020302@wpkg.org>	<4DD6985E.8040100@wpkg.org> <BANLkTimA_dJDNUqPUssV5ZbLTr=T7k+doA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Miguel Garrido <miguel@mjgar.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimA_dJDNUqPUssV5ZbLTr=T7k+doA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 21.05.2011 01:05, Miguel Garrido wrote:
> On Fri, May 20, 2011 at 12:35 PM, Tomasz Chmielewski<mangoo@wpkg.org>  wrote:
>>
>> Nobody has a clue what makes btrfs run out of space when used with PostgreSQL, even when there is plenty of free space left?
>>
>>
>> # df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sdb4             336G  257G   78G  77% /mnt/btrfs
>>
>>
>> coredb=# DELETE FROM core_trevent where "date"<  E'2011-05-07 00:00';
>> ERROR:  could not write block 1014999 of relation base/16384/16521: No space left on device
>> CONTEXT:  writing block 1014999 of relation base/16384/16521
>>
>
> Hi Tomasz,
>
> What does btrfs fi df /mountpoint show?

Used space is almost identical as with normal df.


> Please see this link:
> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

Doesn't apply in my case: kernel is 2.6.39, device is relatively large.

It is *probably* related to compression used (compress-force - disabled 
the option, and didn't see out of space since).

-- 
Tomasz Chmielewski
http://wpkg.org
