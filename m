From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [3.0-rc1] kernel BUG at fs/btrfs/relocation.c:4285!
Date: Tue, 31 May 2011 13:31:47 +0900
Message-ID: <4DE46F33.6040706@jp.fujitsu.com>
References: <4DE43607.2090105@jp.fujitsu.com> <1306804322-sup-3529@shiny>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030909080302040807000102"
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306804322-sup-3529@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030909080302040807000102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(2011/05/31 10:13), Chris Mason wrote:
> Excerpts from Tsutomu Itoh's message of 2011-05-30 20:27:51 -0400:
>> The panic occurred when 'btrfs fi bal /test5' was executed.
>>
>> /test5 is as follows:
>> # mount -o space_cache,compress=lzo /dev/sdc3 /test5
>> #
>> # btrfs fi sh /dev/sdc3
>> Label: none  uuid: 38ec48b2-a64b-4225-8cc6-5eb08024dc64
>>         Total devices 5 FS bytes used 7.87MB
>>         devid    1 size 10.00GB used 2.02GB path /dev/sdc3
>>         devid    2 size 15.01GB used 3.00GB path /dev/sdc5
>>         devid    3 size 15.01GB used 3.00GB path /dev/sdc6
>>         devid    4 size 20.01GB used 2.01GB path /dev/sdc7
>>         devid    5 size 10.00GB used 2.01GB path /dev/sdc8
>>
>> Btrfs v0.19-50-ge6bd18d
>> # btrfs fi df /test5
>> Data, RAID0: total=10.00GB, used=3.52MB
>> Data: total=8.00MB, used=1.60MB
>> System, RAID1: total=8.00MB, used=4.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID1: total=1.00GB, used=216.00KB
>> Metadata: total=8.00MB, used=0.00
> 
> The oops is happening as we write inode cache during a commit during thekk
> balance.  I did run a number of balances on the inode cache code, do you
> have a test script that sets up the filesystem to recreate this?

Yes, I have.
In my test, the panic is done at frequency once every about ten times.

I attached the test script to this mail. (though it is a dirty test script
that scrapes up script...)

Thanks,
Tsutomu


> 
> -chris
> 

--------------030909080302040807000102
Content-Type: application/gzip;
 name="RT.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="RT.tar.gz"

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
8D+kMGLgAHgAAA==
--------------030909080302040807000102--

