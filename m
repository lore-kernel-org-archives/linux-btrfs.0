From: James Smith <smithjd15@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 22:51:33 -0600
Message-ID: <AANLkTinrujaWqN8NLNdaydL=ENOrMEgb9cjWdDD_g6GT@mail.gmail.com>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
	<201008201403.41330.kreijack@libero.it>
	<AANLkTinfTtUvYSf7u0F8vE4BK_7891u1Cr7irc8FdUaa@mail.gmail.com>
	<4C6ECAA3.6010601@gmail.com>
	<AANLkTikuDusJPbd9QZA80mgvHWVV+y+Q-=qcn1kXq8et@mail.gmail.com>
	<4C6ED0C8.2080505@gmail.com>
	<AANLkTik=t4mWvSOzLbFR3M7RbxgS=9WAFraj3XUguMLF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Philipp <philipp.andreas@gmail.com>, kreijack@libero.it,
	linux-btrfs@vger.kernel.org
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik=t4mWvSOzLbFR3M7RbxgS=9WAFraj3XUguMLF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Truthfully, this is probably this first I've actually done in C++; I
used to do PHP and a small amount of Javascript. I like that the tool
has seen some work and decided to at least attempt a bit more work
towards a decent tool.

Re: ERR codes. I don't know if a uniform approach is what's needed for
*nix usability. However should the codes end up unified to start with
or should there be some variety in how the single tool functions? I
don't know right now how much work it would be to roll fsck into it
and by that time the tool is done and the error codes would have to be
adjusted. The reason for the variety is simply from what I was able to
pull out of the style of coding vs. the function of the tool. Btrfsctl
wasn't really designed with a clean purpose in mind, i.e. the code
isn't as modular as could be expected for uniform functioning against
it's filesystem's role. The tools included by most filesystems in
Linux are already an afterthought with functional but poor
implementation. If reiserfs fell out of the sky as a model filesystem,
btrfsctl fell out of the sky as a model filesystem tool. I'd like to
keep the error-codes ambiguous to allow some expansion room for future
work. It's still an improvement over simply reporting 'error'.

Re: VFS-2593. I think it's a useless little change that probably
doesn't need to be there at all. As far as modelizing the tool
structure it might have some merit. Otherwise I don't know what isn't
feasible from a practicality standpoint as far as what other model
tools are included into the binary that relate to btrfs alone. How
long until Linux has a library for common filesystem operations, for
example? How does one differentiate the tools between filesystems? If
I were to choose a decent way to class tools I would probably break
the program to the point where it's functional and still has the
ability to exhibit new ideas; I don't know any other filesystem tool
that's had the same exposure on this side of the fence.

The poet in question actually ended up on a plaque for the Excelsior
starship of Star Trek fame, and I always kind of liked it. I sort of
don't see any reason to realistically retain it, though it might be
worth as a nonsensical psychological distraction to remember while a
filesystem is being tampered with. :)

I'll look at a error.txt file (after finding convention) and also
update the man. In regards to shortening of dev/device -- is this
really neccessary? And what harm does this cause in the first place?
In device add-delete functionality.


On 8/20/10, Josh Berry <des@condordes.net> wrote:
> On Fri, Aug 20, 2010 at 12:00, Andreas Philipp
> <philipp.andreas@gmail.com> wrote:
>>  On 20.08.2010 20:49, Josh Berry wrote:
>>>
>>> On Fri, Aug 20, 2010 at 11:34, Andreas Philipp
>>> <philipp.andreas@gmail.com>  wrote:
>>>>
>>>>  On 20.08.2010 20:27, Josh Berry wrote:
>>>>>
>>>>> On Fri, Aug 20, 2010 at 05:03, Goffredo Baroncelli<kreijack@gmail.com>
>>>>>  wrote:
>>>>>>
>>>>>> On Thursday, 19 August, 2010, James Smith wrote:
>>>>>>>
>>>>>>> This patch randomizes the error codes and also fixes up some typos
>>>>>>
>>>>>> including
>>>>>>>
>>>>>>> capitalization in the output.
>>>>>>>
>>>>>>> It would almost be nice to see a translation effort for the tool as
>>>>>>> well.
>>>>>
>>>>> [...]
>>>>>>
>>>>>> +                       fprintf(stderr, "ERR-A.11: in command '");
>>>>>>
>>>>>> I am not against this kind of error codes, but I prefer
>>>>>>
>>>>>> +                       fprintf(stderr, "Error 'ERR-A.11' in command
>>>>>> '");
>>>>>
>>>>> As a layman/end user, I disagree.  The former format is easier for
>>>>> shell scripts and the like to parse -- the error code can be extracted
>>>>> with a simple "cut -d: -f1".
>>>>
>>>> This makes no difference. A simple `cut -d " " -f1` would do the job in
>>>> the
>>>> second case.
>>>
>>> I think you meant -f2, and that still leaves the quotes hanging
>>> around.  So you'd need to cut -d" " -f2 |tr -d "'" .  It's not a big
>>> deal either way, I just think the former is easier to work with.
>>
>> Sorry, of course -f2. But why not simply cut -d "'" -f 2?
>
> Oh right, good point. :)  Though as Goffredo said, using the error
> code is probably better anyway.
>
> -- Josh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
