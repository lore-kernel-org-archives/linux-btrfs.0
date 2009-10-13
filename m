From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 21:42:29 -0600
Message-ID: <f8b56362b89afa9624bd9439c0f81456@smtp.arbitraryconstant.com>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se> <4AD35667.3020103@hp.com> <DEABA03B-2896-484C-8DF9-F62E3E5AD342@ubuntu.com> <4AD372A7.2020907@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: John Dong <jdong@ubuntu.com>,
	=?UTF-8?Q?P=C3=A4r_Andersson?= <paran@lysator.liu.se>,
	<linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD372A7.2020907@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

jim owens wrote:
> P=C3=A4r Andersson wrote:
snip...
> what real-world application uses and needs this many hard links?

I don't know about hundreds of thousands of hard links, but doesn't
busybox use large numbers of hard links in the same directories
(eg one for everything in /bin)?

jim owens wrote:
snip...
> so 311 is 50% than the app uses... plenty of growth.

That would be a worryingly small number even if it weren't less
for long filenames, and even if someone out there weren't inevitably
using more. Should scalability limits this hard to change really be
set this close to real-world use cases?

A format change now is easier than a format change when everyone is
using BTRFS for their root filesystem.

-Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
