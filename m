From: John Dong <jdong@ubuntu.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 13:42:46 -0400
Message-ID: <DEABA03B-2896-484C-8DF9-F62E3E5AD342@ubuntu.com>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se> <4AD35667.3020103@hp.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed	delsp=yes
Cc: =?iso-8859-1?Q?P=E4r_Andersson?= <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD35667.3020103@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 12, 2009, at 12:16 PM, jim owens wrote:

> P=E4r Andersson wrote:
>> I just ran into the max hard link per directory limit, and remembere=
d
>> this thread. I get EMLINK when trying to create more than 311 (not =20
>> 272)
>> links in a directory, so at least the BUG() is fixed.
>> What is the reason for the limit, and is there any chance of =20
>> increasing
>> it to something more reasonable as Mikhail suggested?
>> For comparison I tried to create 200k hardlinks to the the same =20
>> file in
>> the same directory on btrfs, ext4, reiserfs and xfs:
>
> what real-world application uses and needs this many hard links?
>
> jim

I don't think that's a good counterargument for why this is not a bug.

Can't think of any off the top of my head for Linux, but definitely in =
=20
OS X Time Machine can easily create 200+ hardlinks.--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
