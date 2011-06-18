From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: No space left, with 80 GB space free
Date: Sat, 18 Jun 2011 20:52:25 +0200
Message-ID: <4DFCF3E9.1080508@wpkg.org>
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

Hmm, this "No space left on device" only shows up if I write to the 
btrfs filesystem relatively fast.

For example, this way, I can only write around 1 GB (~60 MB/s write):

# cp -v acer.img.xz /mnt/btrfs/
`ac.img.xz' -> `/mnt/btrfs/ac.img.xz'
cp: writing `/mnt/btrfs/ac.img.xz': No space left on device


This way, when the writes are CPU-bound, I'm able to fully fill the 
btrfs filesystem (~8 MB/s):

# dd if=/dev/urandom of=/mnt/btrfs/bigfile


Delayed allocation?

-- 
Tomasz Chmielewski
http://wpkg.org
