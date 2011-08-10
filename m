From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: No space left, with 80 GB space free
Date: Wed, 10 Aug 2011 12:38:31 +0200
Message-ID: <4E425FA7.7030201@wpkg.org>
References: <4DD16817.9020302@wpkg.org> <4DD6985E.8040100@wpkg.org> <BANLkTimA_dJDNUqPUssV5ZbLTr=T7k+doA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Just a follow up - I'm able to reproduce the issue with 3.0.1 kernel, with plain rsync.
I'm trying to write a ~ 4 GB file to btrfs.

"Fast" writes will make btrfs output "No space left on device".
On the other hand, if I write slowly, btrfs will be happy and write the whole file.


cp ("full speed copy") fails after a few seconds, so let's try to write with ~5 MB/s - still fails:

# rsync -a -v --progress --bwlimit=5000 . /mnt/btrfs/temp
sending incremental file list
./
randomfile
   645136384  13%    4.87MB/s    0:13:32  
rsync: writefd_unbuffered failed to write 4 bytes to socket [sender]: Broken pipe (32)
rsync: write failed on "/mnt/btrfs/temp/randomfile": No space left on device (28)
rsync error: error in file IO (code 11) at receiver.c(302) [receiver=3.0.7]
rsync: connection unexpectedly closed (31 bytes received so far) [sender]
rsync error: error in rsync protocol data stream (code 12) at io.c(601) [sender=3.0.7]


Let's write with ~1 MB/s then - succeeds:

# rsync -a -v --progress --bwlimit=1000 . /mnt/btrfs/temp
sending incremental file list
./
randomfile
  4693411469 100%  988.30kB/s    1:17:17 (xfer#1, to-check=6/8)
(...)
sent 4758749321 bytes  received 112 bytes  1012176.84 bytes/sec
total size is 4758167972  speedup is 1.00


I don't think it's expected?


I see these in dmesg while copying the files:

[ 1703.978600] btrfs: free space inode generation (0) did not match free space cache generation (22496)
[ 1703.978605] btrfs: failed to load free space cache for block group 92371156992
[ 1704.026476] btrfs: free space inode generation (0) did not match free space cache generation (22502)
[ 1704.026481] btrfs: failed to load free space cache for block group 114919735296
[ 1704.035239] btrfs: free space inode generation (0) did not match free space cache generation (22503)
[ 1704.035243] btrfs: failed to load free space cache for block group 118140960768
[ 1704.035252] btrfs: free space inode generation (0) did not match free space cache generation (22481)
[ 1704.035255] btrfs: failed to load free space cache for block group 119214702592
[ 1704.294757] btrfs: free space inode generation (0) did not match free space cache generation (22503)
[ 1704.294761] btrfs: failed to load free space cache for block group 243231883264


-- 
Tomasz Chmielewski
http://wpkg.org
