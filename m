From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Fri, 25 Feb 2011 11:11:18 -0600
Message-ID: <AANLkTinrD1vu7NVUGCsqvaB6KroeeLPQV3M9QJh0OKUK@mail.gmail.com>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
	<201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
	<1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com>
	<201102020034.43808.johannes.hirte@fem.tu-ilmenau.de>
	<1865303E0DED764181A9D882DEF65FB68621CA7167@shsmsx502.ccr.corp.intel.com>
	<1298028713.11103.13.camel@mainframe>
	<1865303E0DED764181A9D882DEF65FB686421B24FB@shsmsx502.ccr.corp.intel.com>
	<1298559118.11224.40.camel@mainframe>
	<AANLkTimkEGAGjY17FX_EFGwo6RJEoEfQ3WdKhNUymSE+@mail.gmail.com>
	<1298563230-sup-9619@think>
	<AANLkTi=gn+713wttLh+iZQqOQXAvkW2bEE7c=rGKurXs@mail.gmail.com>
	<1298564340-sup-3124@think>
	<AANLkTi=qUV6TQJbJQ-JAeQ3PFRZpCwAYn4SnbrS89XM9@mail.gmail.com>
	<AANLkTinvyb-bTVVignd1KGojvh-QrYCFmCnwYKBsYC_2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinvyb-bTVVignd1KGojvh-QrYCFmCnwYKBsYC_2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 24, 2011 at 5:14 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Thu, Feb 24, 2011 at 10:32 AM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> On Thu, Feb 24, 2011 at 10:19 AM, Chris Mason <chris.mason@oracle.co=
m> wrote:
>>> Excerpts from Mitch Harder's message of 2011-02-24 11:03:07 -0500:
>>>> On Thu, Feb 24, 2011 at 10:00 AM, Chris Mason <chris.mason@oracle.=
com> wrote:
>>>> > Excerpts from Mitch Harder's message of 2011-02-24 10:55:15 -050=
0:
>>>> >> 2011/2/24 Maria Wikstr=F6m <maria@ponstudios.se>:
>>>> >> > m=E5n 2011-02-21 klockan 09:51 +0800 skrev Zhong, Xin:
>>>> >> >> The backtrace in your attachment looks like a known bug of 2=
=2E6.37 which have already been fixed in 2.6.38. I have no idea why lat=
est btrfs still hang in your environment if there's no debug info...
>>>> >> >>
>>>> >> >
>>>> >> > Haha, yes that's very hard :)
>>>> >> >
>>>> >> > 2.6.38-rc6 and btrfs-unstable behaves the same way. I can clo=
se the
>>>> >> > process with ctrl+c and it disappear a few seconds later. The=
re is no
>>>> >> > CPU usage. Reading works because I can start htop and watch "=
svn info"
>>>> >> > disappear, but everything writing to btrfs slows down to a cr=
awl. It
>>>> >> > takes about 1 minute to log in. So I had to put the logs on a=
n other
>>>> >> > partition using ext3 to get the output from sysrq+t.
>>>> >> >
>>>> >>
>>>> >> I believe I've been experiencing this issue also. =A0However, m=
y problem
>>>> >> usually results in a "No space left on device" error rather tha=
n a
>>>> >> lock-up or crash. =A0But I've bisected my issue to this patch, =
and my
>>>> >> "btrfs fi show" and "btrfs fi df" looks similar to others who'v=
e
>>>> >> posted to this tread with all my space being allocated, but not=
 used.
>>>> >>
>>>> >
>>>> > Sorry, which patch did you bisect the problem down to?
>>>> >
>>>>
>>>> The patch at the head of this thread:
>>>>
>>>> Btrfs: pwrite blocked when writing from the mmaped buffer of the s=
ame page
>>>
>>> Hmmm, that patch shouldn't be changing our performance under delall=
oc
>>> pressure, and it really shouldn't impact early enospc.
>>>
>>
>> I've bisected this issue around where this patch went into git, and
>> I've also constructed a testing patch that reverts this patch, and
>> placed it on top of the current Btrfs git sources (I understand this
>> patch addresses a real issue, this was just for testing).
>>
>> It could be that this patch just "uncovers" another problem, but all
>> my tests seem to point to this patch triggering this issue.
>>
>
> I don't belief the previous ftrace I supplied had a large enough scop=
e
> to capture the issue.
>
> I've expanded my ftrace buffer, and filtered out everything but btrfs=
*
> function calls ("# echo btrfs* >
> /sys/kernel/debug/tracing/set_ftrace_filter").
>
> In this trace, I see btrfs spending a great deal of time in a while
> loop (while (iov_iter_count(&i) > 0) {)) in the btrfs_file_aio_write(=
)
> function in file.c without exiting the function.
>
> I'm going to try to inject some debugging trace_printk() statements t=
o
> find if that portion of code is proceeding normally with my test case=
=2E
>
> I've put my expanded trace up on my local server, but my upload
> bandwidth is pretty sad, and it may take a few minutes to transfer
> even though it's only a 6MB file.
>
> http://dontpanic.dyndns.org/trace-openmotif-btrfs-v3.gz
>

Apologies for only hitting "Reply" instead of "Reply-All" on my last me=
ssage.

I've inserted additional trace_printk() to the btrfs_file_aio_write()
and btrfs_copy_from_user() function in file.c in order to characterize
the problem I've been encountering.

I can see btrfs getting stuck in a loop in the "while
(iov_iter_count(&i) > 0) {}" portion of the btrfs_file_aio_write()
function.

The loop is more-or-less following this process (from within the
"while (iov_iter_count(&i) > 0) {}" loop):

(1) Reserve some space with btrfs_delalloc_reserve_space()
(2) Prepare the reserved space with prepare_pages()
(3) Call btrfs_copy_from_user() to copy to the prepared space.
-------------> From btrfs_copy_from_user()
(4) ........Try to copy with copied =3D iov_iter_copy_from_user_atomic(=
)
(5) ........The above operation results with copied =3D=3D 0. Break and
return with a return value of 0 bytes copied.
(6) There is no special handling for copied =3D=3D 0 in the "while
(iov_iter_count(&i) > 0) {}" loop, so it loops back around, reserves
some more space, and tries again.

If I look back at how the code was set up before the patch at the head
of this thread was applied (Btrfs: pwrite blocked when writing from
the mmaped buffer of the same page), the btrfs_copy_from_user()
function had some handling for "copied =3D=3D 0" that would change the
scope of the amount to write, and loop back to try the write again.

I attempted to construct a patch that just reverted the handling for
"copied =3D=3D 0" in btrfs_copy_from_user(), however, that just resulte=
d
in my computer locking up when it reached the point where it was
previously beginning to allocate disk space.

So, I apologize for not having a patch to address the issue I'm
seeing, but I hope I've added some insight.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
