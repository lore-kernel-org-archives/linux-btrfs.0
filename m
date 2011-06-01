From: ajh mls <ajhmls@gmail.com>
Subject: Re: btrfs hang on brd
Date: Wed, 01 Jun 2011 13:30:30 +0300
Message-ID: <4DE614C6.4080909@gmail.com>
References: <4DE492B0.9020302@linux.intel.com> <20110601085439.GD12709@twin.jikos.cz> <4DE60F44.6090400@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE60F44.6090400@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/11 13:07, Adrian Hunter wrote:
> On 01/06/11 11:54, David Sterba wrote:
>> On Tue, May 31, 2011 at 10:03:12AM +0300, Adrian Hunter wrote:
>>> Hi
>>>
>>> I seem to be able to get btrfs reproducibly to
>>> produce warnings and finally hang when running
>>> a stress test on a ramdisk.
>>>
>>> Testing was done using the "integration-test"
>>> branch of btrfs-unstable. Note that I also tested
>>> v2.6.39 and "integration-test" took much longer to
>>> hang i.e. it is an improvement
>>>
>>> The test script and stack dumps are below.
>>>
>>> Is this a valid test?
>>>
>>> Is it worth me investigating these?
>>
>> I've tried to reproduce myself, but the fsstress utility (taken from
>> latest LTP suite) crashes sometimes and I cannot take it as a proper
>> reproduction. Can you point me to the exact version you used?
>
> The LTP version does not compile properly:
>
> make[4]: Entering directory
> `/home/ahunter/Desktop/Projects/ltp/ltp-full-20110228/testcases/kernel/fs/fsstress'
>
> gcc -g -O2 -g -O2 -fno-strict-aliasing -pipe -Wall -DNO_XFS
> -I/home/ahunter/Desktop/Projects/ltp/ltp-full-20110228/testcases/kernel/fs/fsstress
> -D_LARGEFILE64_SOURCE -D_GNU_SOURCE -Wno-error -I../../../../include
> -I../../../../include -L../../../../lib fsstress.c -o fsstress
> fsstress.c: In function 'dread_f':
> fsstress.c:1829:2: warning: implicit declaration of function 'memalign'
> fsstress.c:1829:6: warning: assignment makes pointer from integer
> without a cast
> fsstress.c: In function 'dwrite_f':
> fsstress.c:1912:6: warning: assignment makes pointer from integer
> without a cast
> fsstress.c:1844:17: warning: 'diob.d_miniosz' may be used uninitialized
> in this function
> fsstress.c:1844:17: warning: 'diob.d_maxiosz' may be used uninitialized
> in this function
> fsstress.c:1844:17: warning: 'diob.d_mem' may be used uninitialized in
> this function
> fsstress.c: In function 'dread_f':
> fsstress.c:1750:17: warning: 'diob.d_miniosz' may be used uninitialized
> in this function
> fsstress.c:1750:17: warning: 'diob.d_maxiosz' may be used uninitialized
> in this function
> fsstress.c:1750:17: warning: 'diob.d_mem' may be used uninitialized in
> this function
>
>
> I hacked a couple of changes but I need to check them before
> mailing to the ltp-list:
>

In fact there is already a fix here:

http://sourceforge.net/mailarchive/message.php?msg_id=27212868
