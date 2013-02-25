Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59476 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3BYTq1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 14:46:27 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EAA087C0401
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 12:46:26 -0700 (MST)
Date: Mon, 25 Feb 2013 14:46:24 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Mace Moneta <moneta.mace@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718
 map_private_extent_buffer+0xd4/0xe0 [btrfs]()
Message-ID: <20130225194624.GC19641@localhost.localdomain>
References: <CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
 <20130222174401.GF2062@localhost.localdomain>
 <CAMfhy92G2yGh4HeQGq1VYVZ=pr2VkH+6yT86ZwfnLvxrUY=Wyg@mail.gmail.com>
 <20130222181017.GG2062@localhost.localdomain>
 <CAMfhy924GJHkxTmy2bDZc=TaYD9ivyg6Q8LBN=+9_m6Xo=tnag@mail.gmail.com>
 <CAMfhy90toxsRFFQVB-3kotm4zyoCJDOFknq-AUegaCsia2pazg@mail.gmail.com>
 <20130222194021.GH2062@localhost.localdomain>
 <CAMfhy91HiiJwy8iQKLJzjGj=oqbAqisNxb67JQMRkcpKJTwvug@mail.gmail.com>
 <20130225191236.GA19641@localhost.localdomain>
 <CAMfhy930iLRwh07gcPwptoxqXE8mg_HoLtzZgibn4GMnhnVzPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMfhy930iLRwh07gcPwptoxqXE8mg_HoLtzZgibn4GMnhnVzPw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 12:21:30PM -0700, Mace Moneta wrote:
> On Mon, Feb 25, 2013 at 2:12 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> 
> >
> > Is there any chance you got the line above [ cut here ]?  (I hate that stupid [
> > cut here ], it makes us miss all the usefull info.)  Thanks,
> >
> > Josef
> 
> There was really nothing significant above the 'cut here'.  Here it is
> with over an hour of earlier context:
>

Sigh, I don't know why this warn_on(1, printk) isn't doing it's job.  Here is a
debug patch, please capture the output from this so I can figure out what is
going on.  Thanks,

Josef

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 66f999b..eed5554 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4715,9 +4715,10 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	}
 
 	if (start + min_len > eb->len) {
-		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
+		printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
 		       "wanted %lu %lu\n", (unsigned long long)eb->start,
 		       eb->len, start, min_len);
+		WARN_ON(1);
 		return -EINVAL;
 	}
 
