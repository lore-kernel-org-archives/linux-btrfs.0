From: Brian Brunswick <brian.brunswick@gmail.com>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 13 Oct 2009 10:08:38 +0100
Message-ID: <6f680f6d0910130208m38c687aakc3cf4c0b355f699b@mail.gmail.com>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
	<87my3y3r8u.fsf@faran.nsc.liu.se> <4AD35667.3020103@hp.com>
	<DEABA03B-2896-484C-8DF9-F62E3E5AD342@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jim owens <jowens@hp.com>,
	=?ISO-8859-1?Q?P=E4r_Andersson?= <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <DEABA03B-2896-484C-8DF9-F62E3E5AD342@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/10/12 John Dong <jdong@ubuntu.com>:
>
> On Oct 12, 2009, at 12:16 PM, jim owens wrote:
>
>> P=E4r Andersson wrote:
>>>
>>> I just ran into the max hard link per directory limit, and remember=
ed
>>> this thread. I get EMLINK when trying to create more than 311 (not =
272)
>>> links in a directory, so at least the BUG() is fixed.
>>> What is the reason for the limit, and is there any chance of increa=
sing
>>> it to something more reasonable as Mikhail suggested?
>>> For comparison I tried to create 200k hardlinks to the the same fil=
e in
>>> the same directory on btrfs, ext4, reiserfs and xfs:
>>
>> what real-world application uses and needs this many hard links?
>>
>> jim
>
> I don't think that's a good counterargument for why this is not a bug=
=2E
>
> Can't think of any off the top of my head for Linux, but definitely i=
n OS X
> Time Machine can easily create 200+ hardlinks.--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

As a lurker, I've actually got a real-world example of something I do
that would probably hit this.

Its was hinted at before - web urls are sometimes rediculously long. I
run a web archiver on my router box that saves every http url I hit to
a file named after its url with a date appended. But then I
periodically run a de-duplicator on the saved stuff, which hard-links
together all files with the same contents (except empty ones)

I bet there are lots of examples that would exceed this limit within th=
ose dirs.

--=20
Brian_Brunswick____brian@ithil.org____Wit____Disclaimer____!Shortsig_ru=
les!
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
