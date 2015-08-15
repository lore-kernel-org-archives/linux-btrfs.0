Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35697 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbbHODlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 23:41:32 -0400
Received: by igbjg10 with SMTP id jg10so24384427igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 20:41:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU9vTap5JdkhCDNB=6BC4_fsU-6MCmS3QiFP1Mu2C7yjng@mail.gmail.com>
References: <CAK7bmU9vTap5JdkhCDNB=6BC4_fsU-6MCmS3QiFP1Mu2C7yjng@mail.gmail.com>
Date: Fri, 14 Aug 2015 23:41:31 -0400
Message-ID: <CAK7bmU-a6W1UaPf31WargEGzQdWH7-GDN9Vd1h_1GnQwv-_FsQ@mail.gmail.com>
Subject: Re: "delete missing" with two missing devices doesn't delete both
 missing, only does a partial reconstruction
From: Timothy Normand Miller <theosib@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW, when this is all over with, how do I make sure there are really
two copies of everything?  Will a scrub verify this?  Should I run a
balance operation?

On Fri, Aug 14, 2015 at 11:29 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> After applying Anand's patch, I was able to mount my 4-drive RAID1 and
> bring a new fourth drive online.  However, something weird happened
> where the first "delete missing" only deleted one missing drive and
> only did a partial duplication.  I've posted a bug report here:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=102901
>
> --
> Timothy Normand Miller, PhD
> Assistant Professor of Computer Science, Binghamton University
> http://www.cs.binghamton.edu/~millerti/
> Open Graphics Project



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
