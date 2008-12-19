From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: weird bash autocomplete issue
Date: Fri, 19 Dec 2008 02:27:32 +0100
Message-ID: <ac3eb2510812181727y29d44961q45eef3d34426aafa@mail.gmail.com>
References: <548462911@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Chris Mason" <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <548462911@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2008 at 01:59,  <devzero@web.de> wrote:
>> I see the same issue on x86 32 bit, with the additional __llseek()
>> between the getdents64(), and the last entry returned by readdir
>> ignored.
>
> confirmed - it`s readdir which assumes 32bit.
>
> attached is a sample program which shows the issue on my system.
>
> if compiled with -D_FILE_OFFSET_BITS=64", the problem goes away.
>
> old posting from around 2001:
>
>>http://sourceware.org/ml/libc-alpha/2001-01/msg00216.html
>>
>>This is why everybody will have to compile programs with
>>_FILE_OFFSET_BITS=64.  Did you ever notice that all GNU programs
>>already do this?
>
> as 32bit systems can use 64bit filesystems, i think btrfs is correct and bash is wrong,
> as it isn`t LFS aware. i think all 32bit stuff should be LFS aware, nowadays.
>
> to be exact, it`s not bash but readline library which comes with bash.
> bash configure script correctly checks for _FILE_OFFSET_BITS value, but readline configure script doesn`t.
> this explains why i could not reproduce the issue when i build bash without readline support.
>
> does it make sense to file a ticket at novell bugzilla ?

Sure, would be good to have that fixed. Cc: kasievers@novell.com in
the bug, and I will move it directly to the right guy. :)

Thanks,
Kay
