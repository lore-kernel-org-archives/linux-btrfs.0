From: Travis Shivers <ttshivers@gmail.com>
Subject: Re: Btrfs Array Recovery
Date: Fri, 13 Apr 2012 09:53:30 -0500
Message-ID: <CAPeorG80zDduczmtqCkZvC=aJ3qJEmWME78Hj5F4mgbn_zbR8w@mail.gmail.com>
References: <CAPeorG9SqVbg=ciH++P5SjPAGp5t=-B7gnSYUQ80UFQ3HGK91Q@mail.gmail.com>
 <4F883002.6060900@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F883002.6060900@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Actually, I was running 3.0.0-16 when the power failure occurred. I
upgraded to 3.2.8 shortly after the corruption occurred to see if it
would fix the corruption. I really do not care about completely
repairing or being able to mount the filesystem since I would just
like to get my data off the array. I plan on completely rebuilding the
filesystem once I get my data back, which may eliminate some recovery
steps. I know that btrfs is not completely ready yet, and I understand
that it may be necessary to use it to fix my problem, but is there a
way to currently recover the data using the tools available using
something such as btrfs-restore? I am also willing to wait a little
while longer for btrfsck to be completed if it will be able to fix my
type of corruption when it is. I just do not want to wait for
something that will not fix my problem.

On Fri, Apr 13, 2012 at 8:54 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On 4/12/2012 11:25 PM, Travis Shivers wrote:
>> A few months ago, my btrfs storage array became corrupted because of=
 a
>> power failure. A while ago, I made this thread to try and resolve th=
e
>> problem. (http://www.digipedia.pl/usenet/thread/11904/15955/) You ca=
n
>> find detailed information about the problem in the previous thread,
>> but I am happy to provide any other details. It didn't really go
>> anywhere in the way of solving my problem. The thread ended in me
>> waiting for a patch that would allow me to mount my corrupted array
>> which was around 2 months ago.
>
> You were running 3.2.8, that shouldn't corrupt filesystems anymore on
> power failure. This is unexpected.
>
>>
>> While I have been waiting, I have tried several things. One of the
>> things that I tried was installing the latest Linux kernel (3.4 RC1)
>> with the btrfs integrity checking enabled. I read about this module
>> here: (http://lwn.net/Articles/466493/) With the option compiled in,=
 I
>> have had severe mounting problems. I can only try to mount the array
>> once before it does some strange things. The first time I try and
>> mount it, it fails, but logs this in dmesg:
>> (http://pastebin.com/YwAsdjhs) It looks like there is a bug in this
>> integrity checking code. After I try to mount the drive after the
>> first time, it just hangs and doesn't return anything or log anythin=
g
>> in dmesg. Even trying to mount the drive without the integrity
>> checking problem hangs and has the same problems.
>
> [ =A0 43.809870] parent transid verify failed on 5568194412544 wanted
> 43477 found 43151
> [ =A0 43.809875] failed mirror was 0
> [ =A0 43.826531] ------------[ cut here ]------------
> [ =A0 43.826573] kernel BUG at fs/btrfs/extent_io.c:1890!
>
> This is not related to the integrity check code.
>
> The same issue is reported in the thread "Re: kernel BUG at
> fs/btrfs/extent_io.c:1890!". You might want to monitor that thread to
> get the fix for it as early as possible.
>
>>
>> I have also grabbed the latest version of btrfs-progs since I saw th=
at
>> btrfsck could now repair some corruptions. I built the utilities and
>> executed btrfsck. This is the result of the command:
>> (http://pastebin.com/CEyvy17r) I saw that there was an error occurri=
ng
>> in the code at line 1864, so I commented out that line which had the
>> text: BUG_ON(rec->is_root);
>> I then recompiled the utilities and executed btrfsck again and got
>> this: (http://pastebin.com/ihYmuCAm) I also tried btrfsck with the
>> repair option with these results: (http://pastebin.com/gnrStyqh)
>>
>> Another thing that I have experimented with is btrfs-restore. I have
>> been somewhat successful in using this tool to restore the files. Th=
e
>> main problem that I have is that it cannot restore over half of the
>> files on the array and just puts an empty file with a size of 0. It
>> does restore the other half of the array perfectly. On the files tha=
t
>> it cannot restore, it returns a return code of -3. For example, here
>> is an example of a file which is unable to be restored by this tool:
>> (http://pastebin.com/Rg5a0xdG) I read more about this tool here
>> (http://btrfs.ipv5.de/index.php?title=3DRestore) I tried this tool w=
ith
>> '-u 1' and '-u 2' flags, which did not help anything. I do not think
>> that half of my array is corrupted since it was just a power failure
>> and the drive is also mirrored, which should provide some redundancy=
=2E
>
> And btrfsck is not 100% finished yet, as far as I understood it. Ther=
e
> is always room for improvement. To wait some more time might be a goo=
d idea.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
