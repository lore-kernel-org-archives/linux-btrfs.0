Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33050 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbEFPwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 11:52:16 -0400
Received: by iepj10 with SMTP id j10so14199425iep.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 08:52:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5549DF66.5090900@cn.fujitsu.com>
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
	<5549CCD8.2010000@cn.fujitsu.com>
	<CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>
	<5549DF66.5090900@cn.fujitsu.com>
Date: Wed, 6 May 2015 09:52:15 -0600
Message-ID: <CAJCQCtSYbumV4-SPXRCxTzb0gXw6NaLYrNUCC79bz7eUNOiSPw@mail.gmail.com>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        anonymous_temp_mail@yahoo.co.jp
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 6, 2015 at 3:31 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Maybe the default kernel probe routine has some problem?
>
> Would you please try 'btrfs fi show <device>' to test the offline
> probe routine?
> Also, did you update your kernel and didn't reboot?
>
> P.S. Add CC to one of my personal mail address to this case.

*sigh* no much more stupid user error than that: I wasn't root but
thought I was. Obviously it was too late and I should have going to
bed before hitting Send.

So it works fine so long as the user is too.



-- 
Chris Murphy
